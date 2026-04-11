part of 'profile_settings_bloc.dart';

abstract class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();

  @override
  List<Object?> get props => [];
}

enum TransferFollowUp { leave, delete }

class ProfileSettingsStarted extends ProfileSettingsEvent {
  const ProfileSettingsStarted();
}

class ProfileSettingsLeaveRequested extends ProfileSettingsEvent {
  const ProfileSettingsLeaveRequested();
}

class ProfileSettingsTransferOwnerRequested extends ProfileSettingsEvent {
  const ProfileSettingsTransferOwnerRequested(
    this.newOwnerUserId, {
    this.followUp = TransferFollowUp.leave,
  });

  final String newOwnerUserId;
  final TransferFollowUp followUp;

  @override
  List<Object?> get props => [newOwnerUserId, followUp];
}

class ProfileSettingsKickMemberRequested extends ProfileSettingsEvent {
  const ProfileSettingsKickMemberRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class ProfileSettingsDeleteRequested extends ProfileSettingsEvent {
  const ProfileSettingsDeleteRequested();
}

class ProfileSettingsSharedUnitLeaveRequested extends ProfileSettingsEvent {
  const ProfileSettingsSharedUnitLeaveRequested(this.unitId);

  final String unitId;

  @override
  List<Object?> get props => [unitId];
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
