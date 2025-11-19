part of 'flow_chore_detail_bloc.dart';

class FlowChoreDetailState extends Equatable {
  final bool isLoading;
  final bool isCompleting;
  final ChoreDetails? details;
  final String? loadErrorMessage;
  final String? completionErrorMessage;
  final ChoreCompletionResult? completionResult;
  final int completionErrorTick;

  const FlowChoreDetailState({
    required this.isLoading,
    required this.isCompleting,
    this.details,
    this.loadErrorMessage,
    this.completionErrorMessage,
    this.completionResult,
    this.completionErrorTick = 0,
  });

  const FlowChoreDetailState.initial()
    : this(isLoading: true, isCompleting: false, completionErrorTick: 0);

  FlowChoreDetailState copyWith({
    bool? isLoading,
    bool? isCompleting,
    ChoreDetails? details,
    bool clearDetails = false,
    String? loadErrorMessage,
    bool clearLoadError = false,
    String? completionErrorMessage,
    bool clearCompletionError = false,
    ChoreCompletionResult? completionResult,
    bool clearCompletionResult = false,
    int? completionErrorTick,
  }) {
    return FlowChoreDetailState(
      isLoading: isLoading ?? this.isLoading,
      isCompleting: isCompleting ?? this.isCompleting,
      details: clearDetails ? null : details ?? this.details,
      loadErrorMessage:
          clearLoadError ? null : loadErrorMessage ?? this.loadErrorMessage,
      completionErrorMessage:
          clearCompletionError
              ? null
              : completionErrorMessage ?? this.completionErrorMessage,
      completionResult:
          clearCompletionResult
              ? null
              : completionResult ?? this.completionResult,
      completionErrorTick: completionErrorTick ?? this.completionErrorTick,
    );
  }

  bool get canComplete =>
      details?.chore.state == ChoreState.active && !isCompleting;

  @override
  List<Object?> get props => [
    isLoading,
    isCompleting,
    details,
    loadErrorMessage,
    completionErrorMessage,
    completionResult,
    completionErrorTick,
  ];
}
