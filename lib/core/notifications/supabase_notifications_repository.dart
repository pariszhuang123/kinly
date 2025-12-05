import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/notifications_repository.dart';
import 'notification_sync_state.dart';
import 'notification_token_bootstrap.dart';

/// Supabase implementation for daily notification preferences + device tokens.
class SupabaseNotificationsRepository implements NotificationsRepository {
  SupabaseNotificationsRepository({
    SupabaseClient? client,
    NotificationSyncState? syncState,
  })  : _client = client ?? Supabase.instance.client,
        _syncState = syncState;

  final SupabaseClient _client;
  final NotificationSyncState? _syncState;

  @override
  Future<void> syncPreferences({
    required bool wantsDaily,
    required int preferredHour,
    required String timezone,
    required String locale,
    required String osPermission,
    String? deviceToken,
    String? platform,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException("Missing authenticated user for notifications sync.");
    }

    final nowIso = DateTime.now().toUtc().toIso8601String();

    final prefs = {
      'user_id': userId,
      'wants_daily': wantsDaily,
      'preferred_hour': preferredHour,
      'timezone': timezone,
      'locale': locale,
      'os_permission': osPermission,
      'last_os_sync_at': nowIso,
      'updated_at': nowIso,
    };

    final tokenRow = {
      'user_id': userId,
      'platform': platform,
      'status': 'active',
      'last_seen_at': nowIso,
      'updated_at': nowIso,
    };

    // Upsert preference and token separately to keep failure modes isolated.
    await _client.from('notification_preferences').upsert(prefs, onConflict: 'user_id');
    if (deviceToken != null && deviceToken.isNotEmpty) {
      await _client.from('device_tokens').upsert(
        {
          ...tokenRow,
          'token': deviceToken,
        },
        onConflict: 'token',
      );
    }

    _syncState?.setPayload(
      NotificationSyncPayload(
        wantsDaily: wantsDaily,
        preferredHour: preferredHour,
        timezone: timezone,
        locale: locale,
        osPermission: osPermission,
        platform: platform,
      ),
    );
  }

  @override
  Future<void> revokeDeviceToken(String deviceToken) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException("Missing authenticated user for token revoke.");
    }

    final nowIso = DateTime.now().toUtc().toIso8601String();

    await _client
        .from('device_tokens')
        .update({'status': 'revoked', 'updated_at': nowIso})
        .eq('token', deviceToken)
        .eq('user_id', userId);
  }
}
