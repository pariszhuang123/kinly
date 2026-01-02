import 'package:flutter/material.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/share_created_list_bloc/share_created_list_bloc.dart';

class ShareCreatedListSurfaceSlots {
  const ShareCreatedListSurfaceSlots({
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

class ShareCreatedListSurfaceActions {
  const ShareCreatedListSurfaceActions({
    required this.onRefreshRequested,
    required this.onCreateTap,
    required this.onEntryTap,
  });

  final Future<void> Function() onRefreshRequested;
  final VoidCallback onCreateTap;
  final void Function(ShareCreatedListEntry entry) onEntryTap;
}

class ShareCreatedListSurfaceScope {
  const ShareCreatedListSurfaceScope({
    required this.context,
    required this.state,
    required this.spacing,
    required this.sections,
    required this.strings,
    required this.actions,
  });

  final BuildContext context;
  final ShareCreatedListState state;
  final Spacing spacing;
  final KinlySections sections;
  final S strings;
  final ShareCreatedListSurfaceActions actions;
}
