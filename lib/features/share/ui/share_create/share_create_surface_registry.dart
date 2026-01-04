import 'package:flutter/widgets.dart';

import '../widgets/share_create_body.dart';
import 'share_create_surface_contract.dart';

typedef ShareCreateSectionBuilder =
    Widget Function(ShareCreateSurfaceScope scope);

class ShareCreateSectionEntry {
  const ShareCreateSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;
  final int order;
  final ShareCreateSectionBuilder builder;
}

class ShareCreateRegistry {
  static final List<ShareCreateSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<ShareCreateSectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(ShareCreateSectionEntry entry) {
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
      ShareCreateSectionEntry(
        id: 'body',
        order: 10,
        builder: (scope) {
          final shareColors = scope.sections?.share;
          return ShareCreateBody(
            spacing: scope.spacing,
            state: scope.state,
            shareColors: shareColors,
            allowDelete: scope.allowDelete,
            showTerminatePlan: scope.showTerminatePlan,
            onRetry: scope.actions.onRetry,
            descriptionController: scope.descriptionController,
            amountController: scope.amountController,
            notesController: scope.notesController,
            recurrenceEveryController: scope.recurrenceEveryController,
            customControllers: scope.customControllers,
            onSubmit: scope.actions.onSubmit,
            onDeleteRequested: scope.actions.onDeleteRequested,
            onTerminatePlan: scope.actions.onTerminatePlan,
            onPaywallOpened: scope.actions.onPaywallOpened,
          );
        },
      ),
    );
  }
}

