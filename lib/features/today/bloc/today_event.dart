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
