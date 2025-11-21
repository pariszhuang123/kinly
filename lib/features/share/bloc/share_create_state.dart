part of 'share_create_bloc.dart';

class ShareCreateState extends Equatable {
  ShareCreateState({
    required this.form,
    required List<ShareParticipant> participants,
    required this.isLoading,
    required this.isSubmitting,
    required this.showValidationErrors,
    required this.loadErrorMessage,
    required this.submissionErrorCode,
    required this.submissionErrorMessage,
    required this.submissionErrorTick,
    required this.successExpenseId,
  }) : participants = List.unmodifiable(participants);

  factory ShareCreateState.initial() {
    return ShareCreateState(
      form: ShareCreateForm.initial(),
      participants: const [],
      isLoading: true,
      isSubmitting: false,
      showValidationErrors: false,
      loadErrorMessage: null,
      submissionErrorCode: null,
      submissionErrorMessage: null,
      submissionErrorTick: 0,
      successExpenseId: null,
    );
  }

  final ShareCreateForm form;
  final List<ShareParticipant> participants;
  final bool isLoading;
  final bool isSubmitting;
  final bool showValidationErrors;
  final String? loadErrorMessage;
  final ExpenseErrorCode? submissionErrorCode;
  final String? submissionErrorMessage;
  final int submissionErrorTick;
  final String? successExpenseId;

  ShareCreateState copyWith({
    ShareCreateForm? form,
    List<ShareParticipant>? participants,
    bool? isLoading,
    bool? isSubmitting,
    bool? showValidationErrors,
    String? loadErrorMessage,
    bool clearLoadError = false,
    ExpenseErrorCode? submissionErrorCode,
    String? submissionErrorMessage,
    bool clearSubmissionError = false,
    int? submissionErrorTick,
    String? successExpenseId,
    bool clearSuccess = false,
  }) {
    return ShareCreateState(
      form: form ?? this.form,
      participants: participants ?? this.participants,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
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
      successExpenseId:
          clearSuccess ? null : successExpenseId ?? this.successExpenseId,
    );
  }

  bool get hasEqualSelection => form.selectedParticipantIds.length >= 2;

  ShareCustomSplitSummary evaluateCustomSplit() {
    final total = form.amountCents;
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
    final sum = entries.fold<int>(0, (sum, entry) => sum + entry.amountCents);
    final sumMatchesTotal = total != null && sum == total;
    final hasSinglePayer =
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
    showValidationErrors,
    loadErrorMessage,
    submissionErrorCode,
    submissionErrorMessage,
    submissionErrorTick,
    successExpenseId,
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
