import '../../core/paywall/paywall_models.dart';

abstract class PaywallRepository {
  Future<void> logEvent({
    required String homeId,
    required PaywallEventType eventType,
    String? source,
  });
}
