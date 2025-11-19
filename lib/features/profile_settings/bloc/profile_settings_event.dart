part of 'profile_settings_bloc.dart';

abstract class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();

  @override
  List<Object?> get props => [];
}

class ProfileSettingsStarted extends ProfileSettingsEvent {
  const ProfileSettingsStarted();
}

class ProfileSettingsLeaveRequested extends ProfileSettingsEvent {
  const ProfileSettingsLeaveRequested();
}

class ProfileSettingsTransferOwnerRequested extends ProfileSettingsEvent {
  const ProfileSettingsTransferOwnerRequested(this.newOwnerUserId);

  final String newOwnerUserId;

  @override
  List<Object?> get props => [newOwnerUserId];
}

class ProfileSettingsDeleteRequested extends ProfileSettingsEvent {
  const ProfileSettingsDeleteRequested();
}

class ProfileSettingsActionCleared extends ProfileSettingsEvent {
  const ProfileSettingsActionCleared();
}

class ProfileSettingsUserUpdated extends ProfileSettingsEvent {
  const ProfileSettingsUserUpdated(this.user);

  final ProfileSettingsUser user;

  @override
  List<Object?> get props => [user];
}
