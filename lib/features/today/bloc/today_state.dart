part of 'today_bloc.dart';

class TodayState extends Equatable {
  final bool isLoading;
  final List<TodayFlowTask> flowTasks;
  final String? message;
  final Object? error;

  const TodayState._({
    required this.isLoading,
    required this.flowTasks,
    this.message,
    this.error,
  });

  const TodayState.loading() : this._(isLoading: true, flowTasks: const []);

  const TodayState.loaded({required List<TodayFlowTask> flowTasks})
    : this._(isLoading: false, flowTasks: flowTasks);

  const TodayState.failure({String? message, Object? error})
    : this._(
        isLoading: false,
        flowTasks: const [],
        message: message,
        error: error,
      );

  @override
  List<Object?> get props => [isLoading, flowTasks, message, error];
}
