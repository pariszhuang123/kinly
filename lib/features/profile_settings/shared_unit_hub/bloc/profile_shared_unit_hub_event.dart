part of 'profile_shared_unit_hub_bloc.dart';

abstract class ProfileSharedUnitHubEvent extends Equatable {
  const ProfileSharedUnitHubEvent();

  @override
  List<Object?> get props => const [];
}

class ProfileSharedUnitHubStarted extends ProfileSharedUnitHubEvent {
  const ProfileSharedUnitHubStarted();
}

class ProfileSharedUnitHubLeaveRequested extends ProfileSharedUnitHubEvent {
  const ProfileSharedUnitHubLeaveRequested();
}
