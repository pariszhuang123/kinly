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
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/kinly_icons.dart';

import '../domain/models.dart';
import '../routes/today_shopping_item_detail_route_args.dart';
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
        final showCompletedTab = state.completedItems.isNotEmpty;
        _syncSelectedTab(showCompletedTab);
        return KinlyScaffold(
          appBar: KinlyAppBar(title: Text(s.shoppingListTitle)),
          body: SafeArea(
            child: _buildBody(context, state, showCompletedTab),
          ),
        );
      },
    );
  }

  void _syncSelectedTab(bool showCompletedTab) {
    if (!showCompletedTab && _selectedTab == _ShoppingTab.completed) {
      _selectedTab = _ShoppingTab.pending;
    }
  }

  Widget _buildBody(
    BuildContext context,
    ShoppingListState state,
    bool showCompletedTab,
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
        _selectedTab == _ShoppingTab.completed
            ? state.completedItems
            : state.pendingItems;

    final list =
        activeItems.isEmpty
            ? Center(child: Text(s.shoppingEmptyTitle))
            : _ShoppingItemsList(
              items: activeItems,
              onTapItem:
                  _selectedTab == _ShoppingTab.pending
                      ? (item) => _openDetail(context, state, item)
                      : null,
            );

    return Column(
      children: [
        if (showCompletedTab)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              spacing.lg,
              spacing.sm,
              spacing.lg,
              spacing.sm,
            ),
            child: KinlyTabBar<_ShoppingTab>(
              tabs: <_ShoppingTab, String>{
                _ShoppingTab.pending: s.shoppingTabPending,
                _ShoppingTab.completed: s.shoppingTabCompleted(
                  state.completedItems.length,
                ),
              },
              selected: _selectedTab,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedTab = value);
              },
            ),
          ),
        Expanded(child: list),
        if (state.myCompletedCount > 0)
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

  Future<void> _openDetail(
    BuildContext context,
    ShoppingListState state,
    ShoppingListItem item,
  ) async {
    final photoUrl = state.photoUrlsByItemId[item.id] ?? '';
    await context.pushNamed(
      AppRouteNames.todayShoppingDetail,
      pathParameters: {'itemId': item.id},
      extra: TodayShoppingItemDetailRouteArgs(
        item: item,
        photoUrl: photoUrl,
        onMarkComplete:
            () async => context.read<ShoppingListBloc>().add(
              ToggleShoppingItemEvent(itemId: item.id, isCompleted: true),
            ),
      ),
    );
    if (!context.mounted) return;
    context.read<ShoppingListBloc>().add(const LoadShoppingListEvent(keepCurrent: true));
  }

  Future<void> _archiveCompleted(BuildContext context) async {
    final s = S.of(context);
    final shouldArchive = await showKinlyConfirmDialog(
      context,
      title: s.shoppingArchiveConfirmTitle,
      message: s.shoppingArchiveConfirmBody,
      confirmLabel: s.shoppingArchiveCta,
    );
    if (!context.mounted || shouldArchive != true) return;

    final triggerShare = await showKinlyConfirmDialog(
      context,
      title: s.shoppingArchiveSharePromptTitle,
      message: s.shoppingArchiveSharePromptBody,
      confirmLabel: s.shoppingArchiveShareYes,
      cancelLabel: s.todayInviteNotNow,
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
    required this.onTapItem,
  });

  final List<ShoppingListItem> items;
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
        return KinlyListTile(
          leading: const Icon(KinlyIcons.shoppingBasketOutlined),
          title: item.name,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_hasText(item.quantity)) ...[
                const Icon(KinlyIcons.exposurePlus1Outlined, size: 18),
                SizedBox(width: spacing.xs),
              ],
              if (_hasText(item.details)) ...[
                const Icon(KinlyIcons.notesOutlined, size: 18),
                SizedBox(width: spacing.xs),
              ],
              if (_hasText(item.referencePhotoPath))
                const Icon(KinlyIcons.photoCameraOutlined, size: 18),
            ],
          ),
          onTap: onTapItem == null ? null : () => onTapItem!(item),
        );
      },
    );
  }
}
