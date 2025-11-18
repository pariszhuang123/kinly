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
          clearSuccess
              ? false
              : successWasDelete ?? this.successWasDelete,
      submissionErrorCode:
          clearSubmissionError
              ? null
              : submissionErrorCode ?? this.submissionErrorCode,
      submissionErrorMessage:
          clearSubmissionError
              ? null
              : submissionErrorMessage ?? this.submissionErrorMessage,
      submissionErrorTick: submissionErrorTick ?? this.submissionErrorTick,
    );
  }

  bool get hasChanges => !form.isEqualTo(referenceForm);
  bool get requiresAssignee => isEditMode;
  bool get isStartDateValid => form.isStartDateInRange(DateTime.now());

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
  ];
}
