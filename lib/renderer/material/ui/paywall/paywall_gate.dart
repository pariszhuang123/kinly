import 'dart:async';

import 'package:flutter/material.dart';

import 'package:kinly/contracts/paywall/enums/paywall_gate_status.dart';
import 'package:kinly/contracts/paywall/enums/paywall_retry_action.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import '../../../../core/di/locator.dart';
import 'paywall_strings.dart';
import 'ports/paywall_launcher.dart';

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

  final launcher = sl<PaywallLauncher>();
  final contextualStrings = _withTriggerContext(
    strings: strings,
    triggers: request.triggers,
  );
  final result = await launcher.showPaywall(
    context: context,
    homeId: request.homeId,
    strings: contextualStrings,
    source: request.source,
    triggers: request.triggers,
  );

  if (result == true) {
    status = PaywallGateStatus.granted;
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

const _triggerPriority = [
  PaywallTrigger.expensePhotosCap,
  PaywallTrigger.expenseActiveCap,
  PaywallTrigger.flowPhotosCap,
  PaywallTrigger.flowActiveCap,
  PaywallTrigger.shoppingPhotosCap,
  PaywallTrigger.membersCap,
];

PaywallStrings _withTriggerContext({
  required PaywallStrings strings,
  required Set<PaywallTrigger> triggers,
}) {
  final ordered = _triggerPriority.where(triggers.contains);
  String? emotionalBody;

  for (final trigger in ordered) {
    switch (trigger) {
      case PaywallTrigger.flowActiveCap:
        emotionalBody = strings.bulletFlows;
        break;
      case PaywallTrigger.flowPhotosCap:
        emotionalBody = strings.bulletFlowPhotos ?? strings.bulletPhotos;
        break;
      case PaywallTrigger.shoppingPhotosCap:
        emotionalBody = strings.bulletShoppingPhotos;
        break;
      case PaywallTrigger.expensePhotosCap:
        emotionalBody = strings.bulletExpensePhotos;
        break;
      case PaywallTrigger.expenseActiveCap:
        emotionalBody = strings.bulletShares;
        break;
      case PaywallTrigger.membersCap:
        emotionalBody = strings.bulletMembers;
        break;
    }
    if (emotionalBody.trim().isNotEmpty) break;
  }

  if (emotionalBody == null || emotionalBody.trim().isEmpty) {
    return strings;
  }

  return strings.copyWith(emotionalBody: emotionalBody);
}
