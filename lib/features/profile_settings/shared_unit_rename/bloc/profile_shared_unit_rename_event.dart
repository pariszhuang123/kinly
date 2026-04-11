part of 'profile_shared_unit_rename_bloc.dart';

abstract class ProfileSharedUnitRenameEvent extends Equatable {
  const ProfileSharedUnitRenameEvent();

  @override
  List<Object?> get props => [];
}

class ProfileSharedUnitRenameNameChanged extends ProfileSharedUnitRenameEvent {
  const ProfileSharedUnitRenameNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class ProfileSharedUnitRenameSubmitted extends ProfileSharedUnitRenameEvent {
  const ProfileSharedUnitRenameSubmitted();
}
