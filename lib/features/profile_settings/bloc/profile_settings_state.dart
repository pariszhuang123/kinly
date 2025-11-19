part of 'profile_settings_bloc.dart';

enum ProfileSettingsAction {
  none,
  leaveSuccess,
  leaveFailure,
  deleteSuccess,
  deleteFailure,
}

class ProfileSettingsUser extends Equatable {
  const ProfileSettingsUser({required this.displayName, this.avatarUrl});

  final String displayName;
  final String? avatarUrl;

  @override
  List<Object?> get props => [displayName, avatarUrl];
}

class ProfileSettingsState extends Equatable {
  const ProfileSettingsState({
    required this.user,
    required this.isLoadingUser,
    required this.leaveInProgress,
    required this.deleteInProgress,
    required this.action,
    required this.actionMessage,
  });

  factory ProfileSettingsState.initial({ProfileSettingsUser? user}) {
    return ProfileSettingsState(
      user: user,
      isLoadingUser: false,
      leaveInProgress: false,
      deleteInProgress: false,
      action: ProfileSettingsAction.none,
      actionMessage: null,
    );
  }

  final ProfileSettingsUser? user;
  final bool isLoadingUser;
  final bool leaveInProgress;
  final bool deleteInProgress;
  final ProfileSettingsAction action;
  final String? actionMessage;

  ProfileSettingsState copyWith({
    ProfileSettingsUser? user,
    bool? isLoadingUser,
    bool? leaveInProgress,
    bool? deleteInProgress,
    ProfileSettingsAction? action,
    Object? actionMessage = _unset,
  }) {
    return ProfileSettingsState(
      user: user ?? this.user,
      isLoadingUser: isLoadingUser ?? this.isLoadingUser,
      leaveInProgress: leaveInProgress ?? this.leaveInProgress,
      deleteInProgress: deleteInProgress ?? this.deleteInProgress,
      action: action ?? this.action,
      actionMessage:
          actionMessage == _unset
              ? this.actionMessage
              : actionMessage as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
    user,
    isLoadingUser,
    leaveInProgress,
    deleteInProgress,
    action,
    actionMessage,
  ];
}
