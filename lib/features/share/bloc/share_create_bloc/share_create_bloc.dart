import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../../contracts/expenses/models.dart';
import '../../../../contracts/homes/home_units_models.dart';
import '../../../../contracts/homes/ports/shopping_list_repository.dart';
import '../../../../contracts/homes/ports/home_units_repository.dart';
import '../../../../contracts/share/share_create_route_args.dart';
import '../../../../core/media/expectation_photo_service.dart';
import '../../../../core/media/supabase_media_repository.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import '../../../../core/supabase/supabase_error_mapper.dart';
import 'package:kinly/contracts/paywall/enums/paywall_retry_action.dart';
import 'package:kinly/contracts/paywall/enums/paywall_gate_status.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/ui/paywall/paywall_gate.dart';
import 'package:kinly/core/ui/paywall/paywall_sources.dart';
import '../../domain/share_create_form.dart';
import '../../domain/share_participant.dart';
import '../../domain/share_split_mode.dart';

part 'share_create_event.dart';
part 'share_create_state.dart';
part 'share_create_setup.dart';
part 'share_create_validation.dart';
part 'share_create_submission.dart';
part 'share_create_submission_helpers.dart';

const String _shareCreateUnresolvedMemberMessage =
    'Selected members could not be resolved. Reopen the bill and try again.';

class ShareCreateBloc extends Bloc<ShareCreateEvent, ShareCreateState> {
  ShareCreateBloc({
    required String homeId,
    required ExpensesRepository expensesRepository,
    required HomeRepository homeRepository,
    required HomeUnitsRepository homeUnitsRepository,
    ShoppingListRepository? shoppingListRepository,
    ShareCreateForm? initialForm,
    String? editingExpenseId,
    String? planStatus,
    String? planId,
    bool amountLocked = false,
    bool allPaid = false,
    bool paidByOther = false,
    bool canEdit = true,
    String? editDisabledReason,
    ExpectationPhotoService? evidencePhotoService,
    ShareShoppingExpenseLinkRequest? shoppingExpenseLinkRequest,
  }) : _homeId = homeId,
       _expensesRepository = expensesRepository,
       _homeRepository = homeRepository,
       _homeUnitsRepository = homeUnitsRepository,
       _shoppingListRepository = shoppingListRepository,
       _initialEvidencePhotoPath = initialForm?.evidencePhotoPath.trim() ?? '',
       _evidencePhotoService = evidencePhotoService,
       _shoppingExpenseLinkRequest = shoppingExpenseLinkRequest,
       _uuid = const Uuid(),
       super(
         ShareCreateState.initial(
           form: initialForm,
           isEditing: editingExpenseId != null,
           editingExpenseId: editingExpenseId,
           planStatus: planStatus,
           planId: planId,
           isAmountLocked: amountLocked,
           allPaid: allPaid,
           paidByOther: paidByOther,
           canEdit: canEdit,
           editDisabledReason: editDisabledReason,
         ),
       ) {
    on<ShareCreateParticipantsRequested>(_onParticipantsRequested);
    on<ShareCreateAllocationTargetChanged>(_onAllocationTargetChanged);
    on<ShareCreateUnitToggled>(_onUnitToggled);
    on<ShareCreateUnitCustomAmountChanged>(_onUnitCustomAmountChanged);
    on<ShareCreateDescriptionChanged>(_onDescriptionChanged);
    on<ShareCreateAmountChanged>(_onAmountChanged);
    on<ShareCreateSplitModeChanged>(_onSplitModeChanged);
    on<ShareCreateNotesChanged>(_onNotesChanged);
    on<ShareCreateEvidencePhotoCaptureRequested>(
      _onEvidencePhotoCaptureRequested,
    );
    on<ShareCreateEvidencePhotoRecoveryRequested>(
      _onEvidencePhotoRecoveryRequested,
    );
    on<ShareCreateParticipantToggled>(_onParticipantToggled);
    on<ShareCreateCustomAmountChanged>(_onCustomAmountChanged);
    on<ShareCreateStartDateChanged>(_onStartDateChanged);
    on<ShareCreateRecurrenceToggled>(_onRecurrenceToggled);
    on<ShareCreateRecurrenceEveryChanged>(_onRecurrenceEveryChanged);
    on<ShareCreateRecurrenceUnitChanged>(_onRecurrenceUnitChanged);
    on<ShareCreateSubmitted>(_onSubmitted);
    on<ShareCreateDeleted>(_onDeleted);
    on<ShareCreatePlanTerminationRequested>(_onPlanTerminationRequested);
    on<ShareCreatePaywallOpened>(_onPaywallOpened);
    on<ShareCreatePaywallResolved>(_onPaywallResolved);
  }

  final String _homeId;
  final ExpensesRepository _expensesRepository;
  final HomeRepository _homeRepository;
  final HomeUnitsRepository _homeUnitsRepository;
  final ShoppingListRepository? _shoppingListRepository;
  final String _initialEvidencePhotoPath;
  ExpectationPhotoService? _evidencePhotoService;
  final ShareShoppingExpenseLinkRequest? _shoppingExpenseLinkRequest;
  final Uuid _uuid;

  Future<void> _onParticipantsRequested(
    ShareCreateParticipantsRequested event,
    Emitter<ShareCreateState> emit,
  ) => _handleParticipantsRequested(this, emit);

  void _onAllocationTargetChanged(
    ShareCreateAllocationTargetChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    final nextForm = _resolveAllocationTargetForm(this, event.value);
    emit(state.copyWith(form: nextForm, hasUserEdits: true));
  }

  void _onDescriptionChanged(
    ShareCreateDescriptionChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(description: event.value),
        hasUserEdits: true,
      ),
    );
  }

  void _onAmountChanged(
    ShareCreateAmountChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(amountInput: event.value),
        hasUserEdits: true,
      ),
    );
  }

  void _onSplitModeChanged(
    ShareCreateSplitModeChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    final nextForm = _resolveSplitModeForm(this, event.mode);
    emit(state.copyWith(form: nextForm, hasUserEdits: true));
  }

  void _onNotesChanged(
    ShareCreateNotesChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(notes: event.value),
        hasUserEdits: true,
      ),
    );
  }

  Future<void> _onEvidencePhotoCaptureRequested(
    ShareCreateEvidencePhotoCaptureRequested event,
    Emitter<ShareCreateState> emit,
  ) async {
    if (state.isUploadingEvidencePhoto) return;

    emit(
      state.copyWith(
        isUploadingEvidencePhoto: true,
        clearEvidencePhotoError: true,
        isCameraPermissionPermanentlyDenied: false,
      ),
    );

    try {
      final photoService =
          _evidencePhotoService ??=
              ExpectationPhotoService(
                mediaRepository: SupabaseMediaRepository(),
              );
      final upload = await photoService.captureAndUpload(
        homeId: _homeId,
        choreId: state.editingExpenseId,
        rootSegment: 'share',
        featureSegment: 'expenses',
      );
      emit(
        state.copyWith(
          isUploadingEvidencePhoto: false,
          form: state.form.copyWith(
            evidencePhotoPath: _withHouseholdsPrefix(upload.storagePath),
          ),
          hasUserEdits: true,
          clearEvidencePhotoError: true,
        ),
      );
    } on CameraPermissionException catch (error) {
      emit(
        state.copyWith(
          isUploadingEvidencePhoto: false,
          isCameraPermissionPermanentlyDenied: error.permanentlyDenied,
          evidencePhotoErrorMessage: 'permission',
          evidencePhotoErrorTick: state.evidencePhotoErrorTick + 1,
        ),
      );
    } on CameraCaptureCancelled {
      emit(state.copyWith(isUploadingEvidencePhoto: false));
    } catch (error) {
      emit(
        state.copyWith(
          isUploadingEvidencePhoto: false,
          evidencePhotoErrorMessage: error.toString(),
          evidencePhotoErrorTick: state.evidencePhotoErrorTick + 1,
        ),
      );
    }
  }

  Future<void> _onEvidencePhotoRecoveryRequested(
    ShareCreateEvidencePhotoRecoveryRequested event,
    Emitter<ShareCreateState> emit,
  ) async {
    if (state.isUploadingEvidencePhoto) return;
    emit(
      state.copyWith(
        isUploadingEvidencePhoto: true,
        clearEvidencePhotoError: true,
        isCameraPermissionPermanentlyDenied: false,
      ),
    );
    try {
      final photoService =
          _evidencePhotoService ??=
              ExpectationPhotoService(
                mediaRepository: SupabaseMediaRepository(),
              );
      final upload = await photoService.recoverLostAndUploadIfPending(
        homeId: _homeId,
        choreId: state.editingExpenseId,
        rootSegment: 'share',
        featureSegment: 'expenses',
      );
      if (upload == null) {
        emit(state.copyWith(isUploadingEvidencePhoto: false));
        return;
      }
      emit(
        state.copyWith(
          isUploadingEvidencePhoto: false,
          form: state.form.copyWith(
            evidencePhotoPath: _withHouseholdsPrefix(upload.storagePath),
          ),
          hasUserEdits: true,
          clearEvidencePhotoError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isUploadingEvidencePhoto: false,
          evidencePhotoErrorMessage: error.toString(),
          evidencePhotoErrorTick: state.evidencePhotoErrorTick + 1,
        ),
      );
    }
  }

  void _onParticipantToggled(
    ShareCreateParticipantToggled event,
    Emitter<ShareCreateState> emit,
  ) {
    final form = state.form.updateSelection(event.userId, event.isSelected);
    emit(state.copyWith(form: form, hasUserEdits: true));
  }

  void _onCustomAmountChanged(
    ShareCreateCustomAmountChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    var updated = state.form.updateCustomAmount(event.userId, event.amount);

    final cents = ShareCreateForm.parseCurrency(event.amount);
    final shouldSelect = cents != null && cents > 0;
    final isCurrentlySelected = updated.selectedParticipantIds.contains(
      event.userId,
    );

    if (shouldSelect && !isCurrentlySelected) {
      updated = updated.updateSelection(event.userId, true);
    } else if (!shouldSelect && isCurrentlySelected) {
      updated = updated.updateSelection(event.userId, false);
    }

    emit(state.copyWith(form: updated, hasUserEdits: true));
  }

  void _onUnitToggled(
    ShareCreateUnitToggled event,
    Emitter<ShareCreateState> emit,
  ) {
    final form = state.form.updateUnitSelection(event.unitId, event.isSelected);
    emit(state.copyWith(form: form, hasUserEdits: true));
  }

  void _onUnitCustomAmountChanged(
    ShareCreateUnitCustomAmountChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    var updated = state.form.updateUnitCustomAmount(event.unitId, event.amount);
    final cents = ShareCreateForm.parseCurrency(event.amount);
    final shouldSelect = cents != null && cents > 0;
    final isSelected = updated.selectedUnitIds.contains(event.unitId);
    if (shouldSelect && !isSelected) {
      updated = updated.updateUnitSelection(event.unitId, true);
    } else if (!shouldSelect && isSelected) {
      updated = updated.updateUnitSelection(event.unitId, false);
    }
    emit(state.copyWith(form: updated, hasUserEdits: true));
  }

  void _onStartDateChanged(
    ShareCreateStartDateChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(startDate: event.date),
        hasUserEdits: true,
      ),
    );
  }

  void _onRecurrenceToggled(
    ShareCreateRecurrenceToggled event,
    Emitter<ShareCreateState> emit,
  ) {
    if (!event.isRecurring) {
      emit(
        state.copyWith(
          form: state.form.copyWith(
            clearRecurrenceEvery: true,
            clearRecurrenceUnit: true,
          ),
          hasUserEdits: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        form: state.form.copyWith(
          recurrenceEvery: state.form.recurrenceEvery ?? 1,
          recurrenceUnit:
              state.form.recurrenceUnit ?? ExpenseRecurrenceUnit.week,
        ),
        hasUserEdits: true,
      ),
    );
  }

  void _onRecurrenceEveryChanged(
    ShareCreateRecurrenceEveryChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    final trimmed = event.value.trim();
    final parsed = int.tryParse(trimmed);
    final nextEvery = parsed != null && parsed > 0 ? parsed : null;
    emit(
      state.copyWith(
        form: state.form.copyWith(
          recurrenceEvery: nextEvery,
          clearRecurrenceEvery: nextEvery == null,
        ),
        hasUserEdits: true,
      ),
    );
  }

  void _onRecurrenceUnitChanged(
    ShareCreateRecurrenceUnitChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(recurrenceUnit: event.unit),
        hasUserEdits: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    ShareCreateSubmitted event,
    Emitter<ShareCreateState> emit,
  ) async {
    if (state.isEditing && !state.canEdit) return;

    final plan = _buildSubmissionPlan(state);
    if (plan == null) {
      final validationError = _inferSubmissionValidationError(state);
      emit(
        state.copyWith(
          showValidationErrors: true,
          submissionErrorCode: validationError.code,
          submissionErrorMessage: validationError.message,
          submissionErrorTick: state.submissionErrorTick + 1,
        ),
      );
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
      final saved = await _submitPlan(plan);

      emit(
        state.copyWith(
          isSubmitting: false,
          showValidationErrors: false,
          successExpenseId: saved.id,
        ),
      );
    } on ExpenseException catch (error) {
      if (error.code == ExpenseErrorCode.paywallActiveExpensesCap ||
          error.code == ExpenseErrorCode.paywallExpensePhotosCap) {
        _emitPaywallRequest(emit, state, code: error.code);
        return;
      }

      _emitSubmissionError(
        emit: emit,
        code: error.code,
        message: error.message,
        tick: state.submissionErrorTick + 1,
      );
    } catch (error) {
      _emitSubmissionError(
        emit: emit,
        code: ExpenseErrorCode.unknown,
        message: error.toString(),
        tick: state.submissionErrorTick + 1,
      );
    }
  }

  Future<void> _onDeleted(
    ShareCreateDeleted event,
    Emitter<ShareCreateState> emit,
  ) async {
    if (!state.isEditing || state.editingExpenseId == null) {
      return;
    }

    emit(state.copyWith(isDeleting: true, clearDeletionError: true));

    try {
      await _expensesRepository.cancel(state.editingExpenseId!);
      emit(
        state.copyWith(
          isDeleting: false,
          deletionSuccessTick: state.deletionSuccessTick + 1,
        ),
      );
    } on ExpenseException catch (error) {
      emit(
        state.copyWith(
          isDeleting: false,
          deletionErrorMessage: error.message,
          deletionErrorTick: state.deletionErrorTick + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isDeleting: false,
          deletionErrorMessage: error.toString(),
          deletionErrorTick: state.deletionErrorTick + 1,
        ),
      );
    }
  }

  Future<void> _onPlanTerminationRequested(
    ShareCreatePlanTerminationRequested event,
    Emitter<ShareCreateState> emit,
  ) async {
    final planId = state.planId;
    if (planId == null) return;

    emit(
      state.copyWith(isTerminatingPlan: true, clearPlanTerminationError: true),
    );

    try {
      await _expensesRepository.terminatePlan(planId);
      emit(
        state.copyWith(
          isTerminatingPlan: false,
          planStatus: 'terminated',
          planTerminationSuccessTick: state.planTerminationSuccessTick + 1,
        ),
      );
    } on ExpenseException catch (error) {
      emit(
        state.copyWith(
          isTerminatingPlan: false,
          planTerminationErrorMessage: error.message,
          planTerminationErrorTick: state.planTerminationErrorTick + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isTerminatingPlan: false,
          planTerminationErrorMessage: error.toString(),
          planTerminationErrorTick: state.planTerminationErrorTick + 1,
        ),
      );
    }
  }

  void _onPaywallOpened(
    ShareCreatePaywallOpened event,
    Emitter<ShareCreateState> emit,
  ) {
    emit(state.copyWith(paywallInFlightRequestId: event.requestId));
  }

  void _onPaywallResolved(
    ShareCreatePaywallResolved event,
    Emitter<ShareCreateState> emit,
  ) {
    emit(state.copyWith(paywallInFlightRequestId: null));

    if (event.outcome.status == PaywallGateStatus.granted &&
        event.outcome.action == PaywallRetryAction.submit) {
      add(const ShareCreateSubmitted());
    }
  }
}
