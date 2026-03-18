import 'package:flutter/widgets.dart';

import 'share_owed_detail_surface_contract.dart';
import 'widgets/share_owed_detail_body.dart';

typedef ShareOwedDetailSectionBuilder =
    Widget Function(ShareOwedDetailSurfaceScope scope);

class ShareOwedDetailSectionEntry {
  const ShareOwedDetailSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;
  final int order;
  final ShareOwedDetailSectionBuilder builder;
}

class ShareOwedDetailRegistry {
  static final List<ShareOwedDetailSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<ShareOwedDetailSectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(ShareOwedDetailSectionEntry entry) {
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
      ShareOwedDetailSectionEntry(
        id: 'content',
        order: 10,
        builder:
            (scope) => ShareOwedDetailBody(
              owed: scope.owed,
              spacing: scope.spacing,
              strings: scope.strings,
              hasItems: scope.hasItems,
              isSubmitting: scope.isSubmitting,
              errorMessage: scope.errorMessage,
              paymentBankAccount: scope.paymentBankAccount,
              isLoadingPaymentBankAccount: scope.isLoadingPaymentBankAccount,
              onMarkAllPaid: scope.actions.onMarkAllPaid,
            ),
      ),
    );
  }
}
