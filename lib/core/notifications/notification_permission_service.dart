import 'package:permission_handler/permission_handler.dart';

import '../../data/repositories/notifications_repository.dart';

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

  /// Requests OS permission. If granted, syncs opt-in state + token (when provided).
  /// If denied permanently, throws [NotificationPermissionException].
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
    final granted = status == _PermissionStatus.allowed;
    final osPermission =
        status == _PermissionStatus.permanentlyDenied ? 'blocked' : granted ? 'allowed' : 'unknown';

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
      final isPermanent = status == _PermissionStatus.permanentlyDenied;
      throw NotificationPermissionException(permanentlyDenied: isPermanent);
    }
  }

  Future<_PermissionStatus> _ensureNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return _PermissionStatus.allowed;
    if (status.isPermanentlyDenied) {
      return _PermissionStatus.permanentlyDenied;
    }
    final requested = await Permission.notification.request();
    if (requested.isGranted) return _PermissionStatus.allowed;
    if (requested.isPermanentlyDenied) {
      return _PermissionStatus.permanentlyDenied;
    }
    return _PermissionStatus.denied;
  }
}

enum _PermissionStatus { allowed, denied, permanentlyDenied }
