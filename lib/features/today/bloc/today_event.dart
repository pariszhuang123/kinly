part of 'today_bloc.dart';

abstract class TodayEvent extends Equatable {
  const TodayEvent();

  @override
  List<Object?> get props => [];
}

class TodayStarted extends TodayEvent {
  const TodayStarted();
}

class TodayRefreshed extends TodayEvent {
  const TodayRefreshed();
}

class TodayProfileUpdated extends TodayEvent {
  const TodayProfileUpdated(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}
