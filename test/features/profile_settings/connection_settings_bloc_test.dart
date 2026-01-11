import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/services.dart';

import 'package:kinly/core/notifications/notification_permission_service.dart';
import 'package:kinly/core/notifications/notifications.dart';
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
      const MethodChannel(channelName),
      (methodCall) async {
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
      },
    );
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
            preferredMinute: 0,
            osPermission: 'allowed',
          ),
        );
        return buildBloc();
      },
      act:
          (bloc) => bloc.add(
            const ConnectionSettingsStarted(
              locale: 'en',
              timezone: 'UTC',
              platform: 'ios',
              deviceToken: 'token-1',
            ),
          ),
      expect:
          () => [
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
              preferredMinute: 0,
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
            preferredMinute: any(named: 'preferredMinute'),
            timezone: any(named: 'timezone'),
            locale: any(named: 'locale'),
            deviceToken: any(named: 'deviceToken'),
            platform: any(named: 'platform'),
          ),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            timezone: 'UTC',
            locale: 'en',
            platform: 'ios',
            preferredHour: 9,
            preferredMinute: 0,
          ),
      act:
          (bloc) =>
              bloc.add(const ConnectionSettingsToggleRequested(enabled: true)),
      expect:
          () => [
            ConnectionSettingsState.initial().copyWith(
              timezone: 'UTC',
              locale: 'en',
              platform: 'ios',
              preferredHour: 9,
              preferredMinute: 0,
              isSavingToggle: true,
              action: ConnectionSettingsAction.none,
              actionMessage: null,
            ),
            ConnectionSettingsState.initial().copyWith(
              timezone: 'UTC',
              locale: 'en',
              platform: 'ios',
              preferredHour: 9,
              preferredMinute: 0,
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
            preferredMinute: 0,
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
            preferredMinute: any(named: 'preferredMinute'),
            timezone: any(named: 'timezone'),
            locale: any(named: 'locale'),
            deviceToken: any(named: 'deviceToken'),
            platform: any(named: 'platform'),
          ),
        ).thenThrow(NotificationPermissionException(permanentlyDenied: true));
        return buildBloc();
      },
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            timezone: 'UTC',
            locale: 'en',
            platform: 'ios',
            preferredHour: 9,
            preferredMinute: 0,
          ),
      act:
          (bloc) =>
              bloc.add(const ConnectionSettingsToggleRequested(enabled: true)),
      expect:
          () => [
            ConnectionSettingsState.initial().copyWith(
              timezone: 'UTC',
              locale: 'en',
              platform: 'ios',
              preferredHour: 9,
              preferredMinute: 0,
              isSavingToggle: true,
              action: ConnectionSettingsAction.none,
              actionMessage: null,
            ),
            ConnectionSettingsState.initial().copyWith(
              timezone: 'UTC',
              locale: 'en',
              platform: 'ios',
              preferredHour: 9,
              preferredMinute: 0,
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
            preferredMinute: any(named: 'preferredMinute'),
          ),
        ).thenAnswer(
          (_) async => const NotificationPreferences(
            wantsDaily: true,
            preferredHour: 7,
            preferredMinute: 15,
            osPermission: 'allowed',
          ),
        );
        return buildBloc();
      },
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            wantsDaily: true,
            osPermission: 'allowed',
            preferredHour: 9,
            preferredMinute: 0,
          ),
      act:
          (bloc) => bloc.add(
            const ConnectionSettingsTimeChanged(hour: 7, minute: 15),
          ),
      expect:
          () => [
            ConnectionSettingsState.initial().copyWith(
              wantsDaily: true,
              osPermission: 'allowed',
              preferredHour: 9,
              preferredMinute: 0,
              isSavingTime: true,
              action: ConnectionSettingsAction.none,
              actionMessage: null,
            ),
            ConnectionSettingsState.initial().copyWith(
              wantsDaily: true,
              osPermission: 'allowed',
              preferredHour: 7,
              preferredMinute: 15,
              isSavingTime: false,
            ),
          ],
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'emits error when fetch preferences fails on start',
      build: () {
        when(
          () => notificationsRepository.fetchPreferences(
            timezone: any(named: 'timezone'),
            locale: any(named: 'locale'),
            osPermission: any(named: 'osPermission'),
            deviceToken: any(named: 'deviceToken'),
            platform: any(named: 'platform'),
          ),
        ).thenThrow(Exception('Network error'));
        return buildBloc();
      },
      act:
          (bloc) => bloc.add(
            const ConnectionSettingsStarted(
              locale: 'en',
              timezone: 'UTC',
              platform: 'ios',
              deviceToken: 'token-1',
            ),
          ),
      expect:
          () => [
            ConnectionSettingsState.initial().copyWith(
              isLoading: true,
              locale: 'en',
              timezone: 'UTC',
              platform: 'ios',
              deviceToken: 'token-1',
              action: ConnectionSettingsAction.none,
              actionMessage: null,
            ),
            isA<ConnectionSettingsState>()
                .having((s) => s.isLoading, 'isLoading', false)
                .having(
                  (s) => s.action,
                  'action',
                  ConnectionSettingsAction.showError,
                )
                .having(
                  (s) => s.actionMessage,
                  'message',
                  contains('Network error'),
                ),
          ],
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'disables notifications successfully',
      build: () {
        when(
          () => notificationsRepository.updatePreferences(
            wantsDaily: any(named: 'wantsDaily'),
            preferredHour: any(named: 'preferredHour'),
            preferredMinute: any(named: 'preferredMinute'),
          ),
        ).thenAnswer(
          (_) async => const NotificationPreferences(
            wantsDaily: false,
            preferredHour: 9,
            preferredMinute: 0,
            osPermission: 'allowed',
          ),
        );
        return buildBloc();
      },
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            wantsDaily: true,
            osPermission: 'allowed',
            preferredHour: 9,
            preferredMinute: 0,
          ),
      act:
          (bloc) =>
              bloc.add(const ConnectionSettingsToggleRequested(enabled: false)),
      expect:
          () => [
            ConnectionSettingsState.initial().copyWith(
              wantsDaily: true,
              osPermission: 'allowed',
              preferredHour: 9,
              preferredMinute: 0,
              isSavingToggle: true,
              action: ConnectionSettingsAction.none,
              actionMessage: null,
            ),
            ConnectionSettingsState.initial().copyWith(
              wantsDaily: false,
              osPermission: 'allowed',
              preferredHour: 9,
              preferredMinute: 0,
              isSavingToggle: false,
              pendingEnableAfterSettings: false,
            ),
          ],
      verify: (_) {
        verify(
          () => notificationsRepository.updatePreferences(
            wantsDaily: false,
            preferredHour: 9,
            preferredMinute: 0,
          ),
        ).called(1);
      },
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'emits error when disabling notifications fails',
      build: () {
        when(
          () => notificationsRepository.updatePreferences(
            wantsDaily: any(named: 'wantsDaily'),
            preferredHour: any(named: 'preferredHour'),
            preferredMinute: any(named: 'preferredMinute'),
          ),
        ).thenThrow(Exception('Update failed'));
        return buildBloc();
      },
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            wantsDaily: true,
            osPermission: 'allowed',
          ),
      act:
          (bloc) =>
              bloc.add(const ConnectionSettingsToggleRequested(enabled: false)),
      expect:
          () => [
            isA<ConnectionSettingsState>().having(
              (s) => s.isSavingToggle,
              'isSavingToggle',
              true,
            ),
            isA<ConnectionSettingsState>()
                .having((s) => s.isSavingToggle, 'isSavingToggle', false)
                .having(
                  (s) => s.action,
                  'action',
                  ConnectionSettingsAction.showError,
                )
                .having(
                  (s) => s.actionMessage,
                  'message',
                  contains('Update failed'),
                ),
          ],
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'emits permissionBlocked when permission is not permanently denied',
      build: () {
        when(
          () => permissionService.requestAndSync(
            wantsDaily: any(named: 'wantsDaily'),
            preferredHour: any(named: 'preferredHour'),
            preferredMinute: any(named: 'preferredMinute'),
            timezone: any(named: 'timezone'),
            locale: any(named: 'locale'),
            deviceToken: any(named: 'deviceToken'),
            platform: any(named: 'platform'),
          ),
        ).thenThrow(NotificationPermissionException(permanentlyDenied: false));
        return buildBloc();
      },
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            timezone: 'UTC',
            locale: 'en',
            platform: 'ios',
            preferredHour: 9,
            preferredMinute: 0,
          ),
      act:
          (bloc) =>
              bloc.add(const ConnectionSettingsToggleRequested(enabled: true)),
      expect:
          () => [
            isA<ConnectionSettingsState>().having(
              (s) => s.isSavingToggle,
              'isSavingToggle',
              true,
            ),
            isA<ConnectionSettingsState>()
                .having((s) => s.wantsDaily, 'wantsDaily', false)
                .having((s) => s.osPermission, 'osPermission', 'unknown')
                .having((s) => s.isSavingToggle, 'isSavingToggle', false)
                .having(
                  (s) => s.pendingEnableAfterSettings,
                  'pendingEnableAfterSettings',
                  false,
                )
                .having(
                  (s) => s.action,
                  'action',
                  ConnectionSettingsAction.permissionBlocked,
                ),
          ],
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'emits error when enabling notifications throws generic error',
      build: () {
        when(
          () => permissionService.requestAndSync(
            wantsDaily: any(named: 'wantsDaily'),
            preferredHour: any(named: 'preferredHour'),
            preferredMinute: any(named: 'preferredMinute'),
            timezone: any(named: 'timezone'),
            locale: any(named: 'locale'),
            deviceToken: any(named: 'deviceToken'),
            platform: any(named: 'platform'),
          ),
        ).thenThrow(Exception('Sync failed'));
        return buildBloc();
      },
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            timezone: 'UTC',
            locale: 'en',
            platform: 'ios',
          ),
      act:
          (bloc) =>
              bloc.add(const ConnectionSettingsToggleRequested(enabled: true)),
      expect:
          () => [
            isA<ConnectionSettingsState>().having(
              (s) => s.isSavingToggle,
              'isSavingToggle',
              true,
            ),
            isA<ConnectionSettingsState>()
                .having((s) => s.isSavingToggle, 'isSavingToggle', false)
                .having(
                  (s) => s.action,
                  'action',
                  ConnectionSettingsAction.showError,
                ),
          ],
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'emits error when time change fails',
      build: () {
        when(
          () => notificationsRepository.updatePreferences(
            wantsDaily: any(named: 'wantsDaily'),
            preferredHour: any(named: 'preferredHour'),
            preferredMinute: any(named: 'preferredMinute'),
          ),
        ).thenThrow(Exception('Time update failed'));
        return buildBloc();
      },
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            wantsDaily: true,
            osPermission: 'allowed',
          ),
      act:
          (bloc) => bloc.add(
            const ConnectionSettingsTimeChanged(hour: 8, minute: 30),
          ),
      expect:
          () => [
            isA<ConnectionSettingsState>().having(
              (s) => s.isSavingTime,
              'isSavingTime',
              true,
            ),
            isA<ConnectionSettingsState>()
                .having((s) => s.isSavingTime, 'isSavingTime', false)
                .having(
                  (s) => s.action,
                  'action',
                  ConnectionSettingsAction.showError,
                )
                .having(
                  (s) => s.actionMessage,
                  'message',
                  contains('Time update failed'),
                ),
          ],
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'clears action when action is not already none',
      build: buildBloc,
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            action: ConnectionSettingsAction.showError,
            actionMessage: 'Some error',
          ),
      act: (bloc) => bloc.add(const ConnectionSettingsActionCleared()),
      expect:
          () => [
            ConnectionSettingsState.initial().copyWith(
              action: ConnectionSettingsAction.none,
              actionMessage: null,
            ),
          ],
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'does not emit when action is already none',
      build: buildBloc,
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            action: ConnectionSettingsAction.none,
            actionMessage: null,
          ),
      act: (bloc) => bloc.add(const ConnectionSettingsActionCleared()),
      expect: () => <ConnectionSettingsState>[],
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'permission recheck only updates osPermission when not pending enable',
      build: buildBloc,
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            pendingEnableAfterSettings: false,
            osPermission: 'blocked',
          ),
      act: (bloc) => bloc.add(const ConnectionSettingsPermissionRechecked()),
      expect:
          () => [
            isA<ConnectionSettingsState>()
                .having(
                  (s) => s.pendingEnableAfterSettings,
                  'pendingEnableAfterSettings',
                  false,
                )
                .having((s) => s.osPermission, 'osPermission', 'allowed'),
          ],
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'permission recheck syncs preferences when pending and allowed',
      build: () {
        when(
          () => notificationsRepository.syncPreferences(
            wantsDaily: any(named: 'wantsDaily'),
            preferredHour: any(named: 'preferredHour'),
            preferredMinute: any(named: 'preferredMinute'),
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
            preferredMinute: 0,
            osPermission: 'allowed',
          ),
        );
        return buildBloc();
      },
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            pendingEnableAfterSettings: true,
            osPermission: 'blocked',
            timezone: 'UTC',
            locale: 'en',
            platform: 'ios',
          ),
      act: (bloc) => bloc.add(const ConnectionSettingsPermissionRechecked()),
      expect:
          () => [
            isA<ConnectionSettingsState>().having(
              (s) => s.isSavingToggle,
              'isSavingToggle',
              true,
            ),
            isA<ConnectionSettingsState>()
                .having((s) => s.wantsDaily, 'wantsDaily', true)
                .having((s) => s.osPermission, 'osPermission', 'allowed')
                .having((s) => s.isSavingToggle, 'isSavingToggle', false)
                .having(
                  (s) => s.pendingEnableAfterSettings,
                  'pendingEnableAfterSettings',
                  false,
                ),
          ],
      verify: (_) {
        verify(
          () => notificationsRepository.syncPreferences(
            wantsDaily: true,
            preferredHour: 9,
            preferredMinute: 0,
            timezone: 'UTC',
            locale: 'en',
            osPermission: 'allowed',
            deviceToken: null,
            platform: 'ios',
          ),
        ).called(1);
      },
    );

    blocTest<ConnectionSettingsBloc, ConnectionSettingsState>(
      'permission recheck emits error when sync fails',
      build: () {
        when(
          () => notificationsRepository.syncPreferences(
            wantsDaily: any(named: 'wantsDaily'),
            preferredHour: any(named: 'preferredHour'),
            preferredMinute: any(named: 'preferredMinute'),
            timezone: any(named: 'timezone'),
            locale: any(named: 'locale'),
            osPermission: any(named: 'osPermission'),
            deviceToken: any(named: 'deviceToken'),
            platform: any(named: 'platform'),
          ),
        ).thenThrow(Exception('Sync after recheck failed'));
        return buildBloc();
      },
      seed:
          () => ConnectionSettingsState.initial().copyWith(
            pendingEnableAfterSettings: true,
            osPermission: 'blocked',
            timezone: 'UTC',
            locale: 'en',
            platform: 'ios',
          ),
      act: (bloc) => bloc.add(const ConnectionSettingsPermissionRechecked()),
      expect:
          () => [
            isA<ConnectionSettingsState>().having(
              (s) => s.isSavingToggle,
              'isSavingToggle',
              true,
            ),
            isA<ConnectionSettingsState>()
                .having((s) => s.isSavingToggle, 'isSavingToggle', false)
                .having(
                  (s) => s.pendingEnableAfterSettings,
                  'pendingEnableAfterSettings',
                  false,
                )
                .having(
                  (s) => s.action,
                  'action',
                  ConnectionSettingsAction.showError,
                )
                .having(
                  (s) => s.actionMessage,
                  'message',
                  contains('Sync after recheck failed'),
                ),
          ],
    );
  });

  group('ConnectionSettingsState', () {
    test('initial state has correct defaults', () {
      final state = ConnectionSettingsState.initial();
      expect(state.isLoading, isTrue);
      expect(state.isSavingToggle, isFalse);
      expect(state.isSavingTime, isFalse);
      expect(state.wantsDaily, isFalse);
      expect(state.preferredHour, 9);
      expect(state.preferredMinute, 0);
      expect(state.osPermission, 'unknown');
      expect(state.pendingEnableAfterSettings, isFalse);
      expect(state.action, ConnectionSettingsAction.none);
      expect(state.actionMessage, isNull);
    });

    test('canEditTime returns true when wantsDaily and allowed', () {
      final state = ConnectionSettingsState.initial().copyWith(
        wantsDaily: true,
        osPermission: 'allowed',
      );
      expect(state.canEditTime, isTrue);
    });

    test('canEditTime returns false when not wantsDaily', () {
      final state = ConnectionSettingsState.initial().copyWith(
        wantsDaily: false,
        osPermission: 'allowed',
      );
      expect(state.canEditTime, isFalse);
    });

    test('canEditTime returns false when not allowed', () {
      final state = ConnectionSettingsState.initial().copyWith(
        wantsDaily: true,
        osPermission: 'blocked',
      );
      expect(state.canEditTime, isFalse);
    });

    test('copyWith preserves deviceToken when not specified', () {
      final state = ConnectionSettingsState.initial().copyWith(
        deviceToken: 'my-token',
      );
      final copied = state.copyWith(wantsDaily: true);
      expect(copied.deviceToken, 'my-token');
    });

    test('copyWith can set deviceToken to null', () {
      final state = ConnectionSettingsState.initial().copyWith(
        deviceToken: 'my-token',
      );
      final copied = state.copyWith(deviceToken: null);
      expect(copied.deviceToken, isNull);
    });

    test('copyWith preserves actionMessage when not specified', () {
      final state = ConnectionSettingsState.initial().copyWith(
        actionMessage: 'Error message',
      );
      final copied = state.copyWith(wantsDaily: true);
      expect(copied.actionMessage, 'Error message');
    });

    test('copyWith can set actionMessage to null', () {
      final state = ConnectionSettingsState.initial().copyWith(
        actionMessage: 'Error message',
      );
      final copied = state.copyWith(actionMessage: null);
      expect(copied.actionMessage, isNull);
    });
  });
}
