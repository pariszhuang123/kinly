import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../contracts/chores/models.dart';
import '../../../app/router/app_route_names.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/kinly_tab_bar.dart';
import '../../../core/ui/buttons/kinly_fab.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../generated/l10n.dart';
import 'flow_list_filter.dart';
import 'flow_surface_contract.dart';
import 'flow_surface_registry.dart';
import '../bloc/flow_list_bloc.dart';
import '../domain/flow_chore_outcome.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_app_bar.dart';
import '../../../core/ui/kinly_theme_access.dart';

enum _FlowTimeTab { current, future }

class FlowListScreen extends StatefulWidget {
  const FlowListScreen({
    super.key,
    this.homeId,
    this.filter = FlowListFilter.all,
    this.currentUserId,
    this.showOnlyCurrentUser = false,
  });

  final String? homeId;
  final FlowListFilter filter;
  final String? currentUserId;
  final bool showOnlyCurrentUser;

  @override
  State<FlowListScreen> createState() => _FlowListScreenState();
}

class _FlowListScreenState extends State<FlowListScreen> {
  _FlowTimeTab _selectedTab = _FlowTimeTab.current;

  @override
  Widget build(BuildContext context) {
    FlowRegistry.bootstrap();
    final theme = KinlyThemeAccess.of(context);
    final sections = theme.extension<KinlySections>()!;
    final flowColors = sections.flow;
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return KinlyScaffold(
      backgroundColor: flowColors.background,
      appBar: KinlyAppBar(
        backgroundColor: flowColors.background,
        title: Text(s.quick_add_flow_title),
      ),
      floatingActionButton: KinlyFab(
        onPressed: () => _openChoreEntry(context, null),
        heroTag: 'flow_list_fab',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: BlocBuilder<FlowListBloc, FlowListState>(
            builder: _buildStateContent,
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final bloc = context.read<FlowListBloc>();
    final completer = Completer<void>();
    late final StreamSubscription<FlowListState> sub;
    sub = bloc.stream.listen((state) {
      if (!state.isRefreshing && state.status != FlowListStatus.loading) {
        completer.complete();
        sub.cancel();
      }
    });
    bloc.add(const FlowListRefreshed());
    await completer.future;
  }

  Future<void> _openChoreEntry(
    BuildContext context,
    ChoreListEntry? entry,
  ) async {
    if (entry == null) {
      final result = await _pushFlowCreate(context);
      if (!context.mounted) return;
      if (result is FlowChoreOutcome) {
        _showOutcomeSnackbar(context, result);
        context.read<FlowListBloc>().add(const FlowListRefreshed());
      }
      return;
    }

    if (widget.filter == FlowListFilter.active) {
      final result = await _pushFlowDetail(context, choreId: entry.id);
      if (!context.mounted) return;
      if (result is FlowChoreOutcome) {
        _showOutcomeSnackbar(context, result);
        context.read<FlowListBloc>().add(const FlowListRefreshed());
      }
      return;
    }

    final result = await _pushFlowEdit(context, choreId: entry.id);
    if (!context.mounted) return;
    if (result is FlowChoreOutcome) {
      _showOutcomeSnackbar(context, result);
      context.read<FlowListBloc>().add(const FlowListRefreshed());
    }
  }

  Widget _buildStateContent(BuildContext context, FlowListState state) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>()!;
    if (state.status == FlowListStatus.loading) {
      return const Center(child: KinlyLoader(size: 40));
    }
    if (state.status == FlowListStatus.failure) {
      return _FlowListError(
        message: state.errorMessage ?? s.flowListError,
        onRetry:
            () => context.read<FlowListBloc>().add(const FlowListRequested()),
      );
    }
    if (state.status == FlowListStatus.success) {
      return _buildSuccessContent(context, state, s, spacing, sections);
    }
    return const SizedBox.shrink();
  }

  Widget _buildSuccessContent(
    BuildContext context,
    FlowListState state,
    S s,
    Spacing spacing,
    KinlySections sections,
  ) {
    final filteredItems = _filteredItems(state.items);
    if (filteredItems.isEmpty) {
      return _FlowListEmpty(onAddTap: () => _openChoreEntry(context, null));
    }

    final (currentItems, futureItems) = _partitionByDate(filteredItems);

    final hasCurrent = currentItems.isNotEmpty;
    final hasFuture = futureItems.isNotEmpty;
    final showTabs = hasCurrent && hasFuture;

    _adjustSelectedTab(showTabs, hasCurrent, hasFuture);

    final visibleItems =
        showTabs
            ? (_selectedTab == _FlowTimeTab.current
                ? currentItems
                : futureItems)
            : filteredItems;

    final actions = FlowSurfaceActions(
      onAddTap: () => _openChoreEntry(context, null),
      onItemTap: (entry) => _openChoreEntry(context, entry),
      onRefresh: () => _handleRefresh(context),
      onRetry:
          () => context.read<FlowListBloc>().add(const FlowListRequested()),
    );
    final scope = FlowSurfaceScope(
      context: context,
      state: state,
      items: visibleItems,
      ownerUserId: state.ownerUserId,
      spacing: spacing,
      sections: sections,
      strings: s,
      actions: actions,
    );

    final body = _buildFlowBody(scope);

    if (!showTabs) {
      return body;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KinlyTabBar<_FlowTimeTab>(
          tabs: {
            _FlowTimeTab.current: s.flowListTabCurrent,
            _FlowTimeTab.future: s.flowListTabFuture,
          },
          selected: _selectedTab,
          onChanged: (tab) {
            if (tab == null) return;
            setState(() => _selectedTab = tab);
          },
        ),
        SizedBox(height: spacing.md),
        Expanded(child: body),
      ],
    );
  }

  (List<ChoreListEntry>, List<ChoreListEntry>) _partitionByDate(
    List<ChoreListEntry> items,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentItems = <ChoreListEntry>[];
    final futureItems = <ChoreListEntry>[];
    for (final item in items) {
      final entryDate = DateTime(
        item.startDate.toLocal().year,
        item.startDate.toLocal().month,
        item.startDate.toLocal().day,
      );
      if (entryDate.isAfter(today)) {
        futureItems.add(item);
      } else {
        currentItems.add(item);
      }
    }
    return (currentItems, futureItems);
  }

  void _adjustSelectedTab(bool showTabs, bool hasCurrent, bool hasFuture) {
    if (showTabs && !hasCurrent && _selectedTab == _FlowTimeTab.current) {
      _selectedTab = _FlowTimeTab.future;
    } else if (showTabs &&
        !hasFuture &&
        _selectedTab == _FlowTimeTab.future) {
      _selectedTab = _FlowTimeTab.current;
    }
  }

  Widget _buildFlowBody(FlowSurfaceScope scope) {
    final entries = FlowRegistry.bodySections;
    if (entries.length == 1) {
      return entries.first.builder(scope);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries
          .map((entry) => entry.builder(scope))
          .toList(growable: false),
    );
  }

  void _showOutcomeSnackbar(BuildContext context, FlowChoreOutcome result) {
    final s = S.of(context);
    final accent =
        KinlyThemeAccess.of(context).extension<KinlySections>()!.flow.accent;
    if (result.isCompleted) {
      KinlySnackBar.showSuccess(
        context,
        s.flowChoreDetailCompletionSuccess,
        accentColor: accent,
      );
      return;
    }
    if (result.isUpdate) {
      KinlySnackBar.showSuccess(
        context,
        s.flowChoreUpdateSuccess,
        accentColor: accent,
      );
      return;
    }
    if (!result.isDeleted) {
      KinlySnackBar.showSuccess(
        context,
        s.flowChoreCreateSuccess,
        accentColor: accent,
      );
    }
  }

  List<ChoreListEntry> _filteredItems(List<ChoreListEntry> items) {
    final scopedItems =
        widget.showOnlyCurrentUser &&
                widget.currentUserId != null &&
                widget.filter == FlowListFilter.active
            ? items
                .where(
                  (entry) => entry.assigneeUserId == widget.currentUserId,
                )
                .toList(growable: false)
            : items;

    switch (widget.filter) {
      case FlowListFilter.active:
        return scopedItems
            .where((entry) => entry.assigneeUserId != null)
            .toList(growable: false);
      case FlowListFilter.drafts:
        return items
            .where((entry) => entry.assigneeUserId == null)
            .toList(growable: false);
      case FlowListFilter.all:
        return items;
    }
  }

  Map<String, dynamic> _flowQueryParamsOrEmpty() {
    final value = widget.homeId?.trim();
    if (value == null || value.isEmpty) {
      return const <String, dynamic>{};
    }
    return <String, dynamic>{'homeId': value};
  }

  Future<Object?> _pushFlowCreate(BuildContext context) {
    final query = _flowQueryParamsOrEmpty();
    if (query.isEmpty) {
      return context.pushNamed(AppRouteNames.flowChoreCreate);
    }
    return context.pushNamed(
      AppRouteNames.flowChoreCreate,
      queryParameters: query,
    );
  }

  Future<Object?> _pushFlowDetail(
    BuildContext context, {
    required String choreId,
  }) {
    final query = _flowQueryParamsOrEmpty();
    final pathParameters = <String, String>{'choreId': choreId};
    if (query.isEmpty) {
      return context.pushNamed(
        AppRouteNames.flowChoreDetail,
        pathParameters: pathParameters,
      );
    }
    return context.pushNamed(
      AppRouteNames.flowChoreDetail,
      pathParameters: pathParameters,
      queryParameters: query,
    );
  }

  Future<Object?> _pushFlowEdit(
    BuildContext context, {
    required String choreId,
  }) {
    final query = _flowQueryParamsOrEmpty();
    final pathParameters = <String, String>{'choreId': choreId};
    if (query.isEmpty) {
      return context.pushNamed(
        AppRouteNames.flowChoreEdit,
        pathParameters: pathParameters,
      );
    }
    return context.pushNamed(
      AppRouteNames.flowChoreEdit,
      pathParameters: pathParameters,
      queryParameters: query,
    );
  }
}

class _FlowListEmpty extends StatelessWidget {
  const _FlowListEmpty({required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            s.flowListEmptyTitle,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            s.flowListEmptySubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          KinlyFilledButton.text(
            fullWidth: true,
            onPressed: onAddTap,
            label: s.flowChoreSubmitCreate,
          ),
        ],
      ),
    );
  }
}

class _FlowListError extends StatelessWidget {
  const _FlowListError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          KinlyFilledButton.text(
            fullWidth: true,
            onPressed: onRetry,
            label: S.of(context).flowChoreRetry,
          ),
        ],
      ),
    );
  }
}
