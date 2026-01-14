import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/features/profile_settings/connection/bloc/connection_settings_bloc.dart';

void main() {
  group('ConnectionSettingsEvent props equality', () {
    test('ConnectionSettingsStarted equality with all fields', () {
      const e1 = ConnectionSettingsStarted(
        locale: 'en_US',
        timezone: 'America/New_York',
        platform: 'android',
        deviceToken: 'token-123',
      );
      const e2 = ConnectionSettingsStarted(
        locale: 'en_US',
        timezone: 'America/New_York',
        platform: 'android',
        deviceToken: 'token-123',
      );
      const e3 = ConnectionSettingsStarted(
        locale: 'en_GB',
        timezone: 'America/New_York',
        platform: 'android',
        deviceToken: 'token-123',
      );
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(
        e1.props,
        equals(['en_US', 'America/New_York', 'android', 'token-123']),
      );
    });

    test('ConnectionSettingsStarted equality with null deviceToken', () {
      const e1 = ConnectionSettingsStarted(
        locale: 'en_US',
        timezone: 'UTC',
        platform: 'ios',
      );
      const e2 = ConnectionSettingsStarted(
        locale: 'en_US',
        timezone: 'UTC',
        platform: 'ios',
        deviceToken: null,
      );
      const e3 = ConnectionSettingsStarted(
        locale: 'en_US',
        timezone: 'UTC',
        platform: 'ios',
        deviceToken: 'token',
      );
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['en_US', 'UTC', 'ios', null]));
    });

    test('ConnectionSettingsStarted different timezone', () {
      const e1 = ConnectionSettingsStarted(
        locale: 'en_US',
        timezone: 'America/New_York',
        platform: 'android',
      );
      const e2 = ConnectionSettingsStarted(
        locale: 'en_US',
        timezone: 'Europe/London',
        platform: 'android',
      );
      expect(e1, isNot(equals(e2)));
    });

    test('ConnectionSettingsStarted different platform', () {
      const e1 = ConnectionSettingsStarted(
        locale: 'en_US',
        timezone: 'UTC',
        platform: 'android',
      );
      const e2 = ConnectionSettingsStarted(
        locale: 'en_US',
        timezone: 'UTC',
        platform: 'ios',
      );
      expect(e1, isNot(equals(e2)));
    });

    test('ConnectionSettingsToggleRequested equality', () {
      const e1 = ConnectionSettingsToggleRequested(enabled: true);
      const e2 = ConnectionSettingsToggleRequested(enabled: true);
      const e3 = ConnectionSettingsToggleRequested(enabled: false);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals([true]));
      expect(e3.props, equals([false]));
    });

    test('ConnectionSettingsTimeChanged equality', () {
      const e1 = ConnectionSettingsTimeChanged(hour: 9, minute: 30);
      const e2 = ConnectionSettingsTimeChanged(hour: 9, minute: 30);
      const e3 = ConnectionSettingsTimeChanged(hour: 10, minute: 30);
      const e4 = ConnectionSettingsTimeChanged(hour: 9, minute: 45);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1, isNot(equals(e4)));
      expect(e1.props, equals([9, 30]));
    });

    test('ConnectionSettingsTimeChanged boundary values', () {
      const midnight = ConnectionSettingsTimeChanged(hour: 0, minute: 0);
      const endOfDay = ConnectionSettingsTimeChanged(hour: 23, minute: 59);
      expect(midnight.props, equals([0, 0]));
      expect(endOfDay.props, equals([23, 59]));
      expect(midnight, isNot(equals(endOfDay)));
    });

    test('ConnectionSettingsPermissionRechecked equality', () {
      expect(
        const ConnectionSettingsPermissionRechecked(),
        equals(const ConnectionSettingsPermissionRechecked()),
      );
      expect(const ConnectionSettingsPermissionRechecked().props, isEmpty);
    });

    test('ConnectionSettingsActionCleared equality', () {
      expect(
        const ConnectionSettingsActionCleared(),
        equals(const ConnectionSettingsActionCleared()),
      );
      expect(const ConnectionSettingsActionCleared().props, isEmpty);
    });
  });

  group('ConnectionSettingsState', () {
    test('initial factory creates correct default state', () {
      final state = ConnectionSettingsState.initial();

      expect(state.isLoading, isTrue);
      expect(state.isSavingToggle, isFalse);
      expect(state.isSavingTime, isFalse);
      expect(state.wantsDaily, isFalse);
      expect(state.preferredHour, equals(9));
      expect(state.preferredMinute, equals(0));
      expect(state.osPermission, equals('unknown'));
      expect(state.locale, isEmpty);
      expect(state.timezone, isEmpty);
      expect(state.platform, isEmpty);
      expect(state.deviceToken, isNull);
      expect(state.pendingEnableAfterSettings, isFalse);
      expect(state.action, equals(ConnectionSettingsAction.none));
      expect(state.actionMessage, isNull);
    });

    group('canEditTime', () {
      test('returns true when wantsDaily and osPermission is allowed', () {
        final state = ConnectionSettingsState.initial().copyWith(
          wantsDaily: true,
          osPermission: 'allowed',
        );
        expect(state.canEditTime, isTrue);
      });

      test('returns false when wantsDaily is false', () {
        final state = ConnectionSettingsState.initial().copyWith(
          wantsDaily: false,
          osPermission: 'allowed',
        );
        expect(state.canEditTime, isFalse);
      });

      test('returns false when osPermission is not allowed', () {
        final state = ConnectionSettingsState.initial().copyWith(
          wantsDaily: true,
          osPermission: 'blocked',
        );
        expect(state.canEditTime, isFalse);
      });

      test('returns false when osPermission is unknown', () {
        final state = ConnectionSettingsState.initial().copyWith(
          wantsDaily: true,
          osPermission: 'unknown',
        );
        expect(state.canEditTime, isFalse);
      });

      test('returns false when both conditions are not met', () {
        final state = ConnectionSettingsState.initial().copyWith(
          wantsDaily: false,
          osPermission: 'blocked',
        );
        expect(state.canEditTime, isFalse);
      });
    });

    group('copyWith', () {
      test('preserves all values when no arguments provided', () {
        final original = ConnectionSettingsState.initial().copyWith(
          isLoading: false,
          isSavingToggle: true,
          isSavingTime: true,
          wantsDaily: true,
          preferredHour: 14,
          preferredMinute: 30,
          osPermission: 'allowed',
          locale: 'fr_FR',
          timezone: 'Europe/Paris',
          platform: 'ios',
          deviceToken: 'my-token',
          pendingEnableAfterSettings: true,
          action: ConnectionSettingsAction.showError,
          actionMessage: 'Some error',
        );

        final copied = original.copyWith();

        expect(copied.isLoading, equals(original.isLoading));
        expect(copied.isSavingToggle, equals(original.isSavingToggle));
        expect(copied.isSavingTime, equals(original.isSavingTime));
        expect(copied.wantsDaily, equals(original.wantsDaily));
        expect(copied.preferredHour, equals(original.preferredHour));
        expect(copied.preferredMinute, equals(original.preferredMinute));
        expect(copied.osPermission, equals(original.osPermission));
        expect(copied.locale, equals(original.locale));
        expect(copied.timezone, equals(original.timezone));
        expect(copied.platform, equals(original.platform));
        expect(copied.deviceToken, equals(original.deviceToken));
        expect(
          copied.pendingEnableAfterSettings,
          equals(original.pendingEnableAfterSettings),
        );
        expect(copied.action, equals(original.action));
        expect(copied.actionMessage, equals(original.actionMessage));
      });

      test('updates single field', () {
        final initial = ConnectionSettingsState.initial();
        final updated = initial.copyWith(isLoading: false);

        expect(updated.isLoading, isFalse);
        expect(updated.isSavingToggle, equals(initial.isSavingToggle));
        expect(updated.wantsDaily, equals(initial.wantsDaily));
      });

      test('updates multiple fields', () {
        final initial = ConnectionSettingsState.initial();
        final updated = initial.copyWith(
          isLoading: false,
          wantsDaily: true,
          preferredHour: 18,
          preferredMinute: 45,
          osPermission: 'allowed',
        );

        expect(updated.isLoading, isFalse);
        expect(updated.wantsDaily, isTrue);
        expect(updated.preferredHour, equals(18));
        expect(updated.preferredMinute, equals(45));
        expect(updated.osPermission, equals('allowed'));
      });

      test('can set deviceToken to null explicitly', () {
        final withToken = ConnectionSettingsState.initial().copyWith(
          deviceToken: 'my-token',
        );
        expect(withToken.deviceToken, equals('my-token'));

        final withoutToken = withToken.copyWith(deviceToken: null);
        expect(withoutToken.deviceToken, isNull);
      });

      test('can set actionMessage to null explicitly', () {
        final withMessage = ConnectionSettingsState.initial().copyWith(
          actionMessage: 'Error occurred',
        );
        expect(withMessage.actionMessage, equals('Error occurred'));

        final withoutMessage = withMessage.copyWith(actionMessage: null);
        expect(withoutMessage.actionMessage, isNull);
      });

      test('preserves deviceToken when not specified', () {
        final withToken = ConnectionSettingsState.initial().copyWith(
          deviceToken: 'preserved-token',
        );
        final updated = withToken.copyWith(isLoading: false);

        expect(updated.deviceToken, equals('preserved-token'));
      });

      test('preserves actionMessage when not specified', () {
        final withMessage = ConnectionSettingsState.initial().copyWith(
          actionMessage: 'preserved-message',
        );
        final updated = withMessage.copyWith(isLoading: false);

        expect(updated.actionMessage, equals('preserved-message'));
      });

      test('updates action enum correctly', () {
        final initial = ConnectionSettingsState.initial();
        expect(initial.action, equals(ConnectionSettingsAction.none));

        final showError = initial.copyWith(
          action: ConnectionSettingsAction.showError,
        );
        expect(showError.action, equals(ConnectionSettingsAction.showError));

        final openSettings = initial.copyWith(
          action: ConnectionSettingsAction.openSystemSettings,
        );
        expect(
          openSettings.action,
          equals(ConnectionSettingsAction.openSystemSettings),
        );

        final permissionBlocked = initial.copyWith(
          action: ConnectionSettingsAction.permissionBlocked,
        );
        expect(
          permissionBlocked.action,
          equals(ConnectionSettingsAction.permissionBlocked),
        );
      });
    });

    group('props equality', () {
      test('equal states have same props', () {
        final s1 = ConnectionSettingsState.initial();
        final s2 = ConnectionSettingsState.initial();
        expect(s1, equals(s2));
        expect(s1.props, equals(s2.props));
      });

      test('different states have different props', () {
        final s1 = ConnectionSettingsState.initial();
        final s2 = ConnectionSettingsState.initial().copyWith(wantsDaily: true);
        expect(s1, isNot(equals(s2)));
      });

      test('props contains all fields', () {
        final state = ConnectionSettingsState.initial();
        expect(state.props.length, equals(14));
        expect(state.props, contains(state.isLoading));
        expect(state.props, contains(state.isSavingToggle));
        expect(state.props, contains(state.isSavingTime));
        expect(state.props, contains(state.wantsDaily));
        expect(state.props, contains(state.preferredHour));
        expect(state.props, contains(state.preferredMinute));
        expect(state.props, contains(state.osPermission));
        expect(state.props, contains(state.locale));
        expect(state.props, contains(state.timezone));
        expect(state.props, contains(state.platform));
        expect(state.props, contains(state.pendingEnableAfterSettings));
        expect(state.props, contains(state.action));
      });
    });
  });

  group('ConnectionSettingsAction enum', () {
    test('has all expected values', () {
      expect(ConnectionSettingsAction.values.length, equals(4));
      expect(
        ConnectionSettingsAction.values,
        containsAll([
          ConnectionSettingsAction.none,
          ConnectionSettingsAction.showError,
          ConnectionSettingsAction.openSystemSettings,
          ConnectionSettingsAction.permissionBlocked,
        ]),
      );
    });
  });
}
