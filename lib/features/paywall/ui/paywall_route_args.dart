import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/ui/paywall/paywall_strings.dart';

class PaywallRouteArgs {
  const PaywallRouteArgs({
    required this.homeId,
    required this.strings,
    this.source,
    this.placementId,
    this.triggers = const {},
  });

  final String homeId;
  final PaywallStrings strings;
  final String? source;
  final String? placementId;
  final Set<PaywallTrigger> triggers;
}
