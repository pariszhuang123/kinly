import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/expenses/models.dart';
import '../../../../data/repositories/expenses_repository.dart';
import '../../../../data/repositories/home_repository.dart';
import '../../../../core/supabase/supabase_error_mapper.dart';
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
    bool amountLocked = false,
    bool allPaid = false,
    bool paidByOther = false,
    bool canEdit = true,
    String? editDisabledReason,
  }) : _homeId = homeId,
       _expensesRepository = expensesRepository,
       _homeRepository = homeRepository,
       super(
         ShareCreateState.initial(
            form: initialForm,
            isEditing: editingExpenseId != null,
            editingExpenseId: editingExpenseId,
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
    on<ShareCreateRecurrenceChanged>(_onRecurrenceChanged);
    on<ShareCreateSubmitted>(_onSubmitted);
    on<ShareCreateDeleted>(_onDeleted);
  }

  final String _homeId;
  final ExpensesRepository _expensesRepository;
  final HomeRepository _homeRepository;

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
      splitMode: event.mode, // ShareSplitMode? now
      recurrence:
          event.mode == null
              ? ExpenseRecurrenceInterval.none
              : state.form.recurrence,
    );

    final isSwitchingToEqual = event.mode == ShareSplitMode.equal;
    final hasNoSelection = nextForm.selectedParticipantIds.isEmpty;
    if (isSwitchingToEqual && hasNoSelection && state.participants.isNotEmpty) {
      nextForm = nextForm.copyWith(
        selectedParticipantIds:
            LinkedHashSet<String>.from(
              state.participants.map((p) => p.userId),
            ),
      );
    }

    emit(
      state.copyWith(
        form: nextForm,
        hasUserEdits: true,
      ),
    );
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
    final updated = state.form.updateCustomAmount(event.userId, event.amount);
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

  void _onRecurrenceChanged(
    ShareCreateRecurrenceChanged event,
    Emitter<ShareCreateState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(recurrence: event.recurrence),
        hasUserEdits: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    ShareCreateSubmitted event,
    Emitter<ShareCreateState> emit,
  ) async {
    if (state.isEditing && !state.canEdit) {
      return;
    }

    final form = state.form;
    final amountCents = form.amountCents;
    final descriptionValid = form.hasValidDescription;
    final amountValid = amountCents != null && amountCents > 0;
    final splitMode = form.splitMode;
    final recurrence = form.recurrence;
    final startDate = form.startDate;
    final isEditing = state.isEditing;
    final editingExpenseId = state.editingExpenseId;
    final amountLocked = state.isAmountLocked;
    final requiresAmount =
        isEditing ? !amountLocked : splitMode != null;

    var isValid =
        descriptionValid &&
        (!requiresAmount || amountValid) &&
        (splitMode != null || recurrence == ExpenseRecurrenceInterval.none);

    List<String>? memberIds;
    List<ExpenseCustomSplitInput>? customSplits;
    ExpenseSplitType? splitType;

    // For edit mode, we require splitMode + editing id unless amountLocked
    if (isEditing &&
        !amountLocked &&
        (splitMode == null || editingExpenseId == null)) {
      isValid = false;
    }

    final selectedEqualIds = state.equalSelectionIds;

    if (!amountLocked && isValid && splitMode == ShareSplitMode.equal) {
      if (selectedEqualIds.length < 2) {
        isValid = false;
      } else {
        memberIds = selectedEqualIds.toList(growable: false);
        splitType = ExpenseSplitType.equal;
      }
    } else if (!amountLocked && isValid && splitMode == ShareSplitMode.custom) {
      final summary = state.evaluateCustomSplit();
      if (!summary.isValid) {
        isValid = false;
      } else {
        customSplits = summary.entries
            .map(
              (entry) => ExpenseCustomSplitInput(
                userId: entry.userId,
                amountCents: entry.amountCents,
              ),
            )
            .toList(growable: false);
        splitType = ExpenseSplitType.custom;
      }
    } else if (amountLocked) {
      // When amount/splits are locked, we don't send new split info
      memberIds = null;
      customSplits = null;
      splitType = null;
    }

    if (!isValid) {
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
      final normalizedNotes = _normalize(form.notes);
      final saved =
          isEditing
              ? await _expensesRepository.edit(
                expenseId: editingExpenseId!,
                amountCents: amountCents!,
                description: form.description.trim(),
                notes: normalizedNotes,
                splitType: splitType,
                memberIds: memberIds,
                customSplits: customSplits,
                recurrence: recurrence,
                startDate: startDate,
              )
              : await _expensesRepository.create(
                homeId: _homeId,
                amountCents: amountCents,
                description: form.description.trim(),
                notes: normalizedNotes,
                splitType: splitType,
                memberIds: memberIds,
                customSplits: customSplits,
                recurrence: recurrence,
                startDate: startDate,
              );

      emit(
        state.copyWith(
          isSubmitting: false,
          showValidationErrors: false,
          successExpenseId: saved.id,
        ),
      );
    } on ExpenseException catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submissionErrorCode: error.code,
          submissionErrorMessage: error.message,
          submissionErrorTick: state.submissionErrorTick + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submissionErrorCode: ExpenseErrorCode.unknown,
          submissionErrorMessage: error.toString(),
          submissionErrorTick: state.submissionErrorTick + 1,
        ),
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

  String? _normalize(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
