part of 'today_bloc.dart';

class TodayState extends Equatable {
  final bool isLoading;
  final List<TodayFlowTask> activeTasks;
  final List<TodayFlowTask> draftTasks;
  final List<TodayShareOwed> shareOwed;
  final List<TodayShareDraft> shareDrafts;
  final String? shareErrorMessage;
  final GratitudeWallStatus? gratitudeStatus;
  final TodayUserProfile? profile;
  final String? message;
  final Object? error;
  final int harmonyPromptTick;
  final bool hasShownHarmonyPrompt;
  final int npsPromptTick;
  final bool hasShownNpsPrompt;

  const TodayState._({
    required this.isLoading,
    required this.activeTasks,
    required this.draftTasks,
    required this.shareOwed,
    required this.shareDrafts,
    this.shareErrorMessage,
    this.gratitudeStatus,
    this.profile,
    this.message,
    this.error,
    this.harmonyPromptTick = 0,
    this.hasShownHarmonyPrompt = false,
    this.npsPromptTick = 0,
    this.hasShownNpsPrompt = false,
  });

  const TodayState.loading({
    TodayUserProfile? profile,
    List<TodayShareOwed> shareOwed = const [],
    List<TodayShareDraft> shareDrafts = const [],
    int harmonyPromptTick = 0,
    bool hasShownHarmonyPrompt = false,
    int npsPromptTick = 0,
    bool hasShownNpsPrompt = false,
    GratitudeWallStatus? gratitudeStatus,
  }) : this._(
         isLoading: true,
         activeTasks: const [],
         draftTasks: const [],
         shareOwed: shareOwed,
         shareDrafts: shareDrafts,
         gratitudeStatus: gratitudeStatus,
         profile: profile,
         harmonyPromptTick: harmonyPromptTick,
         hasShownHarmonyPrompt: hasShownHarmonyPrompt,
         npsPromptTick: npsPromptTick,
         hasShownNpsPrompt: hasShownNpsPrompt,
       );

  const TodayState.loaded({
    required List<TodayFlowTask> activeTasks,
    required List<TodayFlowTask> draftTasks,
    required List<TodayShareOwed> shareOwed,
    required List<TodayShareDraft> shareDrafts,
    TodayUserProfile? profile,
    String? shareErrorMessage,
    int harmonyPromptTick = 0,
    bool hasShownHarmonyPrompt = false,
    int npsPromptTick = 0,
    bool hasShownNpsPrompt = false,
    GratitudeWallStatus? gratitudeStatus,
  }) : this._(
         isLoading: false,
         activeTasks: activeTasks,
         draftTasks: draftTasks,
         shareOwed: shareOwed,
         shareDrafts: shareDrafts,
         profile: profile,
         shareErrorMessage: shareErrorMessage,
         gratitudeStatus: gratitudeStatus,
         harmonyPromptTick: harmonyPromptTick,
         hasShownHarmonyPrompt: hasShownHarmonyPrompt,
         npsPromptTick: npsPromptTick,
         hasShownNpsPrompt: hasShownNpsPrompt,
       );

  const TodayState.failure({
    TodayUserProfile? profile,
    String? message,
    Object? error,
    List<TodayShareOwed> shareOwed = const [],
    List<TodayShareDraft> shareDrafts = const [],
    String? shareErrorMessage,
    int harmonyPromptTick = 0,
    bool hasShownHarmonyPrompt = false,
    int npsPromptTick = 0,
    bool hasShownNpsPrompt = false,
    GratitudeWallStatus? gratitudeStatus,
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
         gratitudeStatus: gratitudeStatus,
         harmonyPromptTick: harmonyPromptTick,
         hasShownHarmonyPrompt: hasShownHarmonyPrompt,
         npsPromptTick: npsPromptTick,
         hasShownNpsPrompt: hasShownNpsPrompt,
       );

  bool get hasFlowContent => activeTasks.isNotEmpty || draftTasks.isNotEmpty;
  bool get hasShareContent => shareOwed.isNotEmpty || shareDrafts.isNotEmpty;
  bool get hasGratitudeUnread => gratitudeStatus?.hasUnread ?? false;

  @override
  List<Object?> get props => [
    isLoading,
    activeTasks,
    draftTasks,
    shareOwed,
    shareDrafts,
    shareErrorMessage,
    gratitudeStatus,
    profile,
    message,
    error,
    harmonyPromptTick,
    hasShownHarmonyPrompt,
    npsPromptTick,
    hasShownNpsPrompt,
  ];
}
