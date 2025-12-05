/// Boundary for daily notification preferences and device tokens.
abstract class NotificationsRepository {
  /// Upserts the user's daily notification preferences and the current device token.
  ///
  /// [osPermission] is a backend-friendly string: allowed | blocked | unknown.
  /// [preferredHour] is local hour (24h). Phase 1 uses 9.
  Future<void> syncPreferences({
    required bool wantsDaily,
    required int preferredHour,
    required String timezone,
    required String locale,
    required String osPermission,
    String? deviceToken,
    String? platform,
  });

  /// Marks a device token as revoked (e.g., on logout/uninstall).
  Future<void> revokeDeviceToken(String deviceToken);
}
