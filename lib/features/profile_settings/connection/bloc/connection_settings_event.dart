part of 'connection_settings_bloc.dart';

abstract class ConnectionSettingsEvent extends Equatable {
  const ConnectionSettingsEvent();

  @override
  List<Object?> get props => [];
}

class ConnectionSettingsStarted extends ConnectionSettingsEvent {
  const ConnectionSettingsStarted({
    required this.locale,
    required this.timezone,
    required this.platform,
    this.deviceToken,
  });

  final String locale;
  final String timezone;
  final String platform;
  final String? deviceToken;

  @override
  List<Object?> get props => [locale, timezone, platform, deviceToken];
}

class ConnectionSettingsToggleRequested extends ConnectionSettingsEvent {
  const ConnectionSettingsToggleRequested({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class ConnectionSettingsTimeChanged extends ConnectionSettingsEvent {
  const ConnectionSettingsTimeChanged({required this.hour});

  final int hour;

  @override
  List<Object?> get props => [hour];
}

class ConnectionSettingsPermissionRechecked extends ConnectionSettingsEvent {
  const ConnectionSettingsPermissionRechecked();
}

class ConnectionSettingsActionCleared extends ConnectionSettingsEvent {
  const ConnectionSettingsActionCleared();
}
