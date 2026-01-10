import 'package:flutter/widgets.dart';

import 'start_home_surface_contract.dart';
import 'widgets/start_home_body.dart';

typedef StartHomeSectionBuilder = Widget Function(StartHomeSurfaceScope scope);

class StartHomeSectionEntry {
  const StartHomeSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;
  final int order;
  final StartHomeSectionBuilder builder;
}

class StartHomeRegistry {
  static final List<StartHomeSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<StartHomeSectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(StartHomeSectionEntry entry) {
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
      StartHomeSectionEntry(
        id: 'content',
        order: 10,
        builder: (scope) => StartHomeBody(scope: scope),
      ),
    );
  }
}
