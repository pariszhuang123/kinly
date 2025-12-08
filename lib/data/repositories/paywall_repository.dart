import '../../core/paywall/paywall_models.dart';

abstract class PaywallRepository {
  Future<PaywallStatus> getStatus(String homeId);

  Future<void> logEvent({
    required String homeId,
    required PaywallEventType eventType,
    String? source,
  });
}
