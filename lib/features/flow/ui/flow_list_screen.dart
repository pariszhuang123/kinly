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
import '../../../generated/l10n.dart';
import 'flow_list_filter.dart';
import '../bloc/flow_list_bloc.dart';
import '../domain/flow_chore_outcome.dart';

class FlowListScreen extends StatelessWidget {
  const FlowListScreen({super.key, this.filter = FlowListFilter.all});

  final FlowListFilter filter;

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: flowColors?.accent ?? theme.colorScheme.primary,
        onPressed: () => _openChore(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing?.lg ?? 16),
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
      context.read<FlowListBloc>().add(const FlowListRefreshed());
    }
  }

  List<ChoreListEntry> _filteredItems(List<ChoreListEntry> items) {
    switch (filter) {
      case FlowListFilter.active:
        return items.where((entry) => entry.assigneeUserId != null).toList();
      case FlowListFilter.drafts:
        return items.where((entry) => entry.assigneeUserId == null).toList();
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

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
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
          padding: EdgeInsets.all(spacing?.lg ?? 16),
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
                    Text(
                      s.flowListOverdueLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
    final theme = Theme.of(context);

    if (entry.assigneeUserId == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: (flowColors?.accent ?? theme.colorScheme.primary).withValues(
            alpha: 0.2,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          s.flowListDraftLabel,
          style: theme.textTheme.labelMedium?.copyWith(
            color: flowColors?.accent ?? theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
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
          ElevatedButton(
            onPressed: onAddTap,
            child: Text(s.flowChoreSubmitCreate),
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
          ElevatedButton(
            onPressed: onRetry,
            child: Text(S.of(context).flowChoreRetry),
          ),
        ],
      ),
    );
  }
}
