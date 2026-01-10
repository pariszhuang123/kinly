import 'package:flutter/widgets.dart';

import '../../../core/theme/spacing.dart';
import '../../../generated/l10n.dart';
import '../../../contracts/share/models.dart';

class ShareOwedDetailSurfaceSlots {
  const ShareOwedDetailSurfaceSlots({
    this.header,
    required this.body,
    this.empty,
    this.footer,
    this.actions,
  });

  final Widget? header;
  final Widget body;
  final Widget? empty;
  final Widget? footer;
  final List<Widget>? actions;
}

class ShareOwedDetailSurfaceActions {
  const ShareOwedDetailSurfaceActions({required this.onMarkAllPaid});

  final Future<void> Function() onMarkAllPaid;
}

class ShareOwedDetailSurfaceScope {
  const ShareOwedDetailSurfaceScope({
    required this.context,
    required this.owed,
    required this.spacing,
    required this.strings,
    required this.hasItems,
    required this.isSubmitting,
    required this.errorMessage,
    required this.actions,
  });

  final BuildContext context;
  final TodayShareOwed owed;
  final Spacing spacing;
  final S strings;
  final bool hasItems;
  final bool isSubmitting;
  final String? errorMessage;
  final ShareOwedDetailSurfaceActions actions;
}
