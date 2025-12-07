import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/services.dart';

import 'package:kinly/core/notifications/notification_permission_service.dart';
import 'package:kinly/core/notifications/notification_preferences.dart';
import 'package:kinly/data/repositories/notifications_repository.dart';
import 'package:kinly/features/profile_settings/connection/bloc/connection_settings_bloc.dart';

class _MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class _MockNotificationPermissionService extends Mock
    implements NotificationPermissionService {}

void main() {
  late _MockNotificationsRepository notificationsRepository;
  late _MockNotificationPermissionService permissionService;

  setUpAll(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    const channelName = 'flutter.baseflow.com/permissions/methods';
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel(channelName), (methodCall) async {
      switch (methodCall.method) {
        case 'checkPermissionStatus':
          return 1; // granted
        case 'requestPermissions':
          final perms = methodCall.arguments['permissions'] as List<dynamic>;
          return {for (final p in perms) p: 1}; // granted
        case 'shouldShowRequestPermissionRationale':
          return false;
      }
      return null;
    });
  });

  setUp(() {
    notificationsRepository = _MockNotificationsRepository();
    permissionService = _MockNotificationPermissionService();
  });

  ConnectionSettingsBloc buildBloc() {
    return ConnectionSettingsBloc(
      notificationsRepository: notificationsRepository,
      permissionService: permissionService,
    );
  }

  group('ConnectionSettingsBloc', () {
    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'loads preferences on start',
      build: () {
        when(
          () => notificationsRepository.fetchPreferences(
            timezone: any(named: 'timezone'),
            locale: any(named: 'locale'),
            osPermission: any(named: 'osPermission'),
            deviceToken: any(named: 'deviceToken'),
            platform: any(named: 'platform'),
          ),
        ).thenAnswer(
          (_) async => const NotificationPreferences(
            wantsDaily: true,
            preferredHour: 9,
            osPermission: 'allowed',
          ),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const ConnectionSettingsStarted(
          locale: 'en',
          timezone: 'UTC',
          platform: 'ios',
          deviceToken: 'token-1',
        ),
      ),
      expect: () => [
        ConnectionSettingsState.initial().copyWith(
          isLoading: true,
          locale: 'en',
          timezone: 'UTC',
          platform: 'ios',
          deviceToken: 'token-1',
          action: ConnectionSettingsAction.none,
          actionMessage: null,
        ),
        ConnectionSettingsState.initial().copyWith(
          isLoading: false,
          locale: 'en',
          timezone: 'UTC',
          platform: 'ios',
          deviceToken: 'token-1',
          wantsDaily: true,
          preferredHour: 9,
          osPermission: 'allowed',
          pendingEnableAfterSettings: false,
          action: ConnectionSettingsAction.none,
          actionMessage: null,
        ),
      ],
      verify: (_) {
        verify(
          () => notificationsRepository.fetchPreferences(
            timezone: 'UTC',
            locale: 'en',
            osPermission: 'allowed',
            deviceToken: 'token-1',
            platform: 'ios',
          ),
        ).called(1);
      },
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'enables notifications when permission is granted',
      build: () {
        when(
          () => permissionService.requestAndSync(
            wantsDaily: any(named: 'wantsDaily'),
            preferredHour: any(named: 'preferredHour'),
            timezone: any(named: 'timezone'),
            locale: any(named: 'locale'),
            deviceToken: any(named: 'deviceToken'),
            platform: any(named: 'platform'),
          ),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      seed: () => ConnectionSettingsState.initial().copyWith(
        timezone: 'UTC',
        locale: 'en',
        platform: 'ios',
        preferredHour: 9,
      ),
      act: (bloc) => bloc.add(const ConnectionSettingsToggleRequested(
        enabled: true,
      )),
      expect: () => [
        ConnectionSettingsState.initial().copyWith(
          timezone: 'UTC',
          locale: 'en',
          platform: 'ios',
          preferredHour: 9,
          isSavingToggle: true,
          action: ConnectionSettingsAction.none,
          actionMessage: null,
        ),
        ConnectionSettingsState.initial().copyWith(
          timezone: 'UTC',
          locale: 'en',
          platform: 'ios',
          preferredHour: 9,
          wantsDaily: true,
          osPermission: 'allowed',
          isSavingToggle: false,
          pendingEnableAfterSettings: false,
          action: ConnectionSettingsAction.none,
          actionMessage: null,
        ),
      ],
      verify: (_) {
        verify(
          () => permissionService.requestAndSync(
            wantsDaily: true,
            preferredHour: 9,
            timezone: 'UTC',
            locale: 'en',
            deviceToken: null,
            platform: 'ios',
          ),
        ).called(1);
      },
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'prompts system settings when permission is permanently denied',
      build: () {
        when(
          () => permissionService.requestAndSync(
            wantsDaily: any(named: 'wantsDaily'),
            preferredHour: any(named: 'preferredHour'),
            timezone: any(named: 'timezone'),
            locale: any(named: 'locale'),
            deviceToken: any(named: 'deviceToken'),
            platform: any(named: 'platform'),
          ),
        ).thenThrow(
          NotificationPermissionException(permanentlyDenied: true),
        );
        return buildBloc();
      },
      seed: () => ConnectionSettingsState.initial().copyWith(
        timezone: 'UTC',
        locale: 'en',
        platform: 'ios',
        preferredHour: 9,
      ),
      act: (bloc) => bloc.add(const ConnectionSettingsToggleRequested(
        enabled: true,
      )),
      expect: () => [
        ConnectionSettingsState.initial().copyWith(
          timezone: 'UTC',
          locale: 'en',
          platform: 'ios',
          preferredHour: 9,
          isSavingToggle: true,
          action: ConnectionSettingsAction.none,
          actionMessage: null,
        ),
        ConnectionSettingsState.initial().copyWith(
          timezone: 'UTC',
          locale: 'en',
          platform: 'ios',
          preferredHour: 9,
          wantsDaily: false,
          osPermission: 'blocked',
          isSavingToggle: false,
          pendingEnableAfterSettings: true,
          action: ConnectionSettingsAction.openSystemSettings,
          actionMessage: null,
        ),
      ],
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'updates time when notifications are enabled',
      build: () {
        when(
          () => notificationsRepository.updatePreferences(
            wantsDaily: any(named: 'wantsDaily'),
            preferredHour: any(named: 'preferredHour'),
          ),
        ).thenAnswer(
          (_) async => const NotificationPreferences(
            wantsDaily: true,
            preferredHour: 7,
            osPermission: 'allowed',
          ),
        );
        return buildBloc();
      },
      seed: () => ConnectionSettingsState.initial().copyWith(
        wantsDaily: true,
        osPermission: 'allowed',
        preferredHour: 9,
      ),
      act: (bloc) => bloc.add(const ConnectionSettingsTimeChanged(hour: 7)),
      expect: () => [
        ConnectionSettingsState.initial().copyWith(
          wantsDaily: true,
          osPermission: 'allowed',
          preferredHour: 9,
          isSavingTime: true,
          action: ConnectionSettingsAction.none,
          actionMessage: null,
        ),
        ConnectionSettingsState.initial().copyWith(
          wantsDaily: true,
          osPermission: 'allowed',
          preferredHour: 7,
          isSavingTime: false,
        ),
      ],
    );
  });
}
