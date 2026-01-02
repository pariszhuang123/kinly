import 'package:flutter/material.dart';

import 'flow_surface_contract.dart';
import 'widgets/flow_list_view.dart';

typedef FlowSectionBuilder = Widget Function(FlowSurfaceScope scope);

class FlowSectionEntry {
  const FlowSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;
  final int order;
  final FlowSectionBuilder builder;
}

class FlowRegistry {
  static final List<FlowSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<FlowSectionEntry> get bodySections => List.unmodifiable(_entries);

  static void register(FlowSectionEntry entry) {
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
      FlowSectionEntry(
        id: 'list',
        order: 10,
        builder:
            (scope) => FlowListView(
              items: scope.items,
              ownerUserId: scope.ownerUserId,
              onRefresh: scope.actions.onRefresh,
              onItemTap: scope.actions.onItemTap,
            ),
      ),
    );
  }
}
