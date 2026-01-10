import 'package:flutter/widgets.dart';

import 'join_home_blocked_surface_contract.dart';
import 'widgets/join_home_blocked_body.dart';

typedef JoinHomeBlockedSectionBuilder =
    Widget Function(JoinHomeBlockedSurfaceScope scope);

class JoinHomeBlockedSectionEntry {
  const JoinHomeBlockedSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;
  final int order;
  final JoinHomeBlockedSectionBuilder builder;
}

class JoinHomeBlockedRegistry {
  static final List<JoinHomeBlockedSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<JoinHomeBlockedSectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(JoinHomeBlockedSectionEntry entry) {
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
      JoinHomeBlockedSectionEntry(
        id: 'content',
        order: 10,
        builder: (scope) => JoinHomeBlockedBody(scope: scope),
      ),
    );
  }
}
