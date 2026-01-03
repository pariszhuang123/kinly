import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../contracts/chores/models.dart';
import '../../../app/router/app_route_names.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/kinly_loader.dart';
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

class FlowListScreen extends StatelessWidget {
  const FlowListScreen({
    super.key,
    this.filter = FlowListFilter.all,
    this.currentUserId,
    this.showOnlyCurrentUser = false,
  });

  final FlowListFilter filter;
  final String? currentUserId;
  final bool showOnlyCurrentUser;

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
      final result = await context.pushNamed(AppRouteNames.flowChoreCreate);
      if (!context.mounted) return;
      if (result is FlowChoreOutcome) {
        _showOutcomeSnackbar(context, result);
        context.read<FlowListBloc>().add(const FlowListRefreshed());
      }
      return;
    }

    if (filter == FlowListFilter.active) {
      final result = await context.pushNamed(
        AppRouteNames.flowChoreDetail,
        pathParameters: {'choreId': entry.id},
      );
      if (!context.mounted) return;
      if (result is FlowChoreOutcome) {
        _showOutcomeSnackbar(context, result);
        context.read<FlowListBloc>().add(const FlowListRefreshed());
      }
      return;
    }

    final result = await context.pushNamed(
      AppRouteNames.flowChoreEdit,
      pathParameters: {'choreId': entry.id},
    );
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
      final filteredItems = _filteredItems(state.items);
      if (filteredItems.isEmpty) {
        return _FlowListEmpty(onAddTap: () => _openChoreEntry(context, null));
      }
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
        items: filteredItems,
        ownerUserId: state.ownerUserId,
        spacing: spacing,
        sections: sections,
        strings: s,
        actions: actions,
      );
      final slots = FlowSurfaceSlots(
        body: _buildFlowBody(scope),
      );
      return slots.body;
    }
    return const SizedBox.shrink();
  }

  Widget _buildFlowBody(FlowSurfaceScope scope) {
    final entries = FlowRegistry.bodySections;
    if (entries.length == 1) {
      return entries.first.builder(scope);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          entries.map((entry) => entry.builder(scope)).toList(growable: false),
    );
  }

  void _showOutcomeSnackbar(BuildContext context, FlowChoreOutcome result) {
    final s = S.of(context);
    final accent = KinlyThemeAccess.of(context).extension<KinlySections>()!.flow.accent;
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
        showOnlyCurrentUser &&
                currentUserId != null &&
                filter == FlowListFilter.active
            ? items
                .where((entry) => entry.assigneeUserId == currentUserId)
                .toList(growable: false)
            : items;

    switch (filter) {
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




