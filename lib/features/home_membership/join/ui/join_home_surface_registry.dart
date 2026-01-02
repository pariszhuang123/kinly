import 'package:flutter/material.dart';

import 'join_home_surface_contract.dart';
import 'widgets/join_home_form.dart';

typedef JoinHomeSectionBuilder = Widget Function(JoinHomeSurfaceScope scope);

class JoinHomeSectionEntry {
  const JoinHomeSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;
  final int order;
  final JoinHomeSectionBuilder builder;
}

class JoinHomeRegistry {
  static final List<JoinHomeSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<JoinHomeSectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(JoinHomeSectionEntry entry) {
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
      JoinHomeSectionEntry(
        id: 'form',
        order: 10,
        builder: (scope) => JoinHomeForm(initialCode: scope.initialCode),
      ),
    );
  }
}
