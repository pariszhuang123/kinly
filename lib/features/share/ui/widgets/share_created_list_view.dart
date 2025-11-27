// lib/features/share/ui/widgets/share_created_list_view.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/share_created_list_bloc/share_created_list_bloc.dart';

class ShareCreatedListView extends StatelessWidget {
  const ShareCreatedListView({
    super.key,
    required this.state,
    required this.shareColors,
    required this.onRefreshRequested,
    required this.onCreateTap,
    required this.onEntryTap,
  });

  final ShareCreatedListState state;
  final SectionColors? shareColors;
  final Future<void> Function() onRefreshRequested;
  final VoidCallback onCreateTap;
  final void Function(ShareCreatedListEntry) onEntryTap;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    switch (state.status) {
      case ShareCreatedListStatus.loading:
        return const Center(child: KinlyLoader(size: 40));

      case ShareCreatedListStatus.failure:
        return _ShareCreatedListError(
          message: state.errorMessage ?? s.shareCreatedListError,
          onRetry: onRefreshRequested,
        );

      case ShareCreatedListStatus.success:
        if (state.entries.isEmpty) {
          return _ShareCreatedListEmpty(
            title: s.shareCreatedListEmptyTitle,
            subtitle: s.shareCreatedListEmptySubtitle,
            onCreateTap: onCreateTap,
          );
        }
        return _ShareCreatedList(
          entries: state.entries,
          shareColors: shareColors,
          onRefresh: onRefreshRequested,
          onEntryTap: onEntryTap,
        );

      case ShareCreatedListStatus.initial:
        return const SizedBox.shrink();
    }
  }
}

class _ShareCreatedList extends StatelessWidget {
  const _ShareCreatedList({
    required this.entries,
    required this.shareColors,
    required this.onRefresh,
    required this.onEntryTap,
  });

  final List<ShareCreatedListEntry> entries;
  final SectionColors? shareColors;
  final Future<void> Function() onRefresh;
  final void Function(ShareCreatedListEntry) onEntryTap;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final entry = entries[index];
          return _ShareCreatedCard(
            entry: entry,
            shareColors: shareColors,
            onTap: () => onEntryTap(entry),
          );
        },
      ),
    );
  }
}

class _ShareCreatedCard extends StatelessWidget {
  const _ShareCreatedCard({
    required this.entry,
    required this.shareColors,
    this.onTap,
  });

  final ShareCreatedListEntry entry;
  final SectionColors? shareColors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final s = S.of(context);
    final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);

    final amountLabel = formatter.format(entry.amountCents / 100.0);
    final paidAmountLabel = formatter.format(entry.paidAmountCents / 100.0);
    final progressLabel = s.shareCreatedListActiveSubtitle(
      entry.paidShares,
      entry.totalShares,
    );
    final amountProgress = s.shareCreatedListActiveAmount(
      paidAmountLabel,
      amountLabel,
    );
    final badgeColor = shareColors?.accent ?? theme.colorScheme.secondary;
    final showPaidBadge = entry.isActive && entry.allPaid;
    final showDraftBadge = entry.isDraft;

    Widget? badge;
    if (showPaidBadge) {
      badge = _StatusBadge(
        label: s.shareCreatedListPaidBadge,
        color: badgeColor,
        textColor: theme.colorScheme.onPrimary,
      );
    } else if (showDraftBadge) {
      badge = _StatusBadge(
        label: s.shareCreatedListDraftBadge,
        color: badgeColor.withValues(alpha: 0.15),
        textColor: badgeColor,
      );
    }

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(spacing?.lg ?? 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.description,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (badge != null) badge,
                ],
              ),
              SizedBox(height: spacing?.xs ?? 6),
              Text(
                amountLabel,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing?.sm ?? 8),
              if (entry.isActive) ...[
                Text(
                  progressLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: spacing?.xs ?? 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value:
                        entry.totalShares == 0
                            ? 0
                            : entry.paidShares / entry.totalShares,
                    minHeight: 8,
                    backgroundColor:
                        shareColors?.card ??
                        theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(
                      shareColors?.accent ?? theme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: spacing?.xs ?? 6),
                Text(
                  amountProgress,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ] else ...[
                Text(
                  s.shareCreatedListDraftSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareCreatedListEmpty extends StatelessWidget {
  const _ShareCreatedListEmpty({
    required this.title,
    required this.subtitle,
    required this.onCreateTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          KinlyFilledButton.text(
            fullWidth: true,
            onPressed: onCreateTap,
            label: s.shareCreateSubmit,
          ),
        ],
      ),
    );
  }
}

class _ShareCreatedListError extends StatelessWidget {
  const _ShareCreatedListError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

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
            label: s.shareCreatedListRetry,
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
