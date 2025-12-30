import 'package:firebase_messaging/firebase_messaging.dart';

import 'enums/permission_status.dart';

NotificationPermissionStatus mapAuthorizationStatusToPermissionStatus(
  AuthorizationStatus status,
) {
  switch (status) {
    case AuthorizationStatus.authorized:
    case AuthorizationStatus.provisional:
      return NotificationPermissionStatus.allowed;
    case AuthorizationStatus.denied:
      return NotificationPermissionStatus.permanentlyDenied;
    case AuthorizationStatus.notDetermined:
    default:
      return NotificationPermissionStatus.denied;
  }
}

String mapAuthorizationStatusToOsPermission(AuthorizationStatus status) {
  switch (status) {
    case AuthorizationStatus.authorized:
    case AuthorizationStatus.provisional:
      return 'allowed';
    case AuthorizationStatus.denied:
      return 'blocked';
    case AuthorizationStatus.notDetermined:
    default:
      return 'unknown';
  }
}
