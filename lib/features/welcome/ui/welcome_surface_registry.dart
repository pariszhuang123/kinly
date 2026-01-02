import 'package:flutter/material.dart';

import 'welcome_surface_contract.dart';
import 'widgets/welcome_body.dart';

typedef WelcomeSectionBuilder = Widget Function(WelcomeSurfaceScope scope);

class WelcomeSectionEntry {
  const WelcomeSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;
  final int order;
  final WelcomeSectionBuilder builder;
}

class WelcomeRegistry {
  static final List<WelcomeSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<WelcomeSectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(WelcomeSectionEntry entry) {
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
      WelcomeSectionEntry(
        id: 'content',
        order: 10,
        builder: (scope) => WelcomeBody(scope: scope),
      ),
    );
  }
}
