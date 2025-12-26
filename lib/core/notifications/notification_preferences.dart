class NotificationPreferences {
  const NotificationPreferences({
    required this.wantsDaily,
    required this.preferredHour,
    required this.preferredMinute,
    required this.osPermission,
  });

  final bool wantsDaily;
  final int preferredHour;
  final int preferredMinute;
  final String osPermission; // allowed | blocked | unknown

  factory NotificationPreferences.fromMap(Map<String, dynamic> data) {
    return NotificationPreferences(
      wantsDaily: data['wants_daily'] as bool? ?? false,
      preferredHour: data['preferred_hour'] as int? ?? 9,
      preferredMinute: data['preferred_minute'] as int? ?? 0,
      osPermission: data['os_permission'] as String? ?? 'unknown',
    );
  }
}
