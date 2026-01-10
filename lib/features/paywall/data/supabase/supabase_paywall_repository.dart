import 'package:kinly/contracts/paywall/enums/paywall_event_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/features/paywall/paywall.dart';

class SupabasePaywallRepository implements PaywallRepository {
  SupabasePaywallRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<void> logEvent({
    required String homeId,
    required PaywallEventType eventType,
    String? source,
  }) {
    return _client.rpc(
      'paywall_log_event',
      params: {
        'p_home_id': homeId,
        'p_event_type': _eventTypeToDb(eventType),
        'p_source': source,
      },
    );
  }

  @override
  Future<void> refreshStatus({required String homeId}) async {
    try {
      await _client.rpc('paywall_status_get', params: {'p_home_id': homeId});
    } catch (_) {
      // Best-effort refresh; swallow errors to keep UI responsive.
    }
  }

  String _eventTypeToDb(PaywallEventType type) {
    switch (type) {
      case PaywallEventType.impression:
        return 'impression';
      case PaywallEventType.ctaClick:
        return 'cta_click';
      case PaywallEventType.dismiss:
        return 'dismiss';
      case PaywallEventType.restoreAttempt:
        return 'restore_attempt';
    }
  }
}
