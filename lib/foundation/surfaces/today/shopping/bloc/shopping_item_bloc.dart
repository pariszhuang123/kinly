import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/contracts/homes/shopping_photo_capture.dart';
import 'package:kinly/contracts/paywall/enums/paywall_gate_status.dart';
import 'package:kinly/contracts/paywall/enums/paywall_retry_action.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/ui/paywall/paywall_gate.dart';
import 'package:kinly/core/ui/paywall/paywall_sources.dart';

part 'shopping_item_event.dart';
part 'shopping_item_state.dart';

class ShoppingItemBloc extends Bloc<ShoppingItemEvent, ShoppingItemState> {
  ShoppingItemBloc({
    required String homeId,
    ShoppingListItem? item,
    required ShoppingListRepository shoppingListRepository,
  }) : _homeId = homeId,
       _item = item,
       _shoppingListRepository = shoppingListRepository,
       _uuid = const Uuid(),
       super(
         ShoppingItemState.initial(
           item: item,
            isEditing: item != null,
            referencePhotoUrl: shoppingListRepository.toPublicPhotoUrl(
              item?.referencePhotoPath,
            ),
         ),
       ) {
    on<ShoppingItemNameChangedEvent>(_onShoppingItemNameChanged);
    on<ShoppingItemQuantityChangedEvent>(_onShoppingItemQuantityChanged);
    on<ShoppingItemDetailsChangedEvent>(_onShoppingItemDetailsChanged);
    on<ShoppingItemPhotoCaptureRequestedEvent>(_onShoppingItemPhotoCaptureRequested);
    on<SubmitShoppingItemEvent>(_onSubmitShoppingItem);
    on<DeleteShoppingItemEvent>(_onDeleteShoppingItem);
    on<ShoppingItemPaywallOpenedEvent>(_onShoppingItemPaywallOpened);
    on<ShoppingItemPaywallResolvedEvent>(_onShoppingItemPaywallResolved);
  }

  final String _homeId;
  final ShoppingListItem? _item;
  final ShoppingListRepository _shoppingListRepository;
  final Uuid _uuid;

  void _onShoppingItemNameChanged(
    ShoppingItemNameChangedEvent event,
    Emitter<ShoppingItemState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onShoppingItemQuantityChanged(
    ShoppingItemQuantityChangedEvent event,
    Emitter<ShoppingItemState> emit,
  ) {
    emit(state.copyWith(quantity: event.quantity));
  }

  void _onShoppingItemDetailsChanged(
    ShoppingItemDetailsChangedEvent event,
    Emitter<ShoppingItemState> emit,
  ) {
    emit(state.copyWith(details: event.details));
  }

  Future<void> _onShoppingItemPhotoCaptureRequested(
    ShoppingItemPhotoCaptureRequestedEvent event,
    Emitter<ShoppingItemState> emit,
  ) async {
    if (state.isUploadingPhoto) return;
    emit(state.copyWith(isUploadingPhoto: true, clearPhotoError: true));
    try {
      final path = await _shoppingListRepository.captureAndUploadPhoto(homeId: _homeId);
      if (path == null) {
        emit(state.copyWith(isUploadingPhoto: false));
        return;
      }
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          referencePhotoPath: path,
          referencePhotoUrl: _shoppingListRepository.toPublicPhotoUrl(path),
          hasPhotoChanged: true,
          clearPhotoError: true,
        ),
      );
    } on ShoppingPhotoCaptureException catch (error) {
      if (error.kind != ShoppingPhotoCaptureErrorKind.permission) {
        emit(
          state.copyWith(
            isUploadingPhoto: false,
            photoErrorMessage: error.message,
            photoErrorTick: state.photoErrorTick + 1,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          photoErrorMessage: 'permission',
          photoErrorTick: state.photoErrorTick + 1,
          cameraPermissionPermanentlyDenied: error.permanentlyDenied,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          photoErrorMessage: error.toString(),
          photoErrorTick: state.photoErrorTick + 1,
        ),
      );
    }
  }

  Future<void> _onSubmitShoppingItem(
    SubmitShoppingItemEvent event,
    Emitter<ShoppingItemState> emit,
  ) async {
    if (state.name.trim().isEmpty) {
      emit(state.copyWith(showValidationErrors: true));
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        showValidationErrors: true,
        clearSubmissionError: true,
        clearSuccess: true,
      ),
    );

    try {
      if (_item == null) {
        final created = await _shoppingListRepository.addItem(
          homeId: _homeId,
          name: state.name.trim(),
          quantity: _normalizeOptional(state.quantity),
          details: _normalizeOptional(state.details),
          referencePhotoPath: _normalizeOptional(state.referencePhotoPath),
        );
        emit(
          state.copyWith(
            isSubmitting: false,
            successItemId: created.id,
            showValidationErrors: false,
          ),
        );
        return;
      }

      final hadPhotoBefore = (_item.referencePhotoPath ?? '').trim().isNotEmpty;
      final hasPhotoChanged = state.hasPhotoChanged;
      final nextPhoto = _normalizeOptional(state.referencePhotoPath);
      await _shoppingListRepository.updateItem(
        itemId: _item.id,
        name: state.name.trim(),
        quantity: _normalizeOptional(state.quantity),
        details: _normalizeOptional(state.details),
        referencePhotoPath: hasPhotoChanged ? nextPhoto : null,
        replacePhoto: hadPhotoBefore && hasPhotoChanged,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          successItemId: _item.id,
          showValidationErrors: false,
        ),
      );
    } catch (error) {
      if (_shoppingListRepository.isPhotoLimitError(error)) {
        final tick = state.paywallRequestTick + 1;
        emit(
          state.copyWith(
            isSubmitting: false,
            clearSubmissionError: true,
            paywallRequestTick: tick,
            paywallAction: PaywallRetryAction.submit,
            paywallRequest: PaywallGateRequest(
              requestId: _uuid.v4(),
              homeId: _homeId,
              source: PaywallSources.shoppingPhotoCap,
              action: PaywallRetryAction.submit,
              tick: tick,
              triggers: const {PaywallTrigger.flowPhotosCap},
            ),
            paywallInFlightRequestId: null,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          isSubmitting: false,
          submissionErrorMessage: error.toString(),
          submissionErrorTick: state.submissionErrorTick + 1,
        ),
      );
    }
  }

  Future<void> _onDeleteShoppingItem(
    DeleteShoppingItemEvent event,
    Emitter<ShoppingItemState> emit,
  ) async {
    final item = _item;
    if (item == null) return;
    emit(state.copyWith(isSubmitting: true, clearSubmissionError: true));
    try {
      await _shoppingListRepository.archiveItemsForUser(
        homeId: _homeId,
        itemIds: <String>[item.id],
      );
      emit(state.copyWith(isSubmitting: false, successItemId: item.id));
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submissionErrorMessage: error.toString(),
          submissionErrorTick: state.submissionErrorTick + 1,
        ),
      );
    }
  }

  void _onShoppingItemPaywallOpened(
    ShoppingItemPaywallOpenedEvent event,
    Emitter<ShoppingItemState> emit,
  ) {
    emit(state.copyWith(paywallInFlightRequestId: event.requestId));
  }

  void _onShoppingItemPaywallResolved(
    ShoppingItemPaywallResolvedEvent event,
    Emitter<ShoppingItemState> emit,
  ) {
    emit(state.copyWith(paywallInFlightRequestId: null));
    if (event.outcome.status == PaywallGateStatus.granted &&
        event.outcome.action == PaywallRetryAction.submit) {
      add(const SubmitShoppingItemEvent());
    }
  }

  static String? _normalizeOptional(String? value) {
    final trimmed = (value ?? '').trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
