part of 'today_bloc.dart';

class TodayState extends Equatable {
  final bool isLoading;
  final List<TodayFlowTask> activeTasks;
  final List<TodayFlowTask> draftTasks;
  final TodayUserProfile? profile;
  final String? message;
  final Object? error;

  const TodayState._({
    required this.isLoading,
    required this.activeTasks,
    required this.draftTasks,
    this.profile,
    this.message,
    this.error,
  });

  const TodayState.loading({TodayUserProfile? profile})
    : this._(
        isLoading: true,
        activeTasks: const [],
        draftTasks: const [],
        profile: profile,
      );

  const TodayState.loaded({
    required List<TodayFlowTask> activeTasks,
    required List<TodayFlowTask> draftTasks,
    TodayUserProfile? profile,
  }) : this._(
         isLoading: false,
         activeTasks: activeTasks,
         draftTasks: draftTasks,
         profile: profile,
       );

  const TodayState.failure({
    TodayUserProfile? profile,
    String? message,
    Object? error,
  }) : this._(
         isLoading: false,
         activeTasks: const [],
         draftTasks: const [],
         flowTasks: const [],
         profile: profile,
         message: message,
         error: error,
       );

  bool get hasFlowContent => activeTasks.isNotEmpty || draftTasks.isNotEmpty;

  @override
  List<Object?> get props => [
    isLoading,
    activeTasks,
    draftTasks,
    profile,
    message,
    error,
  ];
}
