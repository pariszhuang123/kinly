import '../../core/paywall/paywall_models.dart';
import '../../core/paywall/enums/paywall_event_type.dart';

abstract class PaywallRepository {
  Future<void> logEvent({
    required String homeId,
    required PaywallEventType eventType,
    String? source,
  });
}
