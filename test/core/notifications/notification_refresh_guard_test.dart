import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/notifications/notification_refresh_guard.dart';

void main() {
  group('shouldSkipNotificationPrefsRefresh', () {
    test('returns true when widget is not mounted', () {
      final shouldSkip = shouldSkipNotificationPrefsRefresh(
        mounted: false,
        lifecycleState: AppLifecycleState.resumed,
      );

      expect(shouldSkip, isTrue);
    });

    test('returns false when resumed and mounted', () {
      final shouldSkip = shouldSkipNotificationPrefsRefresh(
        mounted: true,
        lifecycleState: AppLifecycleState.resumed,
      );

      expect(shouldSkip, isFalse);
    });

    test('returns true when inactive', () {
      final shouldSkip = shouldSkipNotificationPrefsRefresh(
        mounted: true,
        lifecycleState: AppLifecycleState.inactive,
      );

      expect(shouldSkip, isTrue);
    });

    test('returns true when hidden', () {
      final shouldSkip = shouldSkipNotificationPrefsRefresh(
        mounted: true,
        lifecycleState: AppLifecycleState.hidden,
      );

      expect(shouldSkip, isTrue);
    });

    test('returns true when paused', () {
      final shouldSkip = shouldSkipNotificationPrefsRefresh(
        mounted: true,
        lifecycleState: AppLifecycleState.paused,
      );

      expect(shouldSkip, isTrue);
    });

    test('returns true when detached', () {
      final shouldSkip = shouldSkipNotificationPrefsRefresh(
        mounted: true,
        lifecycleState: AppLifecycleState.detached,
      );

      expect(shouldSkip, isTrue);
    });

    test('returns false when lifecycle state is unknown', () {
      final shouldSkip = shouldSkipNotificationPrefsRefresh(
        mounted: true,
        lifecycleState: null,
      );

      expect(shouldSkip, isFalse);
    });
  });

  group('isRetryableNotificationPrefsRefreshError', () {
    test('matches bad file descriptor client exception', () {
      const error = 'ClientException: Bad file descriptor';
      expect(
        isRetryableNotificationPrefsRefreshError(Exception(error)),
        isTrue,
      );
    });

    test('does not match non-client exceptions', () {
      expect(
        isRetryableNotificationPrefsRefreshError(
          Exception('SocketException: Connection reset by peer'),
        ),
        isFalse,
      );
    });

    test('does not match unrelated client exceptions', () {
      expect(
        isRetryableNotificationPrefsRefreshError(
          Exception('ClientException: Connection closed before full header'),
        ),
        isFalse,
      );
    });

    test('matches regardless of case', () {
      expect(
        isRetryableNotificationPrefsRefreshError(
          Exception('clientexception: BAD FILE DESCRIPTOR'),
        ),
        isTrue,
      );
    });
  });
}
