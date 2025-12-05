import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../data/repositories/notifications_repository.dart';

/// Snapshot of the values needed to sync a device token.
class NotificationSyncPayload {
  const NotificationSyncPayload({
    required this.wantsDaily,
    required this.preferredHour,
    required this.timezone,
    required this.locale,
    required this.osPermission,
    this.platform,
  });

  final bool wantsDaily;
  final int preferredHour;
  final String timezone;
  final String locale;
  final String osPermission; // allowed | blocked | unknown
  final String? platform;
}

typedef NotificationSyncProvider = Future<NotificationSyncPayload?> Function();

/// Listens for token refresh events and syncs them to Supabase with cached prefs.
class NotificationTokenBootstrap {
  NotificationTokenBootstrap({
    required NotificationsRepository notificationsRepository,
    required NotificationSyncProvider syncProvider,
  })  : _notificationsRepository = notificationsRepository,
        _syncProvider = syncProvider;

  final NotificationsRepository _notificationsRepository;
  final NotificationSyncProvider _syncProvider;

  StreamSubscription<String>? _tokenSub;

  Future<void> start() async {
    // Register for token refreshes (rotation happens periodically).
    _tokenSub = FirebaseMessaging.instance.onTokenRefresh.listen(_syncToken);

    // Try to push the current token once at startup if available.
    final initialToken = await FirebaseMessaging.instance.getToken();
    if (initialToken != null && initialToken.isNotEmpty) {
      await _syncToken(initialToken);
    }
  }

  Future<void> _syncToken(String token) async {
    final payload = await _syncProvider();
    if (payload == null) return;

    await _notificationsRepository.syncPreferences(
      wantsDaily: payload.wantsDaily,
      preferredHour: payload.preferredHour,
      timezone: payload.timezone,
      locale: payload.locale,
      osPermission: payload.osPermission,
      deviceToken: token,
      platform: payload.platform,
    );
  }

  Future<void> dispose() async {
    await _tokenSub?.cancel();
  }
}
