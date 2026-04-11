part of 'profile_shared_unit_join_bloc.dart';

abstract class ProfileSharedUnitJoinEvent extends Equatable {
  const ProfileSharedUnitJoinEvent();

  @override
  List<Object?> get props => [];
}

class ProfileSharedUnitJoinStarted extends ProfileSharedUnitJoinEvent {
  const ProfileSharedUnitJoinStarted();
}

class ProfileSharedUnitJoinSelected extends ProfileSharedUnitJoinEvent {
  const ProfileSharedUnitJoinSelected(this.unitId);

  final String unitId;

  @override
  List<Object?> get props => [unitId];
}

class ProfileSharedUnitJoinSubmitted extends ProfileSharedUnitJoinEvent {
  const ProfileSharedUnitJoinSubmitted();
}
