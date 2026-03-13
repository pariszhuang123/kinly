part of 'house_directory_bloc.dart';

sealed class HouseDirectoryEvent extends Equatable {
  const HouseDirectoryEvent();

  @override
  List<Object?> get props => [];
}

class HouseDirectoryStarted extends HouseDirectoryEvent {
  const HouseDirectoryStarted();
}

class HouseDirectoryRefreshed extends HouseDirectoryEvent {
  const HouseDirectoryRefreshed();
}

class HouseDirectoryWifiSaved extends HouseDirectoryEvent {
  const HouseDirectoryWifiSaved(this.input);

  final UpsertHouseDirectoryWifiInput input;

  @override
  List<Object?> get props => [input];
}

class HouseDirectoryServiceSaved extends HouseDirectoryEvent {
  const HouseDirectoryServiceSaved(this.input);

  final UpsertHouseDirectoryServiceInput input;

  @override
  List<Object?> get props => [input];
}

class HouseDirectoryServiceArchived extends HouseDirectoryEvent {
  const HouseDirectoryServiceArchived(this.serviceId);

  final String serviceId;

  @override
  List<Object?> get props => [serviceId];
}

class HouseDirectoryLinkSaved extends HouseDirectoryEvent {
  const HouseDirectoryLinkSaved(this.input);

  final UpsertHouseDirectoryLinkInput input;

  @override
  List<Object?> get props => [input];
}

class HouseDirectoryLinkArchived extends HouseDirectoryEvent {
  const HouseDirectoryLinkArchived(this.linkId);

  final String linkId;

  @override
  List<Object?> get props => [linkId];
}

class HouseDirectoryReminderAcknowledged extends HouseDirectoryEvent {
  const HouseDirectoryReminderAcknowledged(this.reminderId);

  final String reminderId;

  @override
  List<Object?> get props => [reminderId];
}

class HouseDirectoryReminderDismissed extends HouseDirectoryEvent {
  const HouseDirectoryReminderDismissed(this.reminderId);

  final String reminderId;

  @override
  List<Object?> get props => [reminderId];
}
