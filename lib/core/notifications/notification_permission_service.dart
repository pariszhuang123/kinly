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
    final granted = await _ensureNotificationPermission();
    final osPermission = granted ? 'allowed' : 'blocked';

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
      throw NotificationPermissionException(permanentlyDenied: false);
    }
  }

  Future<bool> _ensureNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      throw NotificationPermissionException(permanentlyDenied: true);
    }
    final requested = await Permission.notification.request();
    if (requested.isGranted) return true;
    if (requested.isPermanentlyDenied) {
      throw NotificationPermissionException(permanentlyDenied: true);
    }
    return false;
  }
}
