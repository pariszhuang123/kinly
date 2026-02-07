import 'package:flutter/widgets.dart';

import 'package:kinly/contracts/homes/shopping_models.dart';

import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n.dart';

class ExploreSurfaceSlots {
  const ExploreSurfaceSlots({
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

class ExploreSurfaceActions {
  const ExploreSurfaceActions({
    required this.onFlowTap,
    required this.onShareTap,
    required this.onShoppingItemTap,
  });

  final VoidCallback onFlowTap;
  final VoidCallback onShareTap;
  final Future<void> Function(ShoppingListItem item) onShoppingItemTap;
}

class ExploreSurfaceScope {
  const ExploreSurfaceScope({
    required this.context,
    required this.spacing,
    required this.sections,
    required this.strings,
    required this.actions,
  });

  final BuildContext context;
  final Spacing spacing;
  final KinlySections sections;
  final S strings;
  final ExploreSurfaceActions actions;
}
