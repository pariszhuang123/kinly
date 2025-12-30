import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import 'authorization_status_mapper.dart';

import '../../data/repositories/notifications_repository.dart';
import 'enums/permission_status.dart';

class NotificationPermissionException implements Exception {
  NotificationPermissionException({required this.permanentlyDenied});
  final bool permanentlyDenied;
}

/// Requests notification permission and syncs preference/token with Supabase.
class NotificationPermissionService {
  NotificationPermissionService({
    required NotificationsRepository notificationsRepository,
  }) : _notificationsRepository = notificationsRepository;

  final NotificationsRepository _notificationsRepository;

  Future<void> requestAndSync({
    required bool wantsDaily,
    required int preferredHour,
    required int preferredMinute,
    required String timezone,
    required String locale,
    String? deviceToken,
    String? platform,
  }) async {
    final status = await _ensureNotificationPermission();
    final granted = status == NotificationPermissionStatus.allowed;

    final osPermission =
        status == NotificationPermissionStatus.permanentlyDenied
            ? 'blocked'
            : granted
            ? 'allowed'
            : 'unknown';

    await _notificationsRepository.syncPreferences(
      wantsDaily: granted ? wantsDaily : false,
      preferredHour: preferredHour,
      preferredMinute: preferredMinute,
      timezone: timezone,
      locale: locale,
      osPermission: osPermission,
      deviceToken: deviceToken,
      platform: platform,
    );

    if (!granted) {
      final isPermanent =
          status == NotificationPermissionStatus.permanentlyDenied;
      throw NotificationPermissionException(permanentlyDenied: isPermanent);
    }
  }

  Future<NotificationPermissionStatus> _ensureNotificationPermission() async {
    if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        provisional: false,
      );
      return mapAuthorizationStatusToPermissionStatus(
        settings.authorizationStatus,
      );
    }

    final status = await ph.Permission.notification.status;

    if (status.isGranted) {
      return NotificationPermissionStatus.allowed;
    }

    if (status.isPermanentlyDenied) {
      return NotificationPermissionStatus.permanentlyDenied;
    }

    final requested = await ph.Permission.notification.request();

    if (requested.isGranted) {
      return NotificationPermissionStatus.allowed;
    }

    if (requested.isPermanentlyDenied) {
      return NotificationPermissionStatus.permanentlyDenied;
    }

    return NotificationPermissionStatus.denied;
  }
}
