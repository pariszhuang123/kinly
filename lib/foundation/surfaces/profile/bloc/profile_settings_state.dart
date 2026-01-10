part of 'profile_settings_bloc.dart';

enum ProfileSettingsAction {
  none,
  leaveSuccess,
  leaveFailure,
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
    required this.leaveEligibilityError,
    required this.leaveInProgress,
    required this.transferInProgress,
    required this.kickInProgress,
    required this.deleteInProgress,
    required this.action,
    required this.actionMessage,
    required this.membership,
    required this.activeMembers,
  });

  factory ProfileSettingsState.initial({ProfileSettingsUser? user}) {
    return ProfileSettingsState(
      user: user,
      isLoadingUser: false,
      leaveEligibilityLoading: false,
      leaveEligibilityError: null,
      leaveInProgress: false,
      transferInProgress: false,
      kickInProgress: false,
      deleteInProgress: false,
      action: ProfileSettingsAction.none,
      actionMessage: null,
      membership: null,
      activeMembers: const <HomeMemberSummary>[],
    );
  }

  final ProfileSettingsUser? user;
  final bool isLoadingUser;
  final bool leaveEligibilityLoading;
  final String? leaveEligibilityError;
  final bool leaveInProgress;
  final bool transferInProgress;
  final bool kickInProgress;
  final bool deleteInProgress;
  final ProfileSettingsAction action;
  final String? actionMessage;
  final CurrentMembership? membership;
  final List<HomeMemberSummary> activeMembers;

  ProfileSettingsState copyWith({
    ProfileSettingsUser? user,
    bool? isLoadingUser,
    bool? leaveEligibilityLoading,
    Object? leaveEligibilityError = _unset,
    bool? leaveInProgress,
    bool? transferInProgress,
    bool? kickInProgress,
    bool? deleteInProgress,
    ProfileSettingsAction? action,
    Object? actionMessage = _unset,
    Object? membership = _unset,
    Object? activeMembers = _unset,
  }) {
    return ProfileSettingsState(
      user: user ?? this.user,
      isLoadingUser: isLoadingUser ?? this.isLoadingUser,
      leaveEligibilityLoading:
          leaveEligibilityLoading ?? this.leaveEligibilityLoading,
      leaveEligibilityError:
          leaveEligibilityError == _unset
              ? this.leaveEligibilityError
              : leaveEligibilityError as String?,
      leaveInProgress: leaveInProgress ?? this.leaveInProgress,
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
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
    user,
    isLoadingUser,
    leaveEligibilityLoading,
    leaveEligibilityError,
    leaveInProgress,
    transferInProgress,
    kickInProgress,
    deleteInProgress,
    action,
    actionMessage,
    membership,
    activeMembers,
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
      transferInProgress ||
      kickInProgress ||
      leaveEligibilityLoading;
}
