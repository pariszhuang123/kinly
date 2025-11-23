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
  }) : _homeId = homeId,
       _expensesRepository = expensesRepository,
       _homeRepository = homeRepository,
       super(
         ShareCreateState.initial(
           form: initialForm,
           isEditing: editingExpenseId != null,
           editingExpenseId: editingExpenseId,
           isAmountLocked: amountLocked,
         ),
       ) {
    on<ShareCreateParticipantsRequested>(_onParticipantsRequested);
    on<ShareCreateDescriptionChanged>(_onDescriptionChanged);
    on<ShareCreateAmountChanged>(_onAmountChanged);
    on<ShareCreateSplitModeChanged>(_onSplitModeChanged);
    on<ShareCreateNotesChanged>(_onNotesChanged);
    on<ShareCreateParticipantToggled>(_onParticipantToggled);
    on<ShareCreateCustomAmountChanged>(_onCustomAmountChanged);
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

      // Default to all if nothing selected but participants exist
      if (nextSelection.isEmpty && availableIds.isNotEmpty) {
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
    emit(
      state.copyWith(
        form: state.form.copyWith(splitMode: event.mode),
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

  Future<void> _onSubmitted(
    ShareCreateSubmitted event,
    Emitter<ShareCreateState> emit,
  ) async {
    final form = state.form;
    final amountCents = form.amountCents;
    final descriptionValid = form.hasValidDescription;
    final amountValid = amountCents != null && amountCents > 0;
    var isValid = descriptionValid && amountValid;
    final splitMode = form.splitMode;
    final isEditing = state.isEditing;
    final editingExpenseId = state.editingExpenseId;
    final amountLocked = state.isAmountLocked;

    List<String>? memberIds;
    List<ExpenseCustomSplitInput>? customSplits;
    ExpenseSplitType? splitType;

    // For edit mode, we require splitMode + editing id unless amountLocked
    if (isEditing &&
        !amountLocked &&
        (splitMode == null || editingExpenseId == null)) {
      isValid = false;
    }

    if (!amountLocked && isValid && splitMode == ShareSplitMode.equal) {
      if (form.selectedParticipantIds.length < 2) {
        isValid = false;
      } else {
        memberIds = form.selectedParticipantIds.toList(growable: false);
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
              )
              : await _expensesRepository.create(
                homeId: _homeId,
                amountCents: amountCents!,
                description: form.description.trim(),
                notes: normalizedNotes,
                splitType: splitType,
                memberIds: memberIds,
                customSplits: customSplits,
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
