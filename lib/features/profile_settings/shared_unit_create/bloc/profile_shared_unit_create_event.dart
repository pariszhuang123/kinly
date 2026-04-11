part of 'profile_shared_unit_create_bloc.dart';

abstract class ProfileSharedUnitCreateEvent extends Equatable {
  const ProfileSharedUnitCreateEvent();

  @override
  List<Object?> get props => [];
}

class ProfileSharedUnitCreateStarted extends ProfileSharedUnitCreateEvent {
  const ProfileSharedUnitCreateStarted();
}

class ProfileSharedUnitCreateNameChanged extends ProfileSharedUnitCreateEvent {
  const ProfileSharedUnitCreateNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class ProfileSharedUnitCreateCandidateToggled
    extends ProfileSharedUnitCreateEvent {
  const ProfileSharedUnitCreateCandidateToggled(
    this.membershipId,
    this.selected,
  );

  final String membershipId;
  final bool selected;

  @override
  List<Object?> get props => [membershipId, selected];
}

class ProfileSharedUnitCreateSubmitted extends ProfileSharedUnitCreateEvent {
  const ProfileSharedUnitCreateSubmitted();
}

class ProfileSharedUnitCreateFeedbackCleared
    extends ProfileSharedUnitCreateEvent {
  const ProfileSharedUnitCreateFeedbackCleared();
}
