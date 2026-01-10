import 'package:flutter/widgets.dart';

import 'share_paid_to_me_detail_surface_contract.dart';
import 'widgets/share_paid_to_me_detail_body.dart';

typedef SharePaidToMeDetailSectionBuilder =
    Widget Function(SharePaidToMeDetailSurfaceScope scope);

class SharePaidToMeDetailSectionEntry {
  const SharePaidToMeDetailSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;
  final int order;
  final SharePaidToMeDetailSectionBuilder builder;
}

class SharePaidToMeDetailRegistry {
  static final List<SharePaidToMeDetailSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<SharePaidToMeDetailSectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(SharePaidToMeDetailSectionEntry entry) {
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
      SharePaidToMeDetailSectionEntry(
        id: 'content',
        order: 10,
        builder:
            (scope) => SharePaidToMeDetailBody(
              entry: scope.entry,
              items: scope.items,
              spacing: scope.spacing,
              strings: scope.strings,
              isLoading: scope.isLoading,
              error: scope.error,
            ),
      ),
    );
  }
}
