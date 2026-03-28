import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/dialogs/kinly_dialogs.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/buttons/kinly_fab.dart';
import 'package:kinly/core/ui/kinly_list_tile.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_refresh_indicator.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tab_bar.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/ui/toggles/kinly_checkbox.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/kinly_icons.dart';
import 'package:kinly/contracts/share/share_create_route_args.dart';

import '../domain/models.dart';
import '../routes/today_shopping_route_args.dart';
import 'bloc/shopping_list_bloc.dart';

enum _ShoppingTab {
  pending,
  completed,
}

class TodayShoppingListScreen extends StatefulWidget {
  const TodayShoppingListScreen({
    super.key,
    required this.homeId,
    this.actor,
    this.mode = TodayShoppingListMode.purchase,
  });

  final String homeId;
  final TodayUserProfile? actor;
  final TodayShoppingListMode mode;

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
              prev.pendingBillCreateTick != curr.pendingBillCreateTick ||
              prev.archivedTick != curr.archivedTick,
      listener: (context, state) async {
        if (state.messageTick > 0 && state.message != null) {
          final resolved = _resolveErrorMessage(context, state);
          KinlySnackBar.showError(context, resolved);
        }
        if (state.pendingBillCreateTick > 0 && state.pendingBillCreate != null) {
          final success = await _openQuickBillCreate(
            context,
            state.pendingBillCreate!,
          );
          if (!context.mounted) return;
          context.read<ShoppingListBloc>().add(const ConsumePendingBillCreateEvent());
          context.read<ShoppingListBloc>().add(
            const LoadShoppingListEvent(keepCurrent: true),
          );
          if (success) {
            KinlySnackBar.showSuccess(
              context,
              S.of(context).shoppingArchiveDraftBillCreated,
            );
            context.goNamed(AppRouteNames.today);
          }
        }
        if (state.archivedTick > 0) {
          KinlySnackBar.showSuccess(
            context,
            S.of(context).shoppingArchiveItemsBought,
          );
          context.goNamed(AppRouteNames.today);
        }
      },
      builder: (context, state) {
        final isManageMode = widget.mode == TodayShoppingListMode.manage;
        final hasPendingItems = state.pendingItems.isNotEmpty;
        final hasCompletedItems = state.completedItems.isNotEmpty;
        final showAddFab = isManageMode || !hasCompletedItems;
        final showTabBar = !isManageMode && (hasPendingItems || hasCompletedItems);
        _syncSelectedTab(
          hasPendingItems: hasPendingItems,
          hasCompletedItems: hasCompletedItems,
        );
        return KinlyScaffold(
          appBar: KinlyAppBar(title: Text(s.shoppingListTitle)),
          floatingActionButton:
              showAddFab
                  ? KinlyFab(
                    onPressed: () => _openCreate(context),
                    heroTag:
                        isManageMode
                            ? 'shopping_manage_fab'
                            : 'shopping_purchase_fab',
                  )
                  : null,
          body: SafeArea(
            child: _buildBody(
              context,
              state,
              showTabBar: showTabBar,
              isManageMode: isManageMode,
            ),
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
    {
    required bool showTabBar,
    required bool isManageMode,
  }) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    if (state.isLoading) {
      return const Center(child: KinlyLoader());
    }
    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    final activeItems = _resolveActiveItems(
      state,
      showTabBar: showTabBar,
      isManageMode: isManageMode,
    );

    final list =
        activeItems.isEmpty
            ? _ShoppingItemsEmptyState(title: s.shoppingEmptyTitle)
            : _ShoppingItemsList(
              items: activeItems,
              showCheckbox: !isManageMode,
              onToggleItem:
                  isManageMode
                      ? null
                      : (item, isCompleted) {
                        if (item.isCompleted == isCompleted) return;
                        context.read<ShoppingListBloc>().add(
                          ToggleShoppingItemEvent(
                            itemId: item.id,
                            isCompleted: isCompleted,
                          ),
                        );
                      },
              onTapItem:
                  isManageMode
                      ? (item) => _openEditor(context, item)
                      : (item) => _openDetail(context, item),
              canTapItem:
                  isManageMode
                      ? null
                      : (item) => _hasTapDetail(item),
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
                if (state.pendingItems.isNotEmpty)
                  _ShoppingTab.pending:
                      '${s.shoppingTabPending} (${state.pendingItems.length})',
                if (state.completedItems.isNotEmpty)
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
        if (!isManageMode && activeItems.isNotEmpty)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              spacing.lg,
              spacing.sm,
              spacing.lg,
              0,
            ),
            child: Row(
              children: [
                KinlyCheckbox(
                  value: state.pendingItems.isEmpty,
                  borderWidth: 1.8,
                  onChanged: (isCompleted) {
                    context.read<ShoppingListBloc>().add(
                      ToggleAllShoppingItemsEvent(isCompleted: isCompleted),
                    );
                  },
                ),
                SizedBox(width: spacing.sm),
                Text(
                  s.shoppingAllItemsBought,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        Expanded(
          child: KinlyRefreshIndicator(
            onRefresh: () async {
              context.read<ShoppingListBloc>().add(
                const LoadShoppingListEvent(keepCurrent: true),
              );
            },
            child: list,
          ),
        ),
        if (!isManageMode && state.completedItems.isNotEmpty)
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

  List<ShoppingListItem> _resolveActiveItems(
    ShoppingListState state, {
    required bool showTabBar,
    required bool isManageMode,
  }) {
    if (isManageMode) {
      return state.pendingItems;
    }

    return showTabBar
        ? (_selectedTab == _ShoppingTab.completed
            ? state.completedItems
            : state.pendingItems)
        : (state.pendingItems.isNotEmpty ? state.pendingItems : state.completedItems);
  }

  bool _hasTapDetail(ShoppingListItem item) =>
      (item.details ?? '').trim().isNotEmpty ||
      (item.referencePhotoPath ?? '').trim().isNotEmpty;

  Future<void> _openDetail(
    BuildContext context,
    ShoppingListItem item,
  ) async {
    await context.pushNamed(
      AppRouteNames.todayShoppingDetail,
      pathParameters: {'itemId': item.id},
      queryParameters: {'homeId': widget.homeId},
    );
    if (!context.mounted) return;
    context.read<ShoppingListBloc>().add(const LoadShoppingListEvent(keepCurrent: true));
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

  Future<void> _openCreate(BuildContext context) async {
    await context.pushNamed(
      AppRouteNames.todayShoppingCreate,
      queryParameters: {'homeId': widget.homeId},
      extra: TodayShoppingRouteArgs(homeId: widget.homeId, actor: widget.actor),
    );
    if (!context.mounted) return;
    context.read<ShoppingListBloc>().add(const LoadShoppingListEvent(keepCurrent: true));
  }

  String _resolveErrorMessage(BuildContext context, ShoppingListState state) {
    if (state.message == shoppingErrorItemCompletedByOther) {
      return S.of(context).shoppingErrorItemAlreadyCompletedByOther;
    }
    return state.message!;
  }

  Future<void> _archiveCompleted(BuildContext context) async {
    final s = S.of(context);
    final triggerShare = await showKinlyConfirmDialog(
      context,
      title: s.shoppingArchiveSharePromptTitle,
      message: s.shoppingArchiveSharePromptBody,
      confirmLabel: s.shoppingArchiveShareYes,
      cancelLabel: s.shoppingArchiveShareNo,
    );
    if (!context.mounted) return;
    if (triggerShare == null) return;
    context.read<ShoppingListBloc>().add(
      ArchiveMyCompletedShoppingItemsEvent(triggerShareSpend: triggerShare),
    );
  }

  Future<bool> _openQuickBillCreate(
    BuildContext context,
    PendingShoppingBillCreate pendingBillCreate,
  ) async {
    final result = await context.pushNamed<bool>(
      AppRouteNames.shareCreate,
      extra: ShareCreateRouteArgs(
        initialDescription: pendingBillCreate.description,
        initialNotes: pendingBillCreate.notes,
        preselectEqualSplit: true,
        presentationMode: ShareCreatePresentationMode.shoppingQuickCreate,
        shoppingExpenseLinkRequest: ShareShoppingExpenseLinkRequest(
          homeId: widget.homeId,
          itemIds: pendingBillCreate.itemIds,
        ),
      ),
    );
    return result == true;
  }
}

class _ShoppingItemsList extends StatelessWidget {
  const _ShoppingItemsList({
    required this.items,
    required this.showCheckbox,
    required this.onToggleItem,
    required this.onTapItem,
    required this.canTapItem,
  });

  final List<ShoppingListItem> items;
  final bool showCheckbox;
  final void Function(ShoppingListItem item, bool isCompleted)? onToggleItem;
  final void Function(ShoppingListItem item)? onTapItem;
  final bool Function(ShoppingListItem item)? canTapItem;

  static bool _hasText(String? value) => (value ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.all(spacing.lg),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        final item = items[index];
        final hasDetails = _hasText(item.details);
        final hasPhoto = _hasText(item.referencePhotoPath);
        final canOpen = onTapItem != null && (canTapItem?.call(item) ?? true);

        final trailingChildren = <Widget>[
          if (hasDetails) ...[
            const Icon(KinlyIcons.notesOutlined, size: 18),
            SizedBox(width: spacing.xs),
          ],
          if (hasPhoto) ...[
            const Icon(KinlyIcons.photoCameraOutlined, size: 18),
            SizedBox(width: spacing.xs),
          ],
          if (canOpen) const Icon(KinlyIcons.chevronRight, size: 18),
        ];

        return KinlyListTile(
          leading:
              showCheckbox
                  ? KinlyCheckbox(
                    value: item.isCompleted,
                    borderWidth: 1.8,
                    onChanged:
                        (isCompleted) => onToggleItem?.call(item, isCompleted),
                  )
                  : const Icon(KinlyIcons.shoppingBasketOutlined),
          title: item.name,
          subtitle: _hasText(item.quantity) ? item.quantity!.trim() : null,
          trailing:
              trailingChildren.isEmpty
                  ? null
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: trailingChildren,
                  ),
          onTap: canOpen ? () => onTapItem!(item) : null,
        );
      },
    );
  }
}

class _ShoppingItemsEmptyState extends StatelessWidget {
  const _ShoppingItemsEmptyState({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.all(spacing.lg),
      children: [
        SizedBox(height: spacing.xl * 2),
        Center(child: Text(title)),
      ],
    );
  }
}
