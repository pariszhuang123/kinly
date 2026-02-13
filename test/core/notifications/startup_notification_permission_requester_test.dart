import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/notifications/startup_notification_permission_requester.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  group('StartupNotificationPermissionRequester', () {
    test('requests Android permission and reads FCM token when granted', () async {
      var androidRequests = 0;
      var fcmReads = 0;

      final requester = StartupNotificationPermissionRequester(
        logger: const DebugLogger(),
        isIOS: () => false,
        isAndroid: () => true,
        requestAndroidPermission: () async {
          androidRequests += 1;
          return PermissionStatus.granted;
        },
        readFcmToken: () async {
          fcmReads += 1;
          return 'fcm-token';
        },
      );

      final requested = await requester.requestIfSupported();

      expect(requested, isTrue);
      expect(androidRequests, 1);
      expect(fcmReads, 1);
    });

    test('requests Android permission and skips FCM token when denied', () async {
      var androidRequests = 0;
      var fcmReads = 0;

      final requester = StartupNotificationPermissionRequester(
        logger: const DebugLogger(),
        isIOS: () => false,
        isAndroid: () => true,
        requestAndroidPermission: () async {
          androidRequests += 1;
          return PermissionStatus.denied;
        },
        readFcmToken: () async {
          fcmReads += 1;
          return 'fcm-token';
        },
      );

      final requested = await requester.requestIfSupported();

      expect(requested, isTrue);
      expect(androidRequests, 1);
      expect(fcmReads, 0);
    });

    test('returns false when platform does not support runtime prompt', () async {
      var androidRequests = 0;
      var iosRequests = 0;

      final requester = StartupNotificationPermissionRequester(
        logger: const DebugLogger(),
        isIOS: () => false,
        isAndroid: () => false,
        requestIosPermission: () async {
          iosRequests += 1;
          return AuthorizationStatus.notDetermined;
        },
        requestAndroidPermission: () async {
          androidRequests += 1;
          return PermissionStatus.denied;
        },
      );

      final requested = await requester.requestIfSupported();

      expect(requested, isFalse);
      expect(iosRequests, 0);
      expect(androidRequests, 0);
    });

    test(
      're-consent flow transitions from denied to granted and reads token',
      () async {
        var fcmReads = 0;
        var requestCount = 0;
        final permissionSequence = <PermissionStatus>[
          PermissionStatus.denied,
          PermissionStatus.granted,
        ];

        final requester = StartupNotificationPermissionRequester(
          logger: const DebugLogger(),
          isIOS: () => false,
          isAndroid: () => true,
          requestAndroidPermission: () async {
            final status = permissionSequence[requestCount];
            requestCount += 1;
            return status;
          },
          readFcmToken: () async {
            fcmReads += 1;
            return 'fcm-token';
          },
        );

        final firstRequested = await requester.requestIfSupported();
        final secondRequested = await requester.requestIfSupported();

        expect(firstRequested, isTrue);
        expect(secondRequested, isTrue);
        expect(requestCount, 2);
        expect(fcmReads, 1);
      },
    );
  });
}
