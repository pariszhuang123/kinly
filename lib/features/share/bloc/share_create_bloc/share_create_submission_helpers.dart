part of 'share_create_bloc.dart';

extension _ShareCreateBlocSubmissionHelpers on ShareCreateBloc {
  _SplitDecision _noSplitDecision() {
    return const _SplitDecision(
      splitType: null,
      memberIds: null,
      customSplits: null,
      unitIds: null,
      unitSplits: null,
    );
  }

  _SplitDecision? _buildUnitSplitDecision(
    ShareCreateState currentState,
    ShareSplitMode? splitMode,
  ) {
    if (splitMode == ShareSplitMode.equal) {
      return _buildEqualUnitSplitDecision(currentState);
    }
    if (splitMode == ShareSplitMode.custom) {
      return _buildCustomUnitSplitDecision(currentState);
    }
    return _noSplitDecision();
  }

  _SplitDecision? _buildEqualUnitSplitDecision(ShareCreateState currentState) {
    final selection = currentState.equalUnitSelectionIds;
    if (selection.isEmpty) return null;
    return _SplitDecision(
      splitType: ExpenseSplitType.equal,
      memberIds: null,
      customSplits: null,
      unitIds: selection.toList(growable: false),
      unitSplits: null,
    );
  }

  _SplitDecision? _buildCustomUnitSplitDecision(ShareCreateState currentState) {
    final summary = currentState.evaluateUnitCustomSplit();
    if (!summary.isValid) return null;
    return _SplitDecision(
      splitType: ExpenseSplitType.custom,
      memberIds: null,
      customSplits: null,
      unitIds: null,
      unitSplits: summary.entries
          .map(
            (entry) => ExpenseUnitSplitInput(
              unitId: entry.userId,
              amountCents: entry.amountCents,
            ),
          )
          .toList(growable: false),
    );
  }

  _SplitDecision? _buildMemberSplitDecision(
    ShareCreateState currentState,
    ShareSplitMode? splitMode,
  ) {
    if (splitMode == ShareSplitMode.equal) {
      return _buildEqualMemberSplitDecision(currentState);
    }
    if (splitMode == ShareSplitMode.custom) {
      return _buildCustomMemberSplitDecision(currentState);
    }
    return _noSplitDecision();
  }

  _SplitDecision? _buildEqualMemberSplitDecision(
    ShareCreateState currentState,
  ) {
    final selection = currentState.equalSelectionIds;
    if (selection.isEmpty || _isSinglePayerSelection(currentState, selection)) {
      return null;
    }
    final memberIds = _resolveMembershipIds(currentState, selection);
    if (memberIds.length != selection.length) return null;
    return _SplitDecision(
      splitType: ExpenseSplitType.equal,
      memberIds: memberIds,
      customSplits: null,
      unitIds: null,
      unitSplits: null,
    );
  }

  bool _isSinglePayerSelection(
    ShareCreateState currentState,
    Set<String> selection,
  ) {
    final currentUserId = currentState.currentUserId;
    return currentUserId != null &&
        selection.length == 1 &&
        selection.contains(currentUserId);
  }

  _SplitDecision? _buildCustomMemberSplitDecision(
    ShareCreateState currentState,
  ) {
    final summary = currentState.evaluateCustomSplit();
    if (!summary.isValid) return null;
    final splits = <ExpenseCustomSplitInput>[];
    for (final entry in summary.entries) {
      final memberId = _resolveMembershipId(currentState, entry.userId);
      if (memberId == null) return null;
      splits.add(
        ExpenseCustomSplitInput(
          memberId: memberId,
          amountCents: entry.amountCents,
        ),
      );
    }
    return _SplitDecision(
      splitType: ExpenseSplitType.custom,
      memberIds: null,
      customSplits: splits,
      unitIds: null,
      unitSplits: null,
    );
  }

  _SubmissionValidationError? _inferTopLevelValidationError(
    ShareCreateState currentState,
    ShareCreateForm form,
  ) {
    if (!form.hasValidDescription) {
      return const _SubmissionValidationError(
        ExpenseErrorCode.invalidDescription,
      );
    }
    if (_requiresAmount(form, currentState) &&
        !_hasPositiveAmount(form.amountCents)) {
      return const _SubmissionValidationError(ExpenseErrorCode.invalidAmount);
    }
    if (_hasInvalidRecurrence(form)) {
      return const _SubmissionValidationError(ExpenseErrorCode.invalidRecurrence);
    }
    if (currentState.isAmountLocked) {
      return const _SubmissionValidationError(ExpenseErrorCode.editNotAllowed);
    }
    return null;
  }

  bool _requiresAmount(ShareCreateForm form, ShareCreateState currentState) {
    return currentState.isEditing
        ? !currentState.isAmountLocked
        : form.splitMode != null;
  }

  bool _hasPositiveAmount(int? amountCents) {
    return amountCents != null && amountCents > 0;
  }

  bool _hasInvalidRecurrence(ShareCreateForm form) {
    if (!form.isRecurring) return false;
    return form.splitMode == null ||
        form.recurrenceEvery == null ||
        form.recurrenceEvery! < 1 ||
        form.recurrenceUnit == null;
  }

  _SubmissionValidationError? _inferUnitSplitValidationError(
    ShareCreateState currentState,
    ShareSplitMode? splitMode,
  ) {
    if (splitMode == ShareSplitMode.equal &&
        currentState.equalUnitSelectionIds.isEmpty) {
      return const _SubmissionValidationError(
        ExpenseErrorCode.splitUnitsRequired,
      );
    }
    if (splitMode != ShareSplitMode.custom) return null;

    final summary = currentState.evaluateUnitCustomSplit();
    if (summary.hasInsufficientParticipants) {
      return const _SubmissionValidationError(
        ExpenseErrorCode.splitUnitsRequired,
      );
    }
    if (!summary.sumMatchesTotal) {
      return const _SubmissionValidationError(ExpenseErrorCode.invalidSplitsSum);
    }
    if (summary.hasInvalidAmounts) {
      return const _SubmissionValidationError(ExpenseErrorCode.invalidSplits);
    }
    return null;
  }

  _SubmissionValidationError? _inferMemberSplitValidationError(
    ShareCreateState currentState,
    ShareSplitMode? splitMode,
  ) {
    if (splitMode == ShareSplitMode.equal) {
      return _inferEqualMemberSplitError(currentState);
    }
    if (splitMode == ShareSplitMode.custom) {
      return _inferCustomMemberSplitError(currentState);
    }
    return null;
  }

  _SubmissionValidationError? _inferEqualMemberSplitError(
    ShareCreateState currentState,
  ) {
    final selection = currentState.equalSelectionIds;
    if (selection.isEmpty) {
      return const _SubmissionValidationError(
        ExpenseErrorCode.splitMembersRequired,
      );
    }
    if (_resolveMembershipIds(currentState, selection).length !=
        selection.length) {
      return _SubmissionValidationError(
        ExpenseErrorCode.invalidSplit,
        _shareCreateUnresolvedMemberMessage,
      );
    }
    return null;
  }

  _SubmissionValidationError? _inferCustomMemberSplitError(
    ShareCreateState currentState,
  ) {
    final summary = currentState.evaluateCustomSplit();
    final summaryError = _inferCustomSplitSummaryError(summary);
    if (summaryError != null) return summaryError;

    for (final entry in summary.entries) {
      if (_resolveMembershipId(currentState, entry.userId) == null) {
        return _SubmissionValidationError(
          ExpenseErrorCode.invalidSplit,
          _shareCreateUnresolvedMemberMessage,
        );
      }
    }
    return null;
  }

  _SubmissionValidationError? _inferCustomSplitSummaryError(
    ShareCustomSplitSummary summary,
  ) {
    if (summary.hasInsufficientParticipants) {
      return const _SubmissionValidationError(
        ExpenseErrorCode.splitMembersRequired,
      );
    }
    if (!summary.sumMatchesTotal) {
      return const _SubmissionValidationError(ExpenseErrorCode.invalidSplitsSum);
    }
    if (summary.hasInvalidAmounts) {
      return const _SubmissionValidationError(ExpenseErrorCode.invalidSplits);
    }
    return null;
  }
}
