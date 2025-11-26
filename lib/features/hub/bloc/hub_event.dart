part of 'hub_bloc.dart';

sealed class HubEvent extends Equatable {
  const HubEvent();

  @override
  List<Object?> get props => [];
}

class HubStarted extends HubEvent {
  const HubStarted();
}

class HubRefreshed extends HubEvent {
  const HubRefreshed();
}

class HubInviteRotated extends HubEvent {
  const HubInviteRotated();
}
