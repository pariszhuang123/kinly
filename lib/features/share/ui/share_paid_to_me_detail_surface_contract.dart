import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';
import '../../../generated/l10n.dart';
import '../../../contracts/share/models.dart';
import 'share_paid_to_me_detail_models.dart';

class SharePaidToMeDetailSurfaceSlots {
  const SharePaidToMeDetailSurfaceSlots({
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

class SharePaidToMeDetailSurfaceScope {
  const SharePaidToMeDetailSurfaceScope({
    required this.context,
    required this.entry,
    required this.items,
    required this.spacing,
    required this.strings,
    required this.isLoading,
    required this.error,
  });

  final BuildContext context;
  final TodaySharePaidToMe entry;
  final List<TodaySharePaidItem> items;
  final Spacing spacing;
  final S strings;
  final bool isLoading;
  final String? error;
}
