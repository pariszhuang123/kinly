part of 'today_bloc.dart';

class TodayState extends Equatable {
  final bool isLoading;
  final List<TodayFlowTask> activeTasks;
  final List<TodayFlowTask> draftTasks;
  final List<TodayShareOwed> shareOwed;
  final List<TodaySharePaidToMe> sharePaidToMe;
  final List<TodayShareDraft> shareDrafts;
  final String? shareErrorMessage;
  final GratitudeWallStatus? gratitudeStatus;
  final PersonalGratitudeStatus? personalGratitudeStatus;
  final TodayUserProfile? profile;
  final String? message;
  final Object? error;
  final int harmonyPromptTick;
  final bool hasShownHarmonyPrompt;
  final int npsPromptTick;
  final bool hasShownNpsPrompt;
  final int notificationPromptTick;
  final bool hasShownNotificationPrompt;
  final int activeChoreCount;
  final bool shouldPromptFlatmateInviteShare;
  final bool shouldPromptInviteShare;
  final bool shouldPromptPreferences;
  final bool shouldPromptHouseNorms;
  final MemberCapJoinRequests? memberCapJoinRequests;
  final MemberCapJoinResolution? memberCapJoinResolution;
  final HousePulsePayload? housePulse;

  const TodayState._({
    required this.isLoading,
    required this.activeTasks,
    required this.draftTasks,
    required this.shareOwed,
    required this.sharePaidToMe,
    required this.shareDrafts,
    this.shareErrorMessage,
    this.gratitudeStatus,
    this.personalGratitudeStatus,
    this.profile,
    this.message,
    this.error,
    this.harmonyPromptTick = 0,
    this.hasShownHarmonyPrompt = false,
    this.npsPromptTick = 0,
    this.hasShownNpsPrompt = false,
    this.notificationPromptTick = 0,
    this.hasShownNotificationPrompt = false,
    this.activeChoreCount = 0,
    this.shouldPromptFlatmateInviteShare = false,
    this.shouldPromptInviteShare = false,
    this.shouldPromptPreferences = false,
    this.shouldPromptHouseNorms = false,
    this.memberCapJoinRequests,
    this.memberCapJoinResolution,
    this.housePulse,
  });

  const TodayState.loading({
    TodayUserProfile? profile,
    List<TodayShareOwed> shareOwed = const [],
    List<TodaySharePaidToMe> sharePaidToMe = const [],
    List<TodayShareDraft> shareDrafts = const [],
    int harmonyPromptTick = 0,
    bool hasShownHarmonyPrompt = false,
    int npsPromptTick = 0,
    bool hasShownNpsPrompt = false,
    GratitudeWallStatus? gratitudeStatus,
    PersonalGratitudeStatus? personalGratitudeStatus,
    int notificationPromptTick = 0,
    bool hasShownNotificationPrompt = false,
    int activeChoreCount = 0,
    bool shouldPromptFlatmateInviteShare = false,
    bool shouldPromptInviteShare = false,
    bool shouldPromptPreferences = false,
    bool shouldPromptHouseNorms = false,
    MemberCapJoinRequests? memberCapJoinRequests,
    MemberCapJoinResolution? memberCapJoinResolution,
    HousePulsePayload? housePulse,
  }) : this._(
         isLoading: true,
         activeTasks: const [],
         draftTasks: const [],
         shareOwed: shareOwed,
         sharePaidToMe: sharePaidToMe,
         shareDrafts: shareDrafts,
         gratitudeStatus: gratitudeStatus,
         personalGratitudeStatus: personalGratitudeStatus,
         profile: profile,
         harmonyPromptTick: harmonyPromptTick,
         hasShownHarmonyPrompt: hasShownHarmonyPrompt,
         npsPromptTick: npsPromptTick,
         hasShownNpsPrompt: hasShownNpsPrompt,
         notificationPromptTick: notificationPromptTick,
         hasShownNotificationPrompt: hasShownNotificationPrompt,
         activeChoreCount: activeChoreCount,
         shouldPromptFlatmateInviteShare: shouldPromptFlatmateInviteShare,
         shouldPromptInviteShare: shouldPromptInviteShare,
         shouldPromptPreferences: shouldPromptPreferences,
         shouldPromptHouseNorms: shouldPromptHouseNorms,
         memberCapJoinRequests: memberCapJoinRequests,
         memberCapJoinResolution: memberCapJoinResolution,
         housePulse: housePulse,
       );

  const TodayState.loaded({
    required List<TodayFlowTask> activeTasks,
    required List<TodayFlowTask> draftTasks,
    required List<TodayShareOwed> shareOwed,
    required List<TodaySharePaidToMe> sharePaidToMe,
    required List<TodayShareDraft> shareDrafts,
    TodayUserProfile? profile,
    String? shareErrorMessage,
    int harmonyPromptTick = 0,
    bool hasShownHarmonyPrompt = false,
    int npsPromptTick = 0,
    bool hasShownNpsPrompt = false,
    GratitudeWallStatus? gratitudeStatus,
    PersonalGratitudeStatus? personalGratitudeStatus,
    int notificationPromptTick = 0,
    bool hasShownNotificationPrompt = false,
    int activeChoreCount = 0,
    bool shouldPromptFlatmateInviteShare = false,
    bool shouldPromptInviteShare = false,
    bool shouldPromptPreferences = false,
    bool shouldPromptHouseNorms = false,
    MemberCapJoinRequests? memberCapJoinRequests,
    MemberCapJoinResolution? memberCapJoinResolution,
    HousePulsePayload? housePulse,
  }) : this._(
         isLoading: false,
         activeTasks: activeTasks,
         draftTasks: draftTasks,
         shareOwed: shareOwed,
         sharePaidToMe: sharePaidToMe,
         shareDrafts: shareDrafts,
         profile: profile,
         shareErrorMessage: shareErrorMessage,
         gratitudeStatus: gratitudeStatus,
         personalGratitudeStatus: personalGratitudeStatus,
         harmonyPromptTick: harmonyPromptTick,
         hasShownHarmonyPrompt: hasShownHarmonyPrompt,
         npsPromptTick: npsPromptTick,
         hasShownNpsPrompt: hasShownNpsPrompt,
         notificationPromptTick: notificationPromptTick,
         hasShownNotificationPrompt: hasShownNotificationPrompt,
         activeChoreCount: activeChoreCount,
         shouldPromptFlatmateInviteShare: shouldPromptFlatmateInviteShare,
         shouldPromptInviteShare: shouldPromptInviteShare,
         shouldPromptPreferences: shouldPromptPreferences,
         shouldPromptHouseNorms: shouldPromptHouseNorms,
         memberCapJoinRequests: memberCapJoinRequests,
         memberCapJoinResolution: memberCapJoinResolution,
         housePulse: housePulse,
       );

  const TodayState.failure({
    TodayUserProfile? profile,
    String? message,
    Object? error,
    List<TodayShareOwed> shareOwed = const [],
    List<TodaySharePaidToMe> sharePaidToMe = const [],
    List<TodayShareDraft> shareDrafts = const [],
    String? shareErrorMessage,
    int harmonyPromptTick = 0,
    bool hasShownHarmonyPrompt = false,
    int npsPromptTick = 0,
    bool hasShownNpsPrompt = false,
    GratitudeWallStatus? gratitudeStatus,
    PersonalGratitudeStatus? personalGratitudeStatus,
    int notificationPromptTick = 0,
    bool hasShownNotificationPrompt = false,
    int activeChoreCount = 0,
    bool shouldPromptFlatmateInviteShare = false,
    bool shouldPromptInviteShare = false,
    bool shouldPromptPreferences = false,
    bool shouldPromptHouseNorms = false,
    MemberCapJoinRequests? memberCapJoinRequests,
    MemberCapJoinResolution? memberCapJoinResolution,
    HousePulsePayload? housePulse,
  }) : this._(
         isLoading: false,
         activeTasks: const [],
         draftTasks: const [],
         shareOwed: shareOwed,
         sharePaidToMe: sharePaidToMe,
         shareDrafts: shareDrafts,
         profile: profile,
         message: message,
         error: error,
         shareErrorMessage: shareErrorMessage,
         gratitudeStatus: gratitudeStatus,
         personalGratitudeStatus: personalGratitudeStatus,
         harmonyPromptTick: harmonyPromptTick,
         hasShownHarmonyPrompt: hasShownHarmonyPrompt,
         npsPromptTick: npsPromptTick,
         hasShownNpsPrompt: hasShownNpsPrompt,
         notificationPromptTick: notificationPromptTick,
         hasShownNotificationPrompt: hasShownNotificationPrompt,
         activeChoreCount: activeChoreCount,
         shouldPromptFlatmateInviteShare: shouldPromptFlatmateInviteShare,
         shouldPromptInviteShare: shouldPromptInviteShare,
         shouldPromptPreferences: shouldPromptPreferences,
         shouldPromptHouseNorms: shouldPromptHouseNorms,
         memberCapJoinRequests: memberCapJoinRequests,
         memberCapJoinResolution: memberCapJoinResolution,
         housePulse: housePulse,
       );

  bool get hasFlowContent => activeTasks.isNotEmpty || draftTasks.isNotEmpty;
  bool get hasShareContent =>
      shareOwed.isNotEmpty ||
      sharePaidToMe.isNotEmpty ||
      shareDrafts.isNotEmpty;
  bool get hasGratitudeUnread => gratitudeStatus?.hasUnread ?? false;
  bool get hasPersonalGratitudeUnread =>
      personalGratitudeStatus?.hasUnread ?? false;
  bool get hasHousePulseCard => hasUnseenHousePulse(housePulse);
  bool get hasAnyTodayContent =>
      hasFlowContent ||
      hasShareContent ||
      hasGratitudeUnread ||
      hasPersonalGratitudeUnread ||
      hasHousePulseCard;
  bool get isCaughtUp => !hasAnyTodayContent;

  @override
  List<Object?> get props => [
    isLoading,
    activeTasks,
    draftTasks,
    shareOwed,
    sharePaidToMe,
    shareDrafts,
    shareErrorMessage,
    gratitudeStatus,
    personalGratitudeStatus,
    profile,
    message,
    error,
    harmonyPromptTick,
    hasShownHarmonyPrompt,
    npsPromptTick,
    hasShownNpsPrompt,
    notificationPromptTick,
    hasShownNotificationPrompt,
    activeChoreCount,
    shouldPromptFlatmateInviteShare,
    shouldPromptInviteShare,
    shouldPromptPreferences,
    shouldPromptHouseNorms,
    memberCapJoinRequests,
    memberCapJoinResolution,
    housePulse,
  ];
}
