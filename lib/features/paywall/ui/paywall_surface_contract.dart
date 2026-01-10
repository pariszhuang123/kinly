import 'package:flutter/widgets.dart';

import 'paywall_strings.dart';
import '../bloc/paywall_bloc.dart';

class PaywallSurfaceSlots {
  const PaywallSurfaceSlots({
    this.header,
    required this.body,
    this.empty,
    this.footer,
    this.actions,
  });

  final Widget? header;
  final Widget body;
  final Widget? empty;
  final Widget? footer;
  final List<Widget>? actions;
}

class PaywallSurfaceActions {
  const PaywallSurfaceActions({
    required this.onUpgrade,
    required this.onRestore,
    required this.onDismiss,
    required this.onRetry,
  });

  final VoidCallback onUpgrade;
  final VoidCallback onRestore;
  final VoidCallback onDismiss;
  final VoidCallback onRetry;
}

class PaywallSurfaceScope {
  const PaywallSurfaceScope({
    required this.context,
    required this.state,
    required this.strings,
    required this.orderedBenefits,
    required this.actions,
  });

  final BuildContext context;
  final PaywallState state;
  final PaywallStrings strings;
  final List<String> orderedBenefits;
  final PaywallSurfaceActions actions;
}
