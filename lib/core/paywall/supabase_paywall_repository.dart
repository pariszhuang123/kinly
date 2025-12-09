import 'package:supabase_flutter/supabase_flutter.dart';

import 'enums/paywall_event_type.dart';
import '../../core/paywall/paywall_models.dart';
import '../../data/repositories/paywall_repository.dart';

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
