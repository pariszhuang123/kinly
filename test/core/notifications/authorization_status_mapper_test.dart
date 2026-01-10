import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/notifications/authorization_status_mapper.dart';
import 'package:kinly/core/notifications/enums/permission_status.dart';

void main() {
  group('mapAuthorizationStatusToPermissionStatus', () {
    test('maps authorized to allowed', () {
      expect(
        mapAuthorizationStatusToPermissionStatus(
          AuthorizationStatus.authorized,
        ),
        NotificationPermissionStatus.allowed,
      );
    });

    test('maps provisional to allowed', () {
      expect(
        mapAuthorizationStatusToPermissionStatus(
          AuthorizationStatus.provisional,
        ),
        NotificationPermissionStatus.allowed,
      );
    });

    test('maps denied to permanentlyDenied', () {
      expect(
        mapAuthorizationStatusToPermissionStatus(AuthorizationStatus.denied),
        NotificationPermissionStatus.permanentlyDenied,
      );
    });

    test('maps notDetermined to denied', () {
      expect(
        mapAuthorizationStatusToPermissionStatus(
          AuthorizationStatus.notDetermined,
        ),
        NotificationPermissionStatus.denied,
      );
    });
  });

  group('mapAuthorizationStatusToOsPermission', () {
    test('authorized -> allowed', () {
      expect(
        mapAuthorizationStatusToOsPermission(AuthorizationStatus.authorized),
        'allowed',
      );
    });

    test('provisional -> allowed', () {
      expect(
        mapAuthorizationStatusToOsPermission(AuthorizationStatus.provisional),
        'allowed',
      );
    });

    test('denied -> blocked', () {
      expect(
        mapAuthorizationStatusToOsPermission(AuthorizationStatus.denied),
        'blocked',
      );
    });

    test('notDetermined -> unknown', () {
      expect(
        mapAuthorizationStatusToOsPermission(AuthorizationStatus.notDetermined),
        'unknown',
      );
    });
  });
}
