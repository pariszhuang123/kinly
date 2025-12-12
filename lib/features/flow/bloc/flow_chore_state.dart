part of 'flow_chore_bloc.dart';

class FlowChoreState extends Equatable {
  final FlowChoreForm form;
  final FlowChoreForm referenceForm;
  final List<ChoreAssigneeSummary> assignees;
  final bool isLoading;
  final bool isSubmitting;
  final bool isDeleting;
  final bool isEditMode;
  final bool showValidationErrors;
  final String? loadErrorMessage;
  final String? successChoreId;
  final bool successWasDelete;
  final ChoreErrorCode? submissionErrorCode;
  final String? submissionErrorMessage;
  final int submissionErrorTick;
  final bool isUploadingPhoto;
  final String? photoErrorMessage;
  final int photoErrorTick;
  final bool isCameraPermissionPermanentlyDenied;
  final String? currentUserId;
  final ChoreState? choreState;

  const FlowChoreState({
    required this.form,
    required this.referenceForm,
    required this.assignees,
    required this.isLoading,
    required this.isSubmitting,
    required this.isDeleting,
    required this.isEditMode,
    required this.showValidationErrors,
    required this.loadErrorMessage,
    required this.successChoreId,
    required this.successWasDelete,
    required this.submissionErrorCode,
    required this.submissionErrorMessage,
    required this.submissionErrorTick,
    required this.isUploadingPhoto,
    required this.photoErrorMessage,
    required this.photoErrorTick,
    required this.isCameraPermissionPermanentlyDenied,
    required this.currentUserId,
    required this.choreState,
  });

  factory FlowChoreState.initial({
    required bool isEditMode,
    required DateTime initialStartDate,
  }) {
    return FlowChoreState(
      form: FlowChoreForm.initial(startDate: initialStartDate),
      referenceForm: FlowChoreForm.initial(startDate: initialStartDate),
      assignees: const [],
      isLoading: true,
      isSubmitting: false,
      isDeleting: false,
      isEditMode: isEditMode,
      showValidationErrors: false,
      loadErrorMessage: null,
      successChoreId: null,
      successWasDelete: false,
      submissionErrorCode: null,
      submissionErrorMessage: null,
      submissionErrorTick: 0,
      isUploadingPhoto: false,
      photoErrorMessage: null,
      photoErrorTick: 0,
      isCameraPermissionPermanentlyDenied: false,
      currentUserId: null,
      choreState: isEditMode ? null : ChoreState.draft,
    );
  }

  FlowChoreState copyWith({
    FlowChoreForm? form,
    FlowChoreForm? referenceForm,
    List<ChoreAssigneeSummary>? assignees,
    bool? isLoading,
    bool? isSubmitting,
    bool? isDeleting,
    bool? isEditMode,
    bool? showValidationErrors,
    String? loadErrorMessage,
    bool clearLoadError = false,
    String? successChoreId,
    bool? successWasDelete,
    bool clearSuccess = false,
    ChoreErrorCode? submissionErrorCode,
    String? submissionErrorMessage,
    bool clearSubmissionError = false,
    int? submissionErrorTick,
    bool? isUploadingPhoto,
    String? photoErrorMessage,
    bool clearPhotoError = false,
    int? photoErrorTick,
    bool? isCameraPermissionPermanentlyDenied,
    String? currentUserId,
    ChoreState? choreState,
  }) {
    return FlowChoreState(
      form: form ?? this.form,
      referenceForm: referenceForm ?? this.referenceForm,
      assignees: assignees ?? this.assignees,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDeleting: isDeleting ?? this.isDeleting,
      isEditMode: isEditMode ?? this.isEditMode,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
      loadErrorMessage:
          clearLoadError ? null : loadErrorMessage ?? this.loadErrorMessage,
      successChoreId:
          clearSuccess ? null : successChoreId ?? this.successChoreId,
      successWasDelete:
          clearSuccess ? false : successWasDelete ?? this.successWasDelete,
      submissionErrorCode:
          clearSubmissionError
              ? null
              : submissionErrorCode ?? this.submissionErrorCode,
      submissionErrorMessage:
          clearSubmissionError
              ? null
              : submissionErrorMessage ?? this.submissionErrorMessage,
      submissionErrorTick: submissionErrorTick ?? this.submissionErrorTick,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      photoErrorMessage:
          clearPhotoError ? null : photoErrorMessage ?? this.photoErrorMessage,
      photoErrorTick: photoErrorTick ?? this.photoErrorTick,
      isCameraPermissionPermanentlyDenied:
          isCameraPermissionPermanentlyDenied ??
          this.isCameraPermissionPermanentlyDenied,
      currentUserId: currentUserId ?? this.currentUserId,
      choreState: choreState ?? this.choreState,
    );
  }

  bool get hasChanges => !form.isEqualTo(referenceForm);
  bool get requiresAssignee => isEditMode;
  bool get isStartDateValid => form.isStartDateInRange(DateTime.now());
  bool get isAssignedToCurrentUser =>
      form.assigneeUserId != null &&
      currentUserId != null &&
      form.assigneeUserId == currentUserId;
  bool get canEditOrDelete {
    if (!isEditMode) return true;
    if (choreState == ChoreState.active && !isAssignedToCurrentUser) {
      return false;
    }
    return true;
  }

  @override
  List<Object?> get props => [
    form,
    referenceForm,
    assignees,
    isLoading,
    isSubmitting,
    isDeleting,
    isEditMode,
    showValidationErrors,
    loadErrorMessage,
    successChoreId,
    submissionErrorCode,
    submissionErrorMessage,
    submissionErrorTick,
    successWasDelete,
    isUploadingPhoto,
    photoErrorMessage,
    photoErrorTick,
    isCameraPermissionPermanentlyDenied,
    currentUserId,
    choreState,
  ];
}
