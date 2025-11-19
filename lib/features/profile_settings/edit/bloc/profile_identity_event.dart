part of 'profile_identity_bloc.dart';

abstract class ProfileIdentityEvent extends Equatable {
  const ProfileIdentityEvent();

  @override
  List<Object?> get props => [];
}

class ProfileIdentityStarted extends ProfileIdentityEvent {
  const ProfileIdentityStarted();
}

class ProfileIdentityUsernameChanged extends ProfileIdentityEvent {
  const ProfileIdentityUsernameChanged(this.username);

  final String username;

  @override
  List<Object?> get props => [username];
}

class ProfileIdentityAvatarSelected extends ProfileIdentityEvent {
  const ProfileIdentityAvatarSelected(this.avatarId);

  final String avatarId;

  @override
  List<Object?> get props => [avatarId];
}

class ProfileIdentitySubmitted extends ProfileIdentityEvent {
  const ProfileIdentitySubmitted();
}
