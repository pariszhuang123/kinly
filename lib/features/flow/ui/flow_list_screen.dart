import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/chores/models.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/badges/kinly_badge.dart';
import '../../../core/ui/buttons/kinly_fab.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../generated/l10n.dart';
import 'flow_list_filter.dart';
import '../bloc/flow_list_bloc.dart';
import '../domain/flow_chore_outcome.dart';

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
    final theme = Theme.of(context);
    final sections = theme.extension<KinlySections>();
    final flowColors = sections?.flow;
    final spacing = theme.extension<Spacing>();
    final s = S.of(context);

    return Scaffold(
      backgroundColor: flowColors?.background ?? theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: flowColors?.background,
        title: Text(s.quick_add_flow_title),
      ),
      floatingActionButton: KinlyFab(
        onPressed: () => _openChore(context),
        heroTag: 'flow_list_fab',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
          child: BlocBuilder<FlowListBloc, FlowListState>(
            builder: (context, state) {
              switch (state.status) {
                case FlowListStatus.loading:
                  return const Center(child: KinlyLoader(size: 40));
                case FlowListStatus.failure:
                  return _FlowListError(
                    message: state.errorMessage ?? s.flowListError,
                    onRetry:
                        () => context.read<FlowListBloc>().add(
                          const FlowListRequested(),
                        ),
                  );
                case FlowListStatus.success:
                  final filteredItems = _filteredItems(state.items);
                  if (filteredItems.isEmpty) {
                    return _FlowListEmpty(onAddTap: () => _openChore(context));
                  }
                  return _FlowList(
                    items: filteredItems,
                    ownerUserId: state.ownerUserId,
                    onRefresh: () => _handleRefresh(context),
                    onItemTap:
                        (entry) => _openChore(context, choreId: entry.id),
                  );
                case FlowListStatus.initial:
                  return const SizedBox.shrink();
              }
            },
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

  Future<void> _openChore(BuildContext context, {String? choreId}) async {
    final path =
        choreId == null
            ? AppRoutes.flowChoreCreate
            : AppRoutes.flowChoreEditPath(choreId);
    final result = await context.push(path);
    if (result is FlowChoreOutcome && context.mounted) {
      final s = S.of(context);
      final accent = Theme.of(context).extension<KinlySections>()?.flow.accent;
      if (result.isUpdate) {
        KinlySnackBar.showSuccess(
          context,
          s.flowChoreUpdateSuccess,
          accentColor: accent,
        );
      } else if (!result.isDeleted && !result.isCompleted) {
        KinlySnackBar.showSuccess(
          context,
          s.flowChoreCreateSuccess,
          accentColor: accent,
        );
      }
      context.read<FlowListBloc>().add(const FlowListRefreshed());
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

class _FlowList extends StatelessWidget {
  const _FlowList({
    required this.items,
    required this.ownerUserId,
    required this.onRefresh,
    required this.onItemTap,
  });

  final List<ChoreListEntry> items;
  final String? ownerUserId;
  final Future<void> Function() onRefresh;
  final void Function(ChoreListEntry) onItemTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sections = theme.extension<KinlySections>();
    final flowColors = sections?.flow;
    final spacing = theme.extension<Spacing>();
    final gap = spacing?.md ?? 12.0;
    final bottomSpacer = spacing?.lg ?? 16.0;

    return KinlyScrollFade(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsetsDirectional.only(bottom: bottomSpacer),
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: gap),
          itemBuilder: (context, index) {
            final entry = items[index];
            return _FlowListTile(
              entry: entry,
              flowColors: flowColors,
              ownerUserId: ownerUserId,
              onTap: () => onItemTap(entry),
            );
          },
        ),
      ),
    );
  }
}

class _FlowListTile extends StatelessWidget {
  const _FlowListTile({
    required this.entry,
    required this.flowColors,
    required this.ownerUserId,
    required this.onTap,
  });

  final ChoreListEntry entry;
  final SectionColors? flowColors;
  final String? ownerUserId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);
    final spacing = theme.extension<Spacing>();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDateLocal = DateTime(
      entry.startDate.toLocal().year,
      entry.startDate.toLocal().month,
      entry.startDate.toLocal().day,
    );
    final isOverdue = entryDateLocal.isBefore(today);
    final dateText = DateFormat.yMMMd().format(entryDateLocal);

    return Material(
      color: flowColors?.card ?? colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(entry.name, style: theme.textTheme.titleMedium),
                  ),
                  _AssigneeAvatar(
                    entry: entry,
                    flowColors: flowColors,
                    ownerUserId: ownerUserId,
                  ),
                ],
              ),
              SizedBox(height: spacing?.sm ?? 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: flowColors?.accent ?? colorScheme.primary,
                  ),
                  SizedBox(width: spacing?.xs ?? 6),
                  Text(
                    dateText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isOverdue
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (isOverdue) ...[
                    SizedBox(width: spacing?.xs ?? 6),
                    KinlyBadge(label: s.flowListOverdueLabel, destructive: true),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssigneeAvatar extends StatelessWidget {
  const _AssigneeAvatar({
    required this.entry,
    this.flowColors,
    this.ownerUserId,
  });

  final ChoreListEntry entry;
  final SectionColors? flowColors;
  final String? ownerUserId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    if (entry.assigneeUserId == null) {
      return KinlyBadge(label: s.flowListDraftLabel, compact: false);
    }

    return KinlyCircleAvatar(
      avatarUrl: entry.assigneeAvatarStoragePath,
      radius: 20,
      isOwner: ownerUserId != null && entry.assigneeUserId == ownerUserId,
    );
  }
}

class _FlowListEmpty extends StatelessWidget {
  const _FlowListEmpty({required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

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
    final theme = Theme.of(context);
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
