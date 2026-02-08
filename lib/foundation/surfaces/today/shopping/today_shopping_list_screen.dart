import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/contracts/share/share_edit_route_args.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/dialogs/kinly_dialogs.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_list_tile.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tab_bar.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/ui/toggles/kinly_checkbox.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/kinly_icons.dart';

import '../domain/models.dart';
import '../routes/today_shopping_route_args.dart';
import 'bloc/shopping_list_bloc.dart';

enum _ShoppingTab {
  pending,
  completed,
}

class TodayShoppingListScreen extends StatefulWidget {
  const TodayShoppingListScreen({super.key, required this.homeId, this.actor});

  final String homeId;
  final TodayUserProfile? actor;

  @override
  State<TodayShoppingListScreen> createState() => _TodayShoppingListScreenState();
}

class _TodayShoppingListScreenState extends State<TodayShoppingListScreen> {
  _ShoppingTab _selectedTab = _ShoppingTab.pending;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<ShoppingListBloc, ShoppingListState>(
      listenWhen:
          (prev, curr) =>
              prev.messageTick != curr.messageTick ||
              prev.linkedExpenseTick != curr.linkedExpenseTick,
      listener: (context, state) async {
        if (state.messageTick > 0 && state.message != null) {
          KinlySnackBar.showInfo(context, state.message!);
        }
        if (state.linkedExpenseTick > 0 && state.linkedExpenseId != null) {
          await context.pushNamed(
            AppRouteNames.shareDraftEdit,
            pathParameters: {'expenseId': state.linkedExpenseId!},
            extra: const ShareEditRouteArgs(allowDelete: true),
          );
          if (!context.mounted) return;
          context.read<ShoppingListBloc>().add(
            const LoadShoppingListEvent(keepCurrent: true),
          );
        }
      },
      builder: (context, state) {
        final hasPendingItems = state.pendingItems.isNotEmpty;
        final hasCompletedItems = state.completedItems.isNotEmpty;
        final showTabBar = hasPendingItems && hasCompletedItems;
        _syncSelectedTab(
          hasPendingItems: hasPendingItems,
          hasCompletedItems: hasCompletedItems,
        );
        return KinlyScaffold(
          appBar: KinlyAppBar(title: Text(s.shoppingListTitle)),
          body: SafeArea(
            child: _buildBody(context, state, showTabBar),
          ),
        );
      },
    );
  }

  void _syncSelectedTab({
    required bool hasPendingItems,
    required bool hasCompletedItems,
  }) {
    if (!hasPendingItems && hasCompletedItems) {
      _selectedTab = _ShoppingTab.completed;
      return;
    }
    if (hasPendingItems && !hasCompletedItems) {
      _selectedTab = _ShoppingTab.pending;
    }
  }

  Widget _buildBody(
    BuildContext context,
    ShoppingListState state,
    bool showTabBar,
  ) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    if (state.isLoading) {
      return const Center(child: KinlyLoader());
    }
    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    final activeItems =
        showTabBar
            ? (_selectedTab == _ShoppingTab.completed
                ? state.completedItems
                : state.pendingItems)
            : (state.pendingItems.isNotEmpty
                ? state.pendingItems
                : state.completedItems);

    final list =
        activeItems.isEmpty
            ? Center(child: Text(s.shoppingEmptyTitle))
            : _ShoppingItemsList(
              items: activeItems,
              onToggleItem: (item, isCompleted) {
                if (item.isCompleted == isCompleted) return;
                context.read<ShoppingListBloc>().add(
                  ToggleShoppingItemEvent(
                    itemId: item.id,
                    isCompleted: isCompleted,
                  ),
                );
              },
              onTapItem: (item) => _openEditor(context, item),
            );

    return Column(
      children: [
        if (showTabBar)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              spacing.lg,
              spacing.sm,
              spacing.lg,
              spacing.sm,
            ),
            child: KinlyTabBar<_ShoppingTab>(
              tabs: <_ShoppingTab, String>{
                _ShoppingTab.pending:
                    '${s.shoppingTabPending} (${state.pendingItems.length})',
                _ShoppingTab.completed:
                    '${s.shoppingArchiveCta} (${state.completedItems.length})',
              },
              selected: _selectedTab,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedTab = value);
              },
            ),
          ),
        Expanded(child: list),
        if (state.completedItems.isNotEmpty)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              spacing.lg,
              spacing.sm,
              spacing.lg,
              spacing.lg,
            ),
            child: KinlyFilledButton.text(
              onPressed: () => _archiveCompleted(context),
              label: s.shoppingArchiveCta,
              fullWidth: true,
            ),
          ),
      ],
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    ShoppingListItem item,
  ) async {
    await context.pushNamed(
      AppRouteNames.todayShoppingEdit,
      pathParameters: {'itemId': item.id},
      queryParameters: {'homeId': widget.homeId},
      extra: TodayShoppingRouteArgs(
        homeId: widget.homeId,
        actor: widget.actor,
        item: item,
      ),
    );
    if (!context.mounted) return;
    context.read<ShoppingListBloc>().add(const LoadShoppingListEvent(keepCurrent: true));
  }

  Future<void> _archiveCompleted(BuildContext context) async {
    final s = S.of(context);
    final triggerShare = await showKinlyConfirmDialog(
      context,
      title: s.shoppingArchiveSharePromptTitle,
      message: s.shoppingArchiveSharePromptBody,
      confirmLabel: s.shoppingArchiveShareYes,
    );
    if (!context.mounted) return;
    context.read<ShoppingListBloc>().add(
      ArchiveMyCompletedShoppingItemsEvent(triggerShareSpend: triggerShare == true),
    );
  }
}

class _ShoppingItemsList extends StatelessWidget {
  const _ShoppingItemsList({
    required this.items,
    required this.onToggleItem,
    required this.onTapItem,
  });

  final List<ShoppingListItem> items;
  final void Function(ShoppingListItem item, bool isCompleted) onToggleItem;
  final void Function(ShoppingListItem item)? onTapItem;

  static bool _hasText(String? value) => (value ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return ListView.separated(
      padding: EdgeInsetsDirectional.all(spacing.lg),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        final item = items[index];
        final hasDetails = _hasText(item.details);
        final hasPhoto = _hasText(item.referencePhotoPath);
        final canOpenEditor = onTapItem != null;

        final trailingChildren = <Widget>[
          if (hasDetails) ...[
            const Icon(KinlyIcons.notesOutlined, size: 18),
            SizedBox(width: spacing.xs),
          ],
          if (hasPhoto) ...[
            const Icon(KinlyIcons.photoCameraOutlined, size: 18),
            SizedBox(width: spacing.xs),
          ],
          if (canOpenEditor) const Icon(KinlyIcons.chevronRight, size: 18),
        ];

        return KinlyListTile(
          leading: KinlyCheckbox(
            value: item.isCompleted,
            borderWidth: 1.8,
            onChanged: (isCompleted) => onToggleItem(item, isCompleted),
          ),
          title: item.name,
          subtitle: _hasText(item.quantity) ? item.quantity!.trim() : null,
          trailing:
              trailingChildren.isEmpty
                  ? null
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: trailingChildren,
                  ),
          onTap: canOpenEditor ? () => onTapItem!(item) : null,
        );
      },
    );
  }
}
