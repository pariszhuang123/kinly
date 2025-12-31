import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/notifications/authorization_status_mapper.dart';

import '../../../../core/notifications/notification_permission_service.dart';
import '../../../../core/notifications/notifications.dart';

part 'connection_settings_event.dart';
part 'connection_settings_state.dart';

class ConnectionSettingsBloc
    extends Bloc<ConnectionSettingsEvent, ConnectionSettingsState> {
  ConnectionSettingsBloc({
    required NotificationsRepository notificationsRepository,
    required NotificationPermissionService permissionService,
  }) : _notificationsRepository = notificationsRepository,
       _permissionService = permissionService,
       super(ConnectionSettingsState.initial()) {
    on<ConnectionSettingsStarted>(_onStarted);
    on<ConnectionSettingsToggleRequested>(_onToggleRequested);
    on<ConnectionSettingsTimeChanged>(_onTimeChanged);
    on<ConnectionSettingsPermissionRechecked>(_onPermissionRechecked);
    on<ConnectionSettingsActionCleared>(_onActionCleared);
  }

  final NotificationsRepository _notificationsRepository;
  final NotificationPermissionService _permissionService;

  Future<void> _onStarted(
    ConnectionSettingsStarted event,
    Emitter<ConnectionSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        locale: event.locale,
        timezone: event.timezone,
        platform: event.platform,
        deviceToken: event.deviceToken,
        action: ConnectionSettingsAction.none,
        actionMessage: null,
      ),
    );

    final osPermission = await _readOsPermission();

    try {
      final prefs = await _notificationsRepository.fetchPreferences(
        timezone: event.timezone,
        locale: event.locale,
        osPermission: osPermission,
        deviceToken: event.deviceToken,
        platform: event.platform,
      );

      emit(
        state.copyWith(
          isLoading: false,
          wantsDaily: prefs.wantsDaily,
          preferredHour: prefs.preferredHour,
          preferredMinute: prefs.preferredMinute,
          osPermission:
              prefs.osPermission.isNotEmpty ? prefs.osPermission : osPermission,
          pendingEnableAfterSettings: false,
          action: ConnectionSettingsAction.none,
          actionMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          osPermission: osPermission,
          action: ConnectionSettingsAction.showError,
          actionMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onToggleRequested(
    ConnectionSettingsToggleRequested event,
    Emitter<ConnectionSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        isSavingToggle: true,
        action: ConnectionSettingsAction.none,
        actionMessage: null,
      ),
    );

    if (event.enabled) {
      try {
        await _permissionService.requestAndSync(
          wantsDaily: true,
          preferredHour: state.preferredHour,
          preferredMinute: state.preferredMinute,
          timezone: state.timezone,
          locale: state.locale,
          deviceToken: state.deviceToken,
          platform: state.platform,
        );

        emit(
          state.copyWith(
            wantsDaily: true,
            osPermission: 'allowed',
            isSavingToggle: false,
            pendingEnableAfterSettings: false,
            action: ConnectionSettingsAction.none,
            actionMessage: null,
          ),
        );
      } on NotificationPermissionException catch (error) {
        emit(
          state.copyWith(
            wantsDaily: false,
            osPermission: error.permanentlyDenied ? 'blocked' : 'unknown',
            isSavingToggle: false,
            pendingEnableAfterSettings: error.permanentlyDenied,
            action:
                error.permanentlyDenied
                    ? ConnectionSettingsAction.openSystemSettings
                    : ConnectionSettingsAction.permissionBlocked,
            actionMessage: null,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            isSavingToggle: false,
            action: ConnectionSettingsAction.showError,
            actionMessage: error.toString(),
          ),
        );
      }
      return;
    }

    try {
      final prefs = await _notificationsRepository.updatePreferences(
        wantsDaily: false,
        preferredHour: state.preferredHour,
        preferredMinute: state.preferredMinute,
      );
      emit(
        state.copyWith(
          wantsDaily: prefs.wantsDaily,
          preferredHour: prefs.preferredHour,
          osPermission: prefs.osPermission,
          isSavingToggle: false,
          pendingEnableAfterSettings: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSavingToggle: false,
          action: ConnectionSettingsAction.showError,
          actionMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onTimeChanged(
    ConnectionSettingsTimeChanged event,
    Emitter<ConnectionSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        isSavingTime: true,
        action: ConnectionSettingsAction.none,
        actionMessage: null,
      ),
    );

    try {
      final prefs = await _notificationsRepository.updatePreferences(
        wantsDaily: state.wantsDaily,
        preferredHour: event.hour,
        preferredMinute: event.minute,
      );

      emit(
        state.copyWith(
          preferredHour: prefs.preferredHour,
          preferredMinute: prefs.preferredMinute,
          wantsDaily: prefs.wantsDaily,
          isSavingTime: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSavingTime: false,
          action: ConnectionSettingsAction.showError,
          actionMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onPermissionRechecked(
    ConnectionSettingsPermissionRechecked event,
    Emitter<ConnectionSettingsState> emit,
  ) async {
    final osPermission = await _readOsPermission();
    if (!state.pendingEnableAfterSettings || osPermission != 'allowed') {
      emit(
        state.copyWith(
          osPermission: osPermission,
          pendingEnableAfterSettings: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isSavingToggle: true));
    try {
      final prefs = await _notificationsRepository.syncPreferences(
        wantsDaily: true,
        preferredHour: state.preferredHour,
        preferredMinute: state.preferredMinute,
        timezone: state.timezone,
        locale: state.locale,
        osPermission: osPermission,
        deviceToken: state.deviceToken,
        platform: state.platform,
      );

      emit(
        state.copyWith(
          wantsDaily: prefs.wantsDaily,
          preferredHour: prefs.preferredHour,
          osPermission: prefs.osPermission,
          isSavingToggle: false,
          pendingEnableAfterSettings: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSavingToggle: false,
          pendingEnableAfterSettings: false,
          action: ConnectionSettingsAction.showError,
          actionMessage: error.toString(),
        ),
      );
    }
  }

  void _onActionCleared(
    ConnectionSettingsActionCleared event,
    Emitter<ConnectionSettingsState> emit,
  ) {
    if (state.action == ConnectionSettingsAction.none &&
        state.actionMessage == null) {
      return;
    }
    emit(
      state.copyWith(
        action: ConnectionSettingsAction.none,
        actionMessage: null,
      ),
    );
  }

  Future<String> _readOsPermission() async {
    if (Platform.isIOS) {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      return mapAuthorizationStatusToOsPermission(settings.authorizationStatus);
    }

    final status = await Permission.notification.status;
    if (status.isGranted) return 'allowed';
    if (status.isPermanentlyDenied) return 'blocked';
    if (status.isDenied || status.isRestricted) return 'unknown';
    return 'unknown';
  }
}
