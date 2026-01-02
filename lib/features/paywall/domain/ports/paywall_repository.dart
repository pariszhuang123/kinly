import 'package:kinly/contracts/paywall/enums/paywall_event_type.dart';

abstract class PaywallRepository {
  Future<void> logEvent({
    required String homeId,
    required PaywallEventType eventType,
    String? source,
  });

  /// Best-effort hook to refresh paywall status/entitlements for a home.
  /// Implementations may no-op if the backend refresh is driven elsewhere
  /// (e.g., via webhook) but should not throw.
  Future<void> refreshStatus({required String homeId});
}
