import 'package:flutter/widgets.dart';

import '../widgets/share_created_list_view.dart';
import 'share_created_list_surface_contract.dart';

typedef ShareCreatedListSectionBuilder =
    Widget Function(ShareCreatedListSurfaceScope scope);

class ShareCreatedListSectionEntry {
  const ShareCreatedListSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;
  final int order;
  final ShareCreatedListSectionBuilder builder;
}

class ShareCreatedListRegistry {
  static final List<ShareCreatedListSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<ShareCreatedListSectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(ShareCreatedListSectionEntry entry) {
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
      ShareCreatedListSectionEntry(
        id: 'list',
        order: 10,
        builder:
            (scope) => ShareCreatedListView(
              state: scope.state,
              shareColors: scope.sections.share,
              onRefreshRequested: scope.actions.onRefreshRequested,
              onCreateTap: scope.actions.onCreateTap,
              onEntryTap: scope.actions.onEntryTap,
            ),
      ),
    );
  }
}
