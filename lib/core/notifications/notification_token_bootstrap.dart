import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/notifications/notifications.dart';
import '../logging/logger.dart';

/// Snapshot of the values needed to sync a device token.
class NotificationSyncPayload {
  const NotificationSyncPayload({
    required this.wantsDaily,
    required this.preferredHour,
    required this.preferredMinute,
    required this.timezone,
    required this.locale,
    required this.osPermission,
    this.platform,
  });

  final bool wantsDaily;
  final int preferredHour;
  final int preferredMinute;
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
    required Logger logger,
  }) : _notificationsRepository = notificationsRepository,
       _syncProvider = syncProvider,
       _logger = logger;

  final NotificationsRepository _notificationsRepository;
  final NotificationSyncProvider _syncProvider;
  final Logger _logger;

  StreamSubscription<String>? _tokenSub;

  Future<void> start() async {
    // Register for token refreshes (rotation happens periodically).
    _tokenSub = FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) => _syncTokenSafe(token, source: 'refresh'),
    );

    // Try to push the current token once at startup if available.
    await _getAndSyncToken(source: 'initial');
  }

  Future<void> _getAndSyncToken({required String source}) async {
    final token = await _fetchTokenWithRetry(source);
    if (token == null || token.isEmpty) return;
    await _syncTokenSafe(token, source: source);
  }

  Future<void> _syncTokenSafe(String token, {required String source}) async {
    try {
      await _syncToken(token);
    } catch (error, stackTrace) {
      _logger.warn(
        'FCM token sync failed ($source): $error',
        tag: 'Notifications',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _syncToken(String token) async {
    final payload = await _syncProvider();
    if (payload == null) return;

    await _notificationsRepository.syncPreferences(
      wantsDaily: payload.wantsDaily,
      preferredHour: payload.preferredHour,
      preferredMinute: payload.preferredMinute,
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

  bool _isTooManyRegistrations(String message) =>
      message.contains('TOO_MANY_REGISTRATIONS');

  Future<String?> _fetchTokenWithRetry(String source) async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (error, stackTrace) {
      final message = error.toString();
      if (_isTooManyRegistrations(message)) {
        return _retryAfterTooManyRegistrations(source);
      }
      _logger.warn(
        'FCM getToken failed ($source): $error',
        tag: 'Notifications',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<String?> _retryAfterTooManyRegistrations(String source) async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      return await FirebaseMessaging.instance.getToken();
    } catch (retryError, retryStack) {
      _logger.warn(
        'FCM token retry after TOO_MANY_REGISTRATIONS failed: $retryError',
        tag: 'Notifications',
        error: retryError,
        stackTrace: retryStack,
      );
      return null;
    }
  }
}
