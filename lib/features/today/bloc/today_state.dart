part of 'today_bloc.dart';

class TodayState extends Equatable {
  final bool isLoading;
  final List<TodayFlowTask> flowTasks;
  final TodayUserProfile? profile;
  final String? message;
  final Object? error;

  const TodayState._({
    required this.isLoading,
    required this.flowTasks,
    this.profile,
    this.message,
    this.error,
  });

  const TodayState.loading({TodayUserProfile? profile})
    : this._(isLoading: true, flowTasks: const [], profile: profile);

  const TodayState.loaded({
    required List<TodayFlowTask> flowTasks,
    TodayUserProfile? profile,
  }) : this._(isLoading: false, flowTasks: flowTasks, profile: profile);

  const TodayState.failure({
    TodayUserProfile? profile,
    String? message,
    Object? error,
  })
    : this._(
        isLoading: false,
        flowTasks: const [],
        profile: profile,
        message: message,
        error: error,
      );

  @override
  List<Object?> get props => [isLoading, flowTasks, profile, message, error];
}
