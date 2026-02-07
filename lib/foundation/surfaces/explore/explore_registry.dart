import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/shopping_models.dart';
import '../../../core/theme/section_assets.dart';
import '../../../core/ui/kinly_list_tile.dart';
import '../../../core/ui/kinly_selection_card.dart';
import '../today/shopping/bloc/shopping_list_bloc.dart';
import 'explore_slots.dart';
import '../../../core/ui/kinly_theme_access.dart';
import '../../../renderer/material/kinly_icons.dart';

typedef ExploreSectionBuilder = Widget Function(ExploreSurfaceScope scope);

enum ExploreSectionSpacing { none, sm, md, lg, xl }

class ExploreSectionEntry {
  const ExploreSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
    this.spacingAfter = ExploreSectionSpacing.lg,
    this.isVisible,
  });

  final String id;
  final int order;
  final ExploreSectionBuilder builder;
  final ExploreSectionSpacing spacingAfter;
  final bool Function(ExploreSurfaceScope scope)? isVisible;
}

class ExploreRegistry {
  static final List<ExploreSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<ExploreSectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(ExploreSectionEntry entry) {
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
      ExploreSectionEntry(
        id: 'intro',
        order: 10,
        spacingAfter: ExploreSectionSpacing.lg,
        builder: (scope) {
          final theme = KinlyThemeAccess.of(scope.context);
          return Text(
            scope.strings.exploreIntroSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          );
        },
      ),
    );

    register(
      ExploreSectionEntry(
        id: 'flow_tile',
        order: 20,
        spacingAfter: ExploreSectionSpacing.md,
        builder: (scope) {
          final sections = scope.sections;
          return KinlySelectionCard(
            colors: sections.flow,
            title: scope.strings.quick_add_flow_title,
            subtitle: scope.strings.exploreFlowSubtitle,
            icon: SectionAssets.flow.build(color: sections.flow.icon, size: 32),
            onTap: scope.actions.onFlowTap,
          );
        },
      ),
    );

    register(
      ExploreSectionEntry(
        id: 'share_tile',
        order: 30,
        spacingAfter: ExploreSectionSpacing.lg,
        builder: (scope) {
          final sections = scope.sections;
          final shareColors = sections.share;
          return KinlySelectionCard(
            colors: shareColors.copyWith(card: shareColors.background),
            title: scope.strings.quick_add_share_title,
            subtitle: scope.strings.exploreShareSubtitle,
            icon: SectionAssets.share.build(
              color: sections.share.icon,
              size: 32,
            ),
            onTap: scope.actions.onShareTap,
          );
        },
      ),
    );

    register(
      ExploreSectionEntry(
        id: 'shopping_items',
        order: 40,
        spacingAfter: ExploreSectionSpacing.lg,
        builder: (scope) {
          return BlocBuilder<ShoppingListBloc, ShoppingListState>(
            builder: (context, state) {
              final items = state.pendingItems;
              if (state.isLoading) {
                return const SizedBox.shrink();
              }
              if (items.isEmpty) {
                return const SizedBox.shrink();
              }
              return _buildShoppingSection(scope, items);
            },
          );
        },
      ),
    );
  }

  static Widget _buildShoppingSection(
    ExploreSurfaceScope scope,
    List<ShoppingListItem> items,
  ) {
    final children = <Widget>[
      Text(
        scope.strings.exploreShoppingSectionTitle,
        style: KinlyThemeAccess.of(scope.context).textTheme.titleMedium,
      ),
      SizedBox(height: scope.spacing.sm),
    ];
    for (final item in items) {
      children.add(
        Padding(
          padding: EdgeInsetsDirectional.only(bottom: scope.spacing.sm),
          child: KinlyListTile(
            leading: const Icon(KinlyIcons.shoppingBasketOutlined),
            title: item.name,
            subtitle:
                _hasText(item.quantity)
                    ? item.quantity
                    : scope.strings.exploreShoppingItemSubtitle,
            onTap: () => scope.actions.onShoppingItemTap(item),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  static bool _hasText(String? value) => (value ?? '').trim().isNotEmpty;
}
