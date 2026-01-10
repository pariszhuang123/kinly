import 'package:flutter/widgets.dart';

import 'paywall_surface_contract.dart';
import 'widgets/paywall_content.dart';

typedef PaywallSectionBuilder = Widget Function(PaywallSurfaceScope scope);

class PaywallSectionEntry {
  const PaywallSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;
  final int order;
  final PaywallSectionBuilder builder;
}

class PaywallRegistry {
  static final List<PaywallSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<PaywallSectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(PaywallSectionEntry entry) {
    _entries.add(entry);
    _entries.sort((a, b) => a.order.compareTo(b.order));
  }

  static void bootstrap() {
    if (_bootstrapped) return;
    _bootstrapped = true;
    _registerDefaults();
  }

  static void clearForTest() {
    _entries.clear();
    _bootstrapped = false;
  }

  static void _registerDefaults() {
    register(
      PaywallSectionEntry(
        id: 'content',
        order: 10,
        builder: (scope) => PaywallContent(scope: scope),
      ),
    );
  }
}
