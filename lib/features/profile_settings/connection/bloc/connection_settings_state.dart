part of 'connection_settings_bloc.dart';

enum ConnectionSettingsAction {
  none,
  showError,
  openSystemSettings,
  permissionBlocked,
}

class ConnectionSettingsState extends Equatable {
  const ConnectionSettingsState({
    required this.isLoading,
    required this.isSavingToggle,
    required this.isSavingTime,
    required this.wantsDaily,
    required this.preferredHour,
    required this.preferredMinute,
    required this.osPermission,
    required this.locale,
    required this.timezone,
    required this.platform,
    required this.deviceToken,
    required this.pendingEnableAfterSettings,
    required this.action,
    required this.actionMessage,
  });

  factory ConnectionSettingsState.initial() {
    return const ConnectionSettingsState(
      isLoading: true,
      isSavingToggle: false,
      isSavingTime: false,
      wantsDaily: false,
      preferredHour: 9,
      preferredMinute: 0,
      osPermission: 'unknown',
      locale: '',
      timezone: '',
      platform: '',
      deviceToken: null,
      pendingEnableAfterSettings: false,
      action: ConnectionSettingsAction.none,
      actionMessage: null,
    );
  }

  final bool isLoading;
  final bool isSavingToggle;
  final bool isSavingTime;
  final bool wantsDaily;
  final int preferredHour;
  final int preferredMinute;
  final String osPermission;
  final String locale;
  final String timezone;
  final String platform;
  final String? deviceToken;
  final bool pendingEnableAfterSettings;
  final ConnectionSettingsAction action;
  final String? actionMessage;

  bool get canEditTime => wantsDaily && osPermission == 'allowed';

  ConnectionSettingsState copyWith({
    bool? isLoading,
    bool? isSavingToggle,
    bool? isSavingTime,
    bool? wantsDaily,
    int? preferredHour,
    int? preferredMinute,
    String? osPermission,
    String? locale,
    String? timezone,
    String? platform,
    Object? deviceToken = _copySentinel,
    bool? pendingEnableAfterSettings,
    ConnectionSettingsAction? action,
    Object? actionMessage = _copySentinel,
  }) {
    return ConnectionSettingsState(
      isLoading: isLoading ?? this.isLoading,
      isSavingToggle: isSavingToggle ?? this.isSavingToggle,
      isSavingTime: isSavingTime ?? this.isSavingTime,
      wantsDaily: wantsDaily ?? this.wantsDaily,
      preferredHour: preferredHour ?? this.preferredHour,
      preferredMinute: preferredMinute ?? this.preferredMinute,
      osPermission: osPermission ?? this.osPermission,
      locale: locale ?? this.locale,
      timezone: timezone ?? this.timezone,
      platform: platform ?? this.platform,
      deviceToken:
          identical(deviceToken, _copySentinel)
              ? this.deviceToken
              : deviceToken as String?,
      pendingEnableAfterSettings:
          pendingEnableAfterSettings ?? this.pendingEnableAfterSettings,
      action: action ?? this.action,
      actionMessage:
          identical(actionMessage, _copySentinel)
              ? this.actionMessage
              : actionMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSavingToggle,
    isSavingTime,
    wantsDaily,
    preferredHour,
    preferredMinute,
    osPermission,
    locale,
    timezone,
    platform,
    deviceToken,
    pendingEnableAfterSettings,
    action,
    actionMessage,
  ];
}

const _copySentinel = Object();
