import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../../contracts/expenses/models.dart';
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

class ShareCreateBloc extends Bloc<ShareCreateEvent, ShareCreateState> {
  ShareCreateBloc({
    required String homeId,
    required ExpensesRepository expensesRepository,
    required HomeRepository homeRepository,
    ShareCreateForm? initialForm,
    String? editingExpenseId,
    String? planStatus,
    String? planId,
    bool amountLocked = false,
    bool allPaid = false,
    bool paidByOther = false,
    bool canEdit = true,
    String? editDisabledReason,
  }) : _homeId = homeId,
       _expensesRepository = expensesRepository,
       _homeRepository = homeRepository,
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
    on<ShareCreateDescriptionChanged>(_onDescriptionChanged);
    on<ShareCreateAmountChanged>(_onAmountChanged);
    on<ShareCreateSplitModeChanged>(_onSplitModeChanged);
    on<ShareCreateNotesChanged>(_onNotesChanged);
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
  final Uuid _uuid;

  Future<void> _onParticipantsRequested(
    ShareCreateParticipantsRequested event,
    Emitter<ShareCreateState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearLoadError: true));
    try {
      final members = await _homeRepository.listActiveMembers(
        _homeId,
        excludeSelf: false,
      );
      final participants = members
          .map(
            (member) => ShareParticipant(
              userId: member.userId,
              displayName: member.username,
              avatarUrl: member.avatarUrl,
              isOwner: member.isOwner,
            ),
          )
          .toList(growable: false);

      final availableIds = participants.map((p) => p.userId).toList();
      Set<String> nextSelection =
          state.form.selectedParticipantIds
              .where((id) => availableIds.contains(id))
              .toSet();

      // For equal split (or unset), default to all to reflect shared expenses.
      if (nextSelection.isEmpty &&
          availableIds.isNotEmpty &&
          state.form.splitMode != ShareSplitMode.custom) {
        nextSelection = LinkedHashSet<String>.from(availableIds);
      }

      final filteredAmounts = Map.fromEntries(
        state.form.customAmountInputs.entries.where(
          (entry) => availableIds.contains(entry.key),
        ),
      );

      emit(
        state.copyWith(
          isLoading: false,
          participants: participants,
          form: state.form.copyWith(
            selectedParticipantIds: nextSelection,
            customAmountInputs: filteredAmounts,
          ),
          clearLoadError: true,
          // NOTE: this is hydration, not a user edit, so we DO NOT touch hasUserEdits here
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isLoading: false, loadErrorMessage: error.toString()),
      );
    }
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
    var nextForm = state.form.copyWith(
      splitMode: event.mode,
      clearRecurrenceEvery: event.mode == null,
      clearRecurrenceUnit: event.mode == null,
    );

    final isSwitchingToEqual = event.mode == ShareSplitMode.equal;
    final isSwitchingToCustom = event.mode == ShareSplitMode.custom;
    final hasNoSelection = nextForm.selectedParticipantIds.isEmpty;
    if (isSwitchingToEqual && hasNoSelection && state.participants.isNotEmpty) {
      nextForm = nextForm.copyWith(
        selectedParticipantIds: LinkedHashSet<String>.from(
          state.participants.map((p) => p.userId),
        ),
      );
    } else if (isSwitchingToCustom) {
      final idsWithAmount = nextForm.customAmountInputs.entries
          .where((e) {
            final cents = ShareCreateForm.parseCurrency(e.value);
            return cents != null && cents > 0;
          })
          .map((e) => e.key)
          .toSet();
      nextForm = nextForm.copyWith(
        selectedParticipantIds: LinkedHashSet<String>.from(idsWithAmount),
      );
    }

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
      final saved =
          plan.isEditing
              ? await _expensesRepository.edit(
                expenseId: plan.editingExpenseId!,
                amountCents: plan.amountCents!,
                description: plan.description,
                notes: plan.notes,
                splitType: plan.splitType,
                memberIds: plan.memberIds,
                customSplits: plan.customSplits,
                recurrenceEvery: plan.recurrenceEvery,
                recurrenceUnit: plan.recurrenceUnit,
                startDate: plan.startDate,
              )
              : await _expensesRepository.create(
                homeId: _homeId,
                amountCents: plan.amountCents,
                description: plan.description,
                notes: plan.notes,
                splitType: plan.splitType,
                memberIds: plan.memberIds,
                customSplits: plan.customSplits,
                recurrenceEvery: plan.recurrenceEvery,
                recurrenceUnit: plan.recurrenceUnit,
                startDate: plan.startDate,
              );

      emit(
        state.copyWith(
          isSubmitting: false,
          showValidationErrors: false,
          successExpenseId: saved.id,
        ),
      );
    } on ExpenseException catch (error) {
      if (error.code == ExpenseErrorCode.paywallActiveExpensesCap) {
        _emitPaywallRequest(emit, state);
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

  String? _normalize(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  _SubmissionPlan? _buildSubmissionPlan(ShareCreateState currentState) {
    final ctx = _buildValidationContext(currentState);
    if (!_hasBasicValidity(ctx)) return null;

    final splitDecision = _buildSplitDecision(currentState, ctx);
    if (splitDecision == null) return null;

    return _SubmissionPlan(
      isEditing: ctx.isEditing,
      editingExpenseId: ctx.editingExpenseId,
      amountCents: ctx.amountCents,
      description: ctx.description,
      notes: ctx.notes,
      splitType: splitDecision.splitType,
      memberIds: splitDecision.memberIds,
      customSplits: splitDecision.customSplits,
      recurrenceEvery: ctx.recurrenceEvery,
      recurrenceUnit: ctx.recurrenceUnit,
      startDate: ctx.startDate,
    );
  }

  void _emitPaywallRequest(
    Emitter<ShareCreateState> emit,
    ShareCreateState currentState,
  ) {
    final tick = currentState.paywallRequestTick + 1;
    const triggers = {PaywallTrigger.expenseActiveCap};
    emit(
      currentState.copyWith(
        isSubmitting: false,
        clearSuccess: true,
        clearSubmissionError: true,
        paywallAction: PaywallRetryAction.submit,
        paywallRequestTick: tick,
        paywallRequest: PaywallGateRequest(
          requestId: _uuid.v4(),
          homeId: _homeId,
          source: PaywallSources.shareCreateExpense,
          action: PaywallRetryAction.submit,
          tick: tick,
          triggers: triggers,
        ),
        paywallInFlightRequestId: null,
      ),
    );
  }

  void _emitSubmissionError({
    required Emitter<ShareCreateState> emit,
    required ExpenseErrorCode code,
    required String message,
    required int tick,
  }) {
    emit(
      state.copyWith(
        isSubmitting: false,
        submissionErrorCode: code,
        submissionErrorMessage: message,
        submissionErrorTick: tick,
      ),
    );
  }

  _ValidationContext _buildValidationContext(ShareCreateState currentState) {
    final form = currentState.form;
    final amountCents = form.amountCents;
    final amountValid = amountCents != null && amountCents > 0;
    final isEditing = currentState.isEditing;
    final amountLocked = currentState.isAmountLocked;
    final splitMode = form.splitMode;
    final requiresAmount = isEditing ? !amountLocked : splitMode != null;

    return _ValidationContext(
      isEditing: isEditing,
      editingExpenseId: currentState.editingExpenseId,
      amountCents: amountCents,
      description: form.description.trim(),
      notes: _normalize(form.notes),
      descriptionValid: form.hasValidDescription,
      amountValid: amountValid,
      requiresAmount: requiresAmount,
      splitMode: splitMode,
      recurrenceEvery: form.recurrenceEvery,
      recurrenceUnit: form.recurrenceUnit,
      startDate: form.startDate,
      amountLocked: amountLocked,
    );
  }

  bool _hasBasicValidity(_ValidationContext ctx) {
    final recurrencePairOk =
        (ctx.recurrenceEvery == null && ctx.recurrenceUnit == null) ||
        (ctx.recurrenceEvery != null && ctx.recurrenceUnit != null);
    final recurrenceEveryOk =
        ctx.recurrenceEvery == null || ctx.recurrenceEvery! >= 1;
    final recurrenceOk =
        (ctx.splitMode != null || ctx.recurrenceEvery == null) &&
        recurrencePairOk &&
        recurrenceEveryOk;
    final hasEditInputs =
        ctx.isEditing
            ? ctx.amountLocked ||
                (ctx.splitMode != null && ctx.editingExpenseId != null)
            : true;

    return ctx.descriptionValid &&
        (!ctx.requiresAmount || ctx.amountValid) &&
        recurrenceOk &&
        hasEditInputs;
  }

  _SplitDecision? _buildSplitDecision(
    ShareCreateState currentState,
    _ValidationContext ctx,
  ) {
    if (ctx.amountLocked) {
      return const _SplitDecision(
        splitType: null,
        memberIds: null,
        customSplits: null,
      );
    }

    if (ctx.splitMode == ShareSplitMode.equal) {
      final selection = currentState.equalSelectionIds;
      if (selection.length < 2) return null;
      return _SplitDecision(
        splitType: ExpenseSplitType.equal,
        memberIds: selection.toList(growable: false),
        customSplits: null,
      );
    }

    if (ctx.splitMode == ShareSplitMode.custom) {
      final summary = currentState.evaluateCustomSplit();
      if (!summary.isValid) return null;
      final splits = summary.entries
          .map(
            (entry) => ExpenseCustomSplitInput(
              userId: entry.userId,
              amountCents: entry.amountCents,
            ),
          )
          .toList(growable: false);
      return _SplitDecision(
        splitType: ExpenseSplitType.custom,
        memberIds: null,
        customSplits: splits,
      );
    }

    return _SplitDecision(splitType: null, memberIds: null, customSplits: null);
  }
}

class _SubmissionPlan {
  const _SubmissionPlan({
    required this.isEditing,
    required this.editingExpenseId,
    required this.amountCents,
    required this.description,
    required this.notes,
    required this.splitType,
    required this.memberIds,
    required this.customSplits,
    required this.recurrenceEvery,
    required this.recurrenceUnit,
    required this.startDate,
  });

  final bool isEditing;
  final String? editingExpenseId;
  final int? amountCents;
  final String description;
  final String? notes;
  final ExpenseSplitType? splitType;
  final List<String>? memberIds;
  final List<ExpenseCustomSplitInput>? customSplits;
  final int? recurrenceEvery;
  final ExpenseRecurrenceUnit? recurrenceUnit;
  final DateTime startDate;
}

class _ValidationContext {
  _ValidationContext({
    required this.isEditing,
    required this.editingExpenseId,
    required this.amountCents,
    required this.description,
    required this.notes,
    required this.descriptionValid,
    required this.amountValid,
    required this.requiresAmount,
    required this.splitMode,
    required this.recurrenceEvery,
    required this.recurrenceUnit,
    required this.startDate,
    required this.amountLocked,
  });

  final bool isEditing;
  final String? editingExpenseId;
  final int? amountCents;
  final String description;
  final String? notes;
  final bool descriptionValid;
  final bool amountValid;
  final bool requiresAmount;
  final ShareSplitMode? splitMode;
  final int? recurrenceEvery;
  final ExpenseRecurrenceUnit? recurrenceUnit;
  final DateTime startDate;
  final bool amountLocked;
}

class _SplitDecision {
  const _SplitDecision({
    required this.splitType,
    required this.memberIds,
    required this.customSplits,
  });

  final ExpenseSplitType? splitType;
  final List<String>? memberIds;
  final List<ExpenseCustomSplitInput>? customSplits;
}
