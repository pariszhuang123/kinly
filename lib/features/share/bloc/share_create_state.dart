part of 'share_create_bloc.dart';

class ShareCreateState extends Equatable {
  ShareCreateState({
    required this.form,
    required List<ShareParticipant> participants,
    required this.isLoading,
    required this.isSubmitting,
    required this.isDeleting,
    required this.showValidationErrors,
    required this.loadErrorMessage,
    required this.submissionErrorCode,
    required this.submissionErrorMessage,
    required this.submissionErrorTick,
    required this.deletionErrorMessage,
    required this.deletionErrorTick,
    required this.deletionSuccessTick,
    required this.successExpenseId,
    required this.isEditing,
    required this.editingExpenseId,
    required this.isAmountLocked,
    required this.hasUserEdits,
  }) : participants = List.unmodifiable(participants);

  factory ShareCreateState.initial({
    ShareCreateForm? form,
    bool isEditing = false,
    String? editingExpenseId,
    bool isAmountLocked = false,
  }) {
    return ShareCreateState(
      form: form ?? ShareCreateForm.initial(),
      participants: const [],
      isLoading: true,
      isSubmitting: false,
      isDeleting: false,
      showValidationErrors: false,
      loadErrorMessage: null,
      submissionErrorCode: null,
      submissionErrorMessage: null,
      submissionErrorTick: 0,
      deletionErrorMessage: null,
      deletionErrorTick: 0,
      deletionSuccessTick: 0,
      successExpenseId: null,
      isEditing: isEditing,
      editingExpenseId: editingExpenseId,
      isAmountLocked: isAmountLocked,
      hasUserEdits: false, // starts as "pristine"
    );
  }

  final ShareCreateForm form;
  final List<ShareParticipant> participants;
  final bool isLoading;
  final bool isSubmitting;
  final bool isDeleting;
  final bool showValidationErrors;
  final String? loadErrorMessage;
  final ExpenseErrorCode? submissionErrorCode;
  final String? submissionErrorMessage;
  final int submissionErrorTick;
  final String? deletionErrorMessage;
  final int deletionErrorTick;
  final int deletionSuccessTick;
  final String? successExpenseId;
  final bool isEditing;
  final String? editingExpenseId;
  final bool isAmountLocked;

  /// Tracks whether the user has made *any* edits in this session.
  /// Used by the primary button to decide between Delete vs Update.
  final bool hasUserEdits;

  ShareCreateState copyWith({
    ShareCreateForm? form,
    List<ShareParticipant>? participants,
    bool? isLoading,
    bool? isSubmitting,
    bool? isDeleting,
    bool? showValidationErrors,
    String? loadErrorMessage,
    bool clearLoadError = false,
    ExpenseErrorCode? submissionErrorCode,
    String? submissionErrorMessage,
    bool clearSubmissionError = false,
    int? submissionErrorTick,
    String? deletionErrorMessage,
    bool clearDeletionError = false,
    int? deletionErrorTick,
    int? deletionSuccessTick,
    String? successExpenseId,
    bool clearSuccess = false,
    bool? isEditing,
    String? editingExpenseId,
    bool? isAmountLocked,
    bool? hasUserEdits,
  }) {
    return ShareCreateState(
      form: form ?? this.form,
      participants: participants ?? this.participants,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDeleting: isDeleting ?? this.isDeleting,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
      loadErrorMessage:
          clearLoadError ? null : loadErrorMessage ?? this.loadErrorMessage,
      submissionErrorCode:
          clearSubmissionError
              ? null
              : submissionErrorCode ?? this.submissionErrorCode,
      submissionErrorMessage:
          clearSubmissionError
              ? null
              : submissionErrorMessage ?? this.submissionErrorMessage,
      submissionErrorTick: submissionErrorTick ?? this.submissionErrorTick,
      deletionErrorMessage:
          clearDeletionError
              ? null
              : deletionErrorMessage ?? this.deletionErrorMessage,
      deletionErrorTick: deletionErrorTick ?? this.deletionErrorTick,
      deletionSuccessTick: deletionSuccessTick ?? this.deletionSuccessTick,
      successExpenseId:
          clearSuccess ? null : successExpenseId ?? this.successExpenseId,
      isEditing: isEditing ?? this.isEditing,
      editingExpenseId: editingExpenseId ?? this.editingExpenseId,
      isAmountLocked: isAmountLocked ?? this.isAmountLocked,
      hasUserEdits: hasUserEdits ?? this.hasUserEdits,
    );
  }

  bool get hasEqualSelection => form.selectedParticipantIds.length >= 2;

  /// Builds a summary of the custom split state for validation + RPC input.
  ShareCustomSplitSummary evaluateCustomSplit() {
    final int? total = form.amountCents;
    final entries = <ShareCustomSplitEntry>[];
    var hasInvalidAmounts = false;

    for (final userId in form.selectedParticipantIds) {
      final cents = ShareCreateForm.parseCurrency(
        form.customAmountInputs[userId] ?? '',
      );
      if (cents == null || cents <= 0) {
        hasInvalidAmounts = true;
        continue;
      }
      entries.add(ShareCustomSplitEntry(userId: userId, amountCents: cents));
    }

    final hasInsufficientParticipants = entries.length < 2;
    final int sum = entries.fold<int>(
      0,
      (sum, entry) => sum + entry.amountCents,
    );
    final bool sumMatchesTotal = total != null && sum == total;
    final bool hasSinglePayer =
        total != null &&
        entries.length == 1 &&
        entries.first.amountCents == total;

    return ShareCustomSplitSummary(
      entries: entries,
      hasInvalidAmounts: hasInvalidAmounts,
      hasInsufficientParticipants: hasInsufficientParticipants,
      sumMatchesTotal: sumMatchesTotal,
      missingTotal: total == null,
      hasSinglePayer: hasSinglePayer,
    );
  }

  @override
  List<Object?> get props => [
    form,
    participants,
    isLoading,
    isSubmitting,
    isDeleting,
    showValidationErrors,
    loadErrorMessage,
    submissionErrorCode,
    submissionErrorMessage,
    submissionErrorTick,
    deletionErrorMessage,
    deletionErrorTick,
    deletionSuccessTick,
    successExpenseId,
    isEditing,
    editingExpenseId,
    isAmountLocked,
    hasUserEdits,
  ];
}

class ShareCustomSplitEntry extends Equatable {
  const ShareCustomSplitEntry({
    required this.userId,
    required this.amountCents,
  });

  final String userId;
  final int amountCents;

  @override
  List<Object?> get props => [userId, amountCents];
}

class ShareCustomSplitSummary {
  const ShareCustomSplitSummary({
    required this.entries,
    required this.hasInvalidAmounts,
    required this.hasInsufficientParticipants,
    required this.sumMatchesTotal,
    required this.missingTotal,
    required this.hasSinglePayer,
  });

  final List<ShareCustomSplitEntry> entries;
  final bool hasInvalidAmounts;
  final bool hasInsufficientParticipants;
  final bool sumMatchesTotal;
  final bool missingTotal;
  final bool hasSinglePayer;

  bool get isValid =>
      !missingTotal &&
      !hasInvalidAmounts &&
      !hasInsufficientParticipants &&
      sumMatchesTotal &&
      !hasSinglePayer;
}
