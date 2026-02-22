part of 'share_create_bloc.dart';

extension _ShareCreateBlocSubmission on ShareCreateBloc {
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
      evidencePhotoPath: _resolveEvidencePhotoPathForRpc(currentState),
    );
  }

  Future<Expense> _submitPlan(_SubmissionPlan plan) {
    if (plan.isEditing) {
      return _submitEdit(plan);
    }

    return _submitCreate(plan);
  }

  Future<Expense> _submitEdit(_SubmissionPlan plan) {
    if (plan.evidencePhotoPath == null) {
      return _expensesRepository.edit(
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
      );
    }

    return _expensesRepository.edit(
      expenseId: plan.editingExpenseId!,
      amountCents: plan.amountCents!,
      description: plan.description,
      notes: plan.notes,
      evidencePhotoPath: plan.evidencePhotoPath,
      splitType: plan.splitType,
      memberIds: plan.memberIds,
      customSplits: plan.customSplits,
      recurrenceEvery: plan.recurrenceEvery,
      recurrenceUnit: plan.recurrenceUnit,
      startDate: plan.startDate,
    );
  }

  Future<Expense> _submitCreate(_SubmissionPlan plan) {
    if (plan.evidencePhotoPath == null) {
      return _expensesRepository.create(
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
    }

    return _expensesRepository.create(
      homeId: _homeId,
      amountCents: plan.amountCents,
      description: plan.description,
      notes: plan.notes,
      evidencePhotoPath: plan.evidencePhotoPath,
      splitType: plan.splitType,
      memberIds: plan.memberIds,
      customSplits: plan.customSplits,
      recurrenceEvery: plan.recurrenceEvery,
      recurrenceUnit: plan.recurrenceUnit,
      startDate: plan.startDate,
    );
  }

  String? _resolveEvidencePhotoPathForRpc(ShareCreateState currentState) {
    final currentPath = currentState.form.evidencePhotoPath.trim();

    if (!currentState.isEditing) {
      return currentPath.isEmpty ? null : currentPath;
    }

    if (currentPath.isEmpty) {
      // Share follows flow/shopping storage semantics: clients cannot clear
      // previously uploaded media by sending an empty path.
      return null;
    }

    if (currentPath == _initialEvidencePhotoPath) {
      return null;
    }
    return currentPath;
  }

  String _withHouseholdsPrefix(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.startsWith('households/') ? trimmed : 'households/$trimmed';
  }

  void _emitPaywallRequest(
    Emitter<ShareCreateState> emit,
    ShareCreateState currentState, {
    required ExpenseErrorCode code,
  }) {
    final tick = currentState.paywallRequestTick + 1;
    final triggers = <PaywallTrigger>{
      if (code == ExpenseErrorCode.paywallExpensePhotosCap)
        PaywallTrigger.expensePhotosCap
      else
        PaywallTrigger.expenseActiveCap,
    };
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
          source:
              code == ExpenseErrorCode.paywallExpensePhotosCap
                  ? PaywallSources.expensePhotoCap
                  : PaywallSources.shareCreateExpense,
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
    final amountLocked = isEditing && currentState.isAmountLocked;
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
      if (selection.isEmpty) return null;
      if (currentState.currentUserId != null &&
          selection.length == 1 &&
          selection.contains(currentState.currentUserId)) {
        return null;
      }
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
    required this.evidencePhotoPath,
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
  final String? evidencePhotoPath;
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
