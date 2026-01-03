import 'package:flutter/material.dart';

import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import '../paywall_strings.dart';

abstract class PaywallLauncher {
  Future<bool?> showPaywall({
    required BuildContext context,
    required String homeId,
    required PaywallStrings strings,
    String? source,
    String? placementId,
    Set<PaywallTrigger> triggers = const {},
  });
}
