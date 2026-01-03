import 'package:kinly/core/notifications/notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase implementation for daily notification preferences + device tokens.
class SupabaseNotificationsRepository implements NotificationsRepository {
  SupabaseNotificationsRepository({
    SupabaseClient? client,
    NotificationSyncState? syncState,
  }) : _client = client ?? Supabase.instance.client,
       _syncState = syncState;

  final SupabaseClient _client;
  final NotificationSyncState? _syncState;

  @override
  Future<NotificationPreferences> syncPreferences({
    required bool wantsDaily,
    required int preferredHour,
    required int preferredMinute,
    required String timezone,
    required String locale,
    required String osPermission,
    String? deviceToken,
    String? platform,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException(
        "Missing authenticated user for notifications sync.",
      );
    }

    final preferences = await _syncClientState(
      wantsDaily: wantsDaily,
      preferredHour: preferredHour,
      preferredMinute: preferredMinute,
      timezone: timezone,
      locale: locale,
      osPermission: osPermission,
      deviceToken: deviceToken,
      platform: platform,
    );

    _syncState?.setPayload(
      NotificationSyncPayload(
        wantsDaily: wantsDaily,
        preferredHour: preferredHour,
        preferredMinute: preferredMinute,
        timezone: timezone,
        locale: locale,
        osPermission: osPermission,
        platform: platform,
      ),
    );

    return preferences;
  }

  @override
  Future<NotificationPreferences> fetchPreferences({
    required String timezone,
    required String locale,
    required String osPermission,
    String? deviceToken,
    String? platform,
  }) {
    return _syncClientState(
      wantsDaily: null,
      preferredHour: null,
      preferredMinute: null,
      timezone: timezone,
      locale: locale,
      osPermission: osPermission,
      deviceToken: deviceToken,
      platform: platform,
    );
  }

  @override
  Future<NotificationPreferences> updatePreferences({
    required bool wantsDaily,
    required int preferredHour,
    required int preferredMinute,
  }) async {
    final response = await _client.rpc(
      'notifications_update_preferences',
      params: {
        'p_wants_daily': wantsDaily,
        'p_preferred_hour': preferredHour,
        'p_preferred_minute': preferredMinute,
      },
    );
    return NotificationPreferences.fromMap(
      (response as Map<String, dynamic>?) ?? const {},
    );
  }

  @override
  Future<void> revokeDeviceToken(String deviceToken) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException("Missing authenticated user for token revoke.");
    }

    final tokenRow =
        await _client
            .from('device_tokens')
            .select('id')
            .eq('token', deviceToken)
            .eq('user_id', userId)
            .maybeSingle();

    final tokenId = tokenRow?['id'] as String?;
    if (tokenId == null) return;

    await _client.rpc(
      'notifications_mark_token_status',
      params: {'p_token_id': tokenId, 'p_status': 'revoked'},
    );
  }

  Future<NotificationPreferences> _syncClientState({
    required bool? wantsDaily,
    required int? preferredHour,
    required int? preferredMinute,
    required String timezone,
    required String locale,
    required String osPermission,
    String? deviceToken,
    String? platform,
  }) async {
    final response = await _client.rpc(
      'notifications_sync_client_state',
      params: {
        'p_token': deviceToken,
        'p_platform': platform,
        'p_locale': locale,
        'p_timezone': timezone,
        'p_os_permission': osPermission,
        'p_wants_daily': wantsDaily,
        'p_preferred_hour': preferredHour,
        'p_preferred_minute': preferredMinute,
      },
    );
    return NotificationPreferences.fromMap(
      (response as Map<String, dynamic>?) ?? const {},
    );
  }
}
