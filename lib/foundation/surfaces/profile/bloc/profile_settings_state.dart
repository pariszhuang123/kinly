part of 'profile_settings_bloc.dart';

enum ProfileSettingsAction {
  none,
  leaveSuccess,
  leaveFailure,
  sharedUnitLeaveSuccess,
  sharedUnitLeaveFailure,
  transferSuccess,
  transferFailure,
  kickSuccess,
  kickFailure,
  deleteSuccess,
  deleteFailure,
}

class ProfileSettingsUser extends Equatable {
  const ProfileSettingsUser({
    required this.displayName,
    this.avatarUrl,
    this.avatarStoragePath,
  });

  final String displayName;
  final String? avatarUrl;
  final String? avatarStoragePath;

  ProfileSettingsUser copyWith({
    String? displayName,
    String? avatarUrl,
    String? avatarStoragePath,
  }) {
    return ProfileSettingsUser(
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarStoragePath: avatarStoragePath ?? this.avatarStoragePath,
    );
  }

  @override
  List<Object?> get props => [displayName, avatarUrl, avatarStoragePath];
}

class ProfileSettingsState extends Equatable {
  const ProfileSettingsState({
    required this.user,
    required this.isLoadingUser,
    required this.leaveEligibilityLoading,
    required this.homeUnitsLoading,
    required this.leaveEligibilityError,
    required this.homeUnitsError,
    required this.leaveInProgress,
    required this.sharedUnitLeaveInProgress,
    required this.transferInProgress,
    required this.kickInProgress,
    required this.deleteInProgress,
    required this.action,
    required this.actionMessage,
    required this.membership,
    required this.activeMembers,
    required this.homeUnitContext,
    required this.sharedUnitCreateCandidates,
    required this.joinableSharedUnits,
    required this.planStatus,
    required this.planStatusLoading,
  });

  factory ProfileSettingsState.initial({ProfileSettingsUser? user}) {
    return ProfileSettingsState(
      user: user,
      isLoadingUser: false,
      leaveEligibilityLoading: false,
      homeUnitsLoading: false,
      leaveEligibilityError: null,
      homeUnitsError: null,
      leaveInProgress: false,
      sharedUnitLeaveInProgress: false,
      transferInProgress: false,
      kickInProgress: false,
      deleteInProgress: false,
      action: ProfileSettingsAction.none,
      actionMessage: null,
      membership: null,
      activeMembers: const <HomeMemberSummary>[],
      homeUnitContext: null,
      sharedUnitCreateCandidates: const <HomeUnitMemberCandidate>[],
      joinableSharedUnits: const <HomeUnitSummary>[],
      planStatus: PlanStatus.unknown,
      planStatusLoading: false,
    );
  }

  final ProfileSettingsUser? user;
  final bool isLoadingUser;
  final bool leaveEligibilityLoading;
  final bool homeUnitsLoading;
  final String? leaveEligibilityError;
  final String? homeUnitsError;
  final bool leaveInProgress;
  final bool sharedUnitLeaveInProgress;
  final bool transferInProgress;
  final bool kickInProgress;
  final bool deleteInProgress;
  final ProfileSettingsAction action;
  final String? actionMessage;
  final CurrentMembership? membership;

  final List<HomeMemberSummary> activeMembers;
  final HomeUnitContext? homeUnitContext;
  final List<HomeUnitMemberCandidate> sharedUnitCreateCandidates;
  final List<HomeUnitSummary> joinableSharedUnits;
  final PlanStatus planStatus;
  final bool planStatusLoading;

  ProfileSettingsState copyWith({
    ProfileSettingsUser? user,
    bool? isLoadingUser,
    bool? leaveEligibilityLoading,
    bool? homeUnitsLoading,
    Object? leaveEligibilityError = _unset,
    Object? homeUnitsError = _unset,
    bool? leaveInProgress,
    bool? sharedUnitLeaveInProgress,
    bool? transferInProgress,
    bool? kickInProgress,
    bool? deleteInProgress,
    ProfileSettingsAction? action,
    Object? actionMessage = _unset,
    Object? membership = _unset,

    Object? activeMembers = _unset,
    Object? homeUnitContext = _unset,
    Object? sharedUnitCreateCandidates = _unset,
    Object? joinableSharedUnits = _unset,
    PlanStatus? planStatus,
    bool? planStatusLoading,
  }) {
    return ProfileSettingsState(
      user: user ?? this.user,
      isLoadingUser: isLoadingUser ?? this.isLoadingUser,
      leaveEligibilityLoading:
          leaveEligibilityLoading ?? this.leaveEligibilityLoading,
      homeUnitsLoading: homeUnitsLoading ?? this.homeUnitsLoading,
      leaveEligibilityError:
          leaveEligibilityError == _unset
              ? this.leaveEligibilityError
              : leaveEligibilityError as String?,
      homeUnitsError:
          homeUnitsError == _unset
              ? this.homeUnitsError
              : homeUnitsError as String?,
      leaveInProgress: leaveInProgress ?? this.leaveInProgress,
      sharedUnitLeaveInProgress:
          sharedUnitLeaveInProgress ?? this.sharedUnitLeaveInProgress,
      transferInProgress: transferInProgress ?? this.transferInProgress,
      kickInProgress: kickInProgress ?? this.kickInProgress,
      deleteInProgress: deleteInProgress ?? this.deleteInProgress,
      action: action ?? this.action,
      actionMessage:
          actionMessage == _unset
              ? this.actionMessage
              : actionMessage as String?,
      membership:
          membership == _unset
              ? this.membership
              : membership as CurrentMembership?,
      activeMembers:
          activeMembers == _unset
              ? this.activeMembers
              : List<HomeMemberSummary>.unmodifiable(
                activeMembers as List<HomeMemberSummary>,
              ),
      homeUnitContext:
          homeUnitContext == _unset
              ? this.homeUnitContext
              : homeUnitContext as HomeUnitContext?,
      sharedUnitCreateCandidates:
          sharedUnitCreateCandidates == _unset
              ? this.sharedUnitCreateCandidates
              : List<HomeUnitMemberCandidate>.unmodifiable(
                sharedUnitCreateCandidates as List<HomeUnitMemberCandidate>,
              ),
      joinableSharedUnits:
          joinableSharedUnits == _unset
              ? this.joinableSharedUnits
              : List<HomeUnitSummary>.unmodifiable(
                joinableSharedUnits as List<HomeUnitSummary>,
              ),
      planStatus: planStatus ?? this.planStatus,
      planStatusLoading: planStatusLoading ?? this.planStatusLoading,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
    user,
    isLoadingUser,
    leaveEligibilityLoading,
    homeUnitsLoading,
    leaveEligibilityError,
    homeUnitsError,
    leaveInProgress,
    sharedUnitLeaveInProgress,
    transferInProgress,
    kickInProgress,
    deleteInProgress,
    action,
    actionMessage,
    membership,
    activeMembers,
    homeUnitContext,
    sharedUnitCreateCandidates,
    joinableSharedUnits,
    planStatus,
    planStatusLoading,
  ];

  bool get isOwner => (membership?.role.toLowerCase() ?? 'member') == 'owner';

  List<HomeMemberSummary> get otherActiveMembers {
    final currentUserId = membership?.userId;
    if (currentUserId == null) return activeMembers;
    return activeMembers
        .where((member) => member.userId != currentUserId)
        .toList(growable: false);
  }

  List<HomeMemberSummary> get transferCandidates {
    final currentUserId = membership?.userId;
    return activeMembers
        .where(
          (member) => member.userId != currentUserId && member.canTransferTo,
        )
        .toList(growable: false);
  }

  List<HomeMemberSummary> get kickEligibleMembers {
    final currentUserId = membership?.userId;
    return activeMembers
        .where((member) => member.userId != currentUserId && !member.isOwner)
        .toList(growable: false);
  }

  bool get isLeaveActionBusy =>
      leaveInProgress ||
      sharedUnitLeaveInProgress ||
      transferInProgress ||
      kickInProgress ||
      leaveEligibilityLoading;

  bool get canCreateSharedUnit {
    final membershipId = membership?.membershipId;
    return !homeUnitsLoading &&
        membershipId != null &&
        membershipId.isNotEmpty &&
        homeUnitContext != null &&
        !homeUnitContext!.hasSharedUnit &&
        sharedUnitCreateCandidates.isNotEmpty;
  }

  bool get canJoinSharedUnit =>
      !homeUnitsLoading &&
      homeUnitContext != null &&
      !homeUnitContext!.hasSharedUnit &&
      joinableSharedUnits.isNotEmpty;

  List<HomeMemberSummary> get activeSharedUnitMembers {
    final memberIds =
        homeUnitContext?.activeSharedUnit?.memberUserIds ?? const <String>[];
    if (memberIds.isEmpty) {
      return const <HomeMemberSummary>[];
    }
    return activeMembers
        .where((member) => memberIds.contains(member.userId))
        .toList(growable: false);
  }

  bool get shouldShowSharedUnitSection =>
      homeUnitContext?.hasSharedUnit == true ||
      canCreateSharedUnit ||
      canJoinSharedUnit;
}
