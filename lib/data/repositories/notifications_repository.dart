import '../../core/notifications/notification_preferences.dart';

/// Boundary for daily notification preferences and device tokens.
abstract class NotificationsRepository {
  /// Upserts the user's daily notification preferences and the current device token.
  ///
  /// [osPermission] is a backend-friendly string: allowed | blocked | unknown.
  /// [preferredHour] is local hour (24h). Phase 1 uses 9.
  Future<NotificationPreferences> syncPreferences({
    required bool wantsDaily,
    required int preferredHour,
    required String timezone,
    required String locale,
    required String osPermission,
    String? deviceToken,
    String? platform,
  });

  /// Loads preferences (and refreshes timezone/locale/os_permission) via RPC.
  Future<NotificationPreferences> fetchPreferences({
    required String timezone,
    required String locale,
    required String osPermission,
    String? deviceToken,
    String? platform,
  });

  /// Updates wants_daily/preferred_hour explicitly via RPC.
  Future<NotificationPreferences> updatePreferences({
    required bool wantsDaily,
    required int preferredHour,
  });

  /// Marks a device token as revoked (e.g., on logout/uninstall).
  Future<void> revokeDeviceToken(String deviceToken);
}
