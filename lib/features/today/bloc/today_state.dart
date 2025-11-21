part of 'today_bloc.dart';

class TodayState extends Equatable {
  final bool isLoading;
  final List<TodayFlowTask> activeTasks;
  final List<TodayFlowTask> draftTasks;
  final List<TodayShareOwed> shareOwed;
  final List<TodayShareDraft> shareDrafts;
  final String? shareErrorMessage;
  final TodayUserProfile? profile;
  final String? message;
  final Object? error;

  const TodayState._({
    required this.isLoading,
    required this.activeTasks,
    required this.draftTasks,
    required this.shareOwed,
    required this.shareDrafts,
    this.shareErrorMessage,
    this.profile,
    this.message,
    this.error,
  });

  const TodayState.loading({
    TodayUserProfile? profile,
    List<TodayShareOwed> shareOwed = const [],
    List<TodayShareDraft> shareDrafts = const [],
  }) : this._(
         isLoading: true,
         activeTasks: const [],
         draftTasks: const [],
         shareOwed: shareOwed,
         shareDrafts: shareDrafts,
         profile: profile,
       );

  const TodayState.loaded({
    required List<TodayFlowTask> activeTasks,
    required List<TodayFlowTask> draftTasks,
    required List<TodayShareOwed> shareOwed,
    required List<TodayShareDraft> shareDrafts,
    TodayUserProfile? profile,
    String? shareErrorMessage,
  }) : this._(
         isLoading: false,
         activeTasks: activeTasks,
         draftTasks: draftTasks,
         shareOwed: shareOwed,
         shareDrafts: shareDrafts,
         profile: profile,
         shareErrorMessage: shareErrorMessage,
       );

  const TodayState.failure({
    TodayUserProfile? profile,
    String? message,
    Object? error,
    List<TodayShareOwed> shareOwed = const [],
    List<TodayShareDraft> shareDrafts = const [],
    String? shareErrorMessage,
  }) : this._(
         isLoading: false,
         activeTasks: const [],
         draftTasks: const [],
         shareOwed: shareOwed,
         shareDrafts: shareDrafts,
         profile: profile,
         message: message,
         error: error,
         shareErrorMessage: shareErrorMessage,
       );

  bool get hasFlowContent => activeTasks.isNotEmpty || draftTasks.isNotEmpty;
  bool get hasShareContent => shareOwed.isNotEmpty || shareDrafts.isNotEmpty;

  @override
  List<Object?> get props => [
    isLoading,
    activeTasks,
    draftTasks,
    shareOwed,
    shareDrafts,
    shareErrorMessage,
    profile,
    message,
    error,
  ];
}
