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

/// User dismissed the flatmate invite prompt from Today.
class TodayFlatmateInviteDismissed extends TodayEvent {
  const TodayFlatmateInviteDismissed();
}

/// User tapped the flatmate invite CTA from Today (logs share + hides prompt).
class TodayFlatmateInviteShareLogged extends TodayEvent {
  const TodayFlatmateInviteShareLogged({required this.channel});

  /// Share channel, must match allowed channels enforced by Supabase.
  final String channel;

  @override
  List<Object?> get props => [channel];
}

/// User tapped the generic invite CTA from Today (logs share + hides prompt).
class TodayInviteShareLogged extends TodayEvent {
  const TodayInviteShareLogged({required this.channel});

  final String channel;

  @override
  List<Object?> get props => [channel];
}
