part of 'flow_chore_bloc.dart';

class FlowChoreState extends Equatable {
  final FlowChoreForm form;
  final List<ChoreAssigneeSummary> assignees;
  final bool isLoading;
  final bool isSubmitting;
  final bool isEditMode;
  final bool showValidationErrors;
  final String? loadErrorMessage;
  final String? successChoreId;
  final ChoreErrorCode? submissionErrorCode;
  final String? submissionErrorMessage;
  final int submissionErrorTick;

  const FlowChoreState({
    required this.form,
    required this.assignees,
    required this.isLoading,
    required this.isSubmitting,
    required this.isEditMode,
    required this.showValidationErrors,
    required this.loadErrorMessage,
    required this.successChoreId,
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
      assignees: const [],
      isLoading: true,
      isSubmitting: false,
      isEditMode: isEditMode,
      showValidationErrors: false,
      loadErrorMessage: null,
      successChoreId: null,
      submissionErrorCode: null,
      submissionErrorMessage: null,
      submissionErrorTick: 0,
    );
  }

  FlowChoreState copyWith({
    FlowChoreForm? form,
    List<ChoreAssigneeSummary>? assignees,
    bool? isLoading,
    bool? isSubmitting,
    bool? isEditMode,
    bool? showValidationErrors,
    String? loadErrorMessage,
    bool clearLoadError = false,
    String? successChoreId,
    bool clearSuccess = false,
    ChoreErrorCode? submissionErrorCode,
    String? submissionErrorMessage,
    bool clearSubmissionError = false,
    int? submissionErrorTick,
  }) {
    return FlowChoreState(
      form: form ?? this.form,
      assignees: assignees ?? this.assignees,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isEditMode: isEditMode ?? this.isEditMode,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
      loadErrorMessage:
          clearLoadError ? null : loadErrorMessage ?? this.loadErrorMessage,
      successChoreId:
          clearSuccess ? null : successChoreId ?? this.successChoreId,
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

  @override
  List<Object?> get props => [
    form,
    assignees,
    isLoading,
    isSubmitting,
    isEditMode,
    showValidationErrors,
    loadErrorMessage,
    successChoreId,
    submissionErrorCode,
    submissionErrorMessage,
    submissionErrorTick,
  ];
}
