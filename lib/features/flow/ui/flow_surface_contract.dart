import 'package:flutter/widgets.dart';

import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n.dart';
import '../bloc/flow_list_bloc.dart';
import '../../../contracts/chores/models.dart';

class FlowSurfaceSlots {
  const FlowSurfaceSlots({
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

class FlowSurfaceActions {
  const FlowSurfaceActions({
    required this.onAddTap,
    required this.onItemTap,
    required this.onRefresh,
    required this.onRetry,
  });

  final VoidCallback onAddTap;
  final void Function(ChoreListEntry entry) onItemTap;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
}

class FlowSurfaceScope {
  const FlowSurfaceScope({
    required this.context,
    required this.state,
    required this.items,
    required this.ownerUserId,
    required this.spacing,
    required this.sections,
    required this.strings,
    required this.actions,
  });

  final BuildContext context;
  final FlowListState state;
  final List<ChoreListEntry> items;
  final String? ownerUserId;
  final Spacing spacing;
  final KinlySections sections;
  final S strings;
  final FlowSurfaceActions actions;
}

