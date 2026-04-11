import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/contracts/homes/shopping_photo_capture.dart';
import 'package:kinly/contracts/paywall/enums/paywall_gate_status.dart';
import 'package:kinly/contracts/paywall/enums/paywall_retry_action.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/ui/paywall/paywall_gate.dart';
import 'package:kinly/core/ui/paywall/paywall_sources.dart';

part 'shopping_item_event.dart';
part 'shopping_item_state.dart';

class ShoppingItemBloc extends Bloc<ShoppingItemEvent, ShoppingItemState> {
  ShoppingItemBloc({
    required String homeId,
    ShoppingListItem? item,
    required HomeUnitsRepository homeUnitsRepository,
    required ShoppingListRepository shoppingListRepository,
    Logger? logger,
  }) : _homeId = homeId,
       _item = item,
       _homeUnitsRepository = homeUnitsRepository,
       _shoppingListRepository = shoppingListRepository,
       _logger = logger ?? const DebugLogger(),
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
    on<ShoppingItemScopeChangedEvent>(_onShoppingItemScopeChanged);
    on<ShoppingItemPhotoCaptureRequestedEvent>(_onShoppingItemPhotoCaptureRequested);
    on<ShoppingItemPhotoRecoveryRequestedEvent>(_onShoppingItemPhotoRecoveryRequested);
    on<ShoppingItemUnitContextRequestedEvent>(_onShoppingItemUnitContextRequested);
    on<SubmitShoppingItemEvent>(_onSubmitShoppingItem);
    on<DeleteShoppingItemEvent>(_onDeleteShoppingItem);
    on<ShoppingItemPaywallOpenedEvent>(_onShoppingItemPaywallOpened);
    on<ShoppingItemPaywallResolvedEvent>(_onShoppingItemPaywallResolved);
  }

  final String _homeId;
  final ShoppingListItem? _item;
  final HomeUnitsRepository _homeUnitsRepository;
  final ShoppingListRepository _shoppingListRepository;
  final Logger _logger;
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

  void _onShoppingItemScopeChanged(
    ShoppingItemScopeChangedEvent event,
    Emitter<ShoppingItemState> emit,
  ) {
    emit(
      state.copyWith(
        selectedScopeType: event.scopeType,
        selectedUnitId: event.unitId,
      ),
    );
  }

  Future<void> _onShoppingItemPhotoCaptureRequested(
    ShoppingItemPhotoCaptureRequestedEvent event,
    Emitter<ShoppingItemState> emit,
  ) async {
    if (state.isUploadingPhoto) return;
    _logger.info(
      'Shopping photo capture started. homeId=$_homeId itemId=${_item?.id}',
      tag: 'ShoppingPhoto',
    );
    emit(state.copyWith(isUploadingPhoto: true, clearPhotoError: true));
    try {
      final path = await _shoppingListRepository.captureAndUploadPhoto(homeId: _homeId);
      if (path == null) {
        _logger.info(
          'Shopping photo capture cancelled. homeId=$_homeId itemId=${_item?.id}',
          tag: 'ShoppingPhoto',
        );
        emit(state.copyWith(isUploadingPhoto: false));
        return;
      }
      _logger.info(
        'Shopping photo capture succeeded. homeId=$_homeId itemId=${_item?.id} '
        'storagePath=$path',
        tag: 'ShoppingPhoto',
      );
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
        _logger.error(
          'Shopping photo upload failed. homeId=$_homeId itemId=${_item?.id}',
          tag: 'ShoppingPhoto',
          error: error,
        );
        emit(
          state.copyWith(
            isUploadingPhoto: false,
            photoErrorMessage: error.message,
            photoErrorTick: state.photoErrorTick + 1,
          ),
        );
        return;
      }
      _logger.warn(
        'Shopping photo permission denied. homeId=$_homeId itemId=${_item?.id} '
        'permanentlyDenied=${error.permanentlyDenied}',
        tag: 'ShoppingPhoto',
        error: error,
      );
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          photoErrorMessage: 'permission',
          photoErrorTick: state.photoErrorTick + 1,
          cameraPermissionPermanentlyDenied: error.permanentlyDenied,
        ),
      );
    } catch (error) {
      _logger.error(
        'Shopping photo capture failed unexpectedly. homeId=$_homeId '
        'itemId=${_item?.id}',
        tag: 'ShoppingPhoto',
        error: error,
      );
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          photoErrorMessage: error.toString(),
          photoErrorTick: state.photoErrorTick + 1,
        ),
      );
    }
  }

  Future<void> _onShoppingItemPhotoRecoveryRequested(
    ShoppingItemPhotoRecoveryRequestedEvent event,
    Emitter<ShoppingItemState> emit,
  ) async {
    if (state.isUploadingPhoto) return;
    emit(state.copyWith(isUploadingPhoto: true, clearPhotoError: true));
    try {
      final path = await _shoppingListRepository.recoverPendingPhotoUpload(
        homeId: _homeId,
      );
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
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          photoErrorMessage: error.message,
          photoErrorTick: state.photoErrorTick + 1,
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

  Future<void> _onShoppingItemUnitContextRequested(
    ShoppingItemUnitContextRequestedEvent event,
    Emitter<ShoppingItemState> emit,
  ) async {
    emit(state.copyWith(isLoadingUnitContext: true));
    try {
      final context = await _homeUnitsRepository.getMyUnitContext(homeId: _homeId);
      emit(
        state.copyWith(
          isLoadingUnitContext: false,
          unitContext: context,
          selectedScopeType:
              state.selectedScopeType == ShoppingItemScopeType.unit
                  ? ShoppingItemScopeType.unit
                  : ShoppingItemScopeType.house,
          selectedUnitId:
              state.selectedScopeType == ShoppingItemScopeType.unit
                  ? (state.selectedUnitId ?? context.shoppingAlternateUnit.unitId)
                  : context.shoppingAlternateUnit.unitId,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingUnitContext: false));
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
          scopeType: state.selectedScopeType,
          unitId: state.selectedScopeType == ShoppingItemScopeType.unit
              ? state.selectedUnitId
              : null,
        );
        emit(
          state.copyWith(
            isSubmitting: false,
            successItemId: created.item.id,
            purchaseMemoryReminder: created.purchaseMemory,
            purchaseMemoryTick: state.purchaseMemoryTick + 1,
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
        scopeType: state.selectedScopeType,
        unitId: state.selectedScopeType == ShoppingItemScopeType.unit
            ? state.selectedUnitId
            : null,
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
              triggers: const {PaywallTrigger.shoppingPhotosCap},
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
      await _shoppingListRepository.archiveItem(itemId: item.id);
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
