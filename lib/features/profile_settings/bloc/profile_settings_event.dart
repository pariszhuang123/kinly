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

class ProfileSettingsDeleteRequested extends ProfileSettingsEvent {
  const ProfileSettingsDeleteRequested();
}

class ProfileSettingsActionCleared extends ProfileSettingsEvent {
  const ProfileSettingsActionCleared();
}
