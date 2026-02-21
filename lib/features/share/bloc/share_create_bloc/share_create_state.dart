part of 'share_create_bloc.dart';

class ShareCreateState extends Equatable {
  ShareCreateState({
    required this.form,
    required List<ShareParticipant> participants,
    required this.currentUserId,
    required this.isLoading,
    required this.isSubmitting,
    required this.isTerminatingPlan,
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
    required this.planStatus,
    required this.planId,
    required this.isAmountLocked,
    required this.allPaid,
    required this.paidByOther,
    required this.hasUserEdits,
    required this.canEdit,
    required this.editDisabledReason,
    required this.planTerminationErrorMessage,
    required this.planTerminationErrorTick,
    required this.planTerminationSuccessTick,
    required this.paywallRequestTick,
    required this.paywallAction,
    required this.paywallRequest,
    required this.paywallInFlightRequestId,
    required this.isUploadingEvidencePhoto,
    required this.evidencePhotoErrorMessage,
    required this.evidencePhotoErrorTick,
    required this.isCameraPermissionPermanentlyDenied,
  }) : participants = List.unmodifiable(participants);

  factory ShareCreateState.initial({
    ShareCreateForm? form,
    bool isEditing = false,
    String? editingExpenseId,
    String? planStatus,
    String? planId,
    bool isAmountLocked = false,
    bool allPaid = false,
    bool paidByOther = false,
    bool canEdit = true,
    String? editDisabledReason,
  }) {
    return ShareCreateState(
      form: form ?? ShareCreateForm.initial(),
      participants: const [],
      currentUserId: null,
      isLoading: true,
      isSubmitting: false,
      isTerminatingPlan: false,
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
      planStatus: planStatus,
      planId: planId,
      isAmountLocked: isAmountLocked,
      allPaid: allPaid,
      paidByOther: paidByOther,
      hasUserEdits: false, // starts as "pristine"
      canEdit: canEdit,
      editDisabledReason: editDisabledReason,
      planTerminationErrorMessage: null,
      planTerminationErrorTick: 0,
      planTerminationSuccessTick: 0,
      paywallRequestTick: 0,
      paywallAction: null,
      paywallRequest: null,
      paywallInFlightRequestId: null,
      isUploadingEvidencePhoto: false,
      evidencePhotoErrorMessage: null,
      evidencePhotoErrorTick: 0,
      isCameraPermissionPermanentlyDenied: false,
    );
  }

  final ShareCreateForm form;
  final List<ShareParticipant> participants;
  final String? currentUserId;
  final bool isLoading;
  final bool isSubmitting;
  final bool isTerminatingPlan;
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
  final String? planStatus;
  final String? planId;
  final bool isAmountLocked;
  final bool allPaid;
  final bool paidByOther;
  final bool canEdit;
  final String? editDisabledReason;
  final String? planTerminationErrorMessage;
  final int planTerminationErrorTick;
  final int planTerminationSuccessTick;
  final int paywallRequestTick;
  final PaywallRetryAction? paywallAction;
  final PaywallGateRequest? paywallRequest;
  final String? paywallInFlightRequestId;
  final bool isUploadingEvidencePhoto;
  final String? evidencePhotoErrorMessage;
  final int evidencePhotoErrorTick;
  final bool isCameraPermissionPermanentlyDenied;

  /// Tracks whether the user has made *any* edits in this session.
  /// Used by the primary button to decide between Delete vs Update.
  final bool hasUserEdits;

  ShareCreateState copyWith({
    ShareCreateForm? form,
    List<ShareParticipant>? participants,
    String? currentUserId,
    bool? isLoading,
    bool? isSubmitting,
    bool? isTerminatingPlan,
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
    String? planStatus,
    String? planId,
    bool? isAmountLocked,
    bool? allPaid,
    bool? paidByOther,
    bool? hasUserEdits,
    bool? canEdit,
    String? editDisabledReason,
    String? planTerminationErrorMessage,
    bool clearPlanTerminationError = false,
    int? planTerminationErrorTick,
    int? planTerminationSuccessTick,
    int? paywallRequestTick,
    PaywallRetryAction? paywallAction,
    PaywallGateRequest? paywallRequest,
    String? paywallInFlightRequestId,
    bool? isUploadingEvidencePhoto,
    String? evidencePhotoErrorMessage,
    bool clearEvidencePhotoError = false,
    int? evidencePhotoErrorTick,
    bool? isCameraPermissionPermanentlyDenied,
  }) {
    return ShareCreateState(
      form: form ?? this.form,
      participants: participants ?? this.participants,
      currentUserId: currentUserId ?? this.currentUserId,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isTerminatingPlan: isTerminatingPlan ?? this.isTerminatingPlan,
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
      planStatus: planStatus ?? this.planStatus,
      planId: planId ?? this.planId,
      isAmountLocked: isAmountLocked ?? this.isAmountLocked,
      allPaid: allPaid ?? this.allPaid,
      paidByOther: paidByOther ?? this.paidByOther,
      hasUserEdits: hasUserEdits ?? this.hasUserEdits,
      canEdit: canEdit ?? this.canEdit,
      editDisabledReason: editDisabledReason ?? this.editDisabledReason,
      planTerminationErrorMessage:
          clearPlanTerminationError
              ? null
              : planTerminationErrorMessage ?? this.planTerminationErrorMessage,
      planTerminationErrorTick:
          planTerminationErrorTick ?? this.planTerminationErrorTick,
      planTerminationSuccessTick:
          planTerminationSuccessTick ?? this.planTerminationSuccessTick,
      paywallRequestTick: paywallRequestTick ?? this.paywallRequestTick,
      paywallAction: paywallAction ?? this.paywallAction,
      paywallRequest: paywallRequest ?? this.paywallRequest,
      paywallInFlightRequestId:
          paywallInFlightRequestId ?? this.paywallInFlightRequestId,
      isUploadingEvidencePhoto:
          isUploadingEvidencePhoto ?? this.isUploadingEvidencePhoto,
      evidencePhotoErrorMessage:
          clearEvidencePhotoError
              ? null
              : evidencePhotoErrorMessage ?? this.evidencePhotoErrorMessage,
      evidencePhotoErrorTick:
          evidencePhotoErrorTick ?? this.evidencePhotoErrorTick,
      isCameraPermissionPermanentlyDenied:
          isCameraPermissionPermanentlyDenied ??
          this.isCameraPermissionPermanentlyDenied,
    );
  }

  Set<String> get equalSelectionIds {
    if (form.selectedParticipantIds.isEmpty) {
      return participants.map((participant) => participant.userId).toSet();
    }
    return form.selectedParticipantIds;
  }

  bool get hasEqualSelection => equalSelectionIds.isNotEmpty;

  bool get hasEqualSinglePayer =>
      currentUserId != null &&
      equalSelectionIds.length == 1 &&
      equalSelectionIds.first == currentUserId;

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

    final hasInsufficientParticipants = entries.isEmpty;
    final int sum = entries.fold<int>(
      0,
      (sum, entry) => sum + entry.amountCents,
    );
    final bool sumMatchesTotal = total != null && sum == total;
    final bool hasSinglePayer =
        currentUserId != null &&
        entries.length == 1 &&
        entries.first.userId == currentUserId;

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
    currentUserId,
    isLoading,
    isSubmitting,
    isTerminatingPlan,
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
    planStatus,
    planId,
    isAmountLocked,
    allPaid,
    paidByOther,
    hasUserEdits,
    canEdit,
    editDisabledReason,
    planTerminationErrorMessage,
    planTerminationErrorTick,
    planTerminationSuccessTick,
    paywallRequestTick,
    paywallAction,
    paywallRequest,
    paywallInFlightRequestId,
    isUploadingEvidencePhoto,
    evidencePhotoErrorMessage,
    evidencePhotoErrorTick,
    isCameraPermissionPermanentlyDenied,
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
