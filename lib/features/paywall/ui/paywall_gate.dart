import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/paywall/enums/paywall_gate_status.dart';
import 'package:kinly/core/paywall/enums/paywall_retry_action.dart';
import 'package:kinly/core/paywall/enums/paywall_trigger.dart';
import 'package:kinly/data/repositories/paywall_repository.dart';
import 'package:kinly/features/paywall/ui/paywall_screen.dart';

class PaywallGateRequest {
  final String requestId;
  final String homeId;
  final String source;
  final PaywallRetryAction action;
  final int tick;
  final Set<PaywallTrigger> triggers;

  const PaywallGateRequest({
    required this.requestId,
    required this.homeId,
    required this.source,
    required this.action,
    required this.tick,
    required this.triggers,
  });
}

class PaywallGateOutcome {
  final String requestId;
  final PaywallRetryAction action;
  final PaywallGateStatus status;

  const PaywallGateOutcome({
    required this.requestId,
    required this.action,
    required this.status,
  });
}

/// Shows the paywall, optionally refreshes entitlements, and returns the outcome.
Future<PaywallGateOutcome> showPaywallAndAwait({
  required BuildContext context,
  required PaywallGateRequest request,
  required PaywallStrings strings,
}) async {
  PaywallGateStatus status = PaywallGateStatus.cancelled;

  final result = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder:
          (_) => KinlyPaywallScreen(
            homeId: request.homeId,
            strings: strings,
            source: request.source,
            triggers: request.triggers,
          ),
    ),
  );

  if (result == true) {
    status = PaywallGateStatus.granted;

    final repo = sl<PaywallRepository>();
    const backoff = [250, 500, 1000];
    for (final delayMs in backoff) {
      try {
        await repo.refreshStatus(homeId: request.homeId);
      } catch (_) {
        // Swallow: best-effort refresh
      }
      await Future<void>.delayed(Duration(milliseconds: delayMs));
    }
  } else {
    status =
        result == false
            ? PaywallGateStatus.cancelled
            : PaywallGateStatus.failed;
  }

  return PaywallGateOutcome(
    requestId: request.requestId,
    action: request.action,
    status: status,
  );
}
