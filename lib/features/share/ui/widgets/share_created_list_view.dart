// lib/features/share/ui/widgets/share_created_list_view.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../core/ui/kinly_list_tile.dart';
import '../../../../core/ui/kinly_empty_state.dart';
import '../../../../core/ui/feedback/kinly_info_banner.dart';
import '../../../../core/ui/enums/kinly_banner_type.dart';
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
    final spacing = Theme.of(context).extension<Spacing>();
    final gap = spacing?.md ?? 12.0;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: entries.length,
        separatorBuilder: (_, __) => SizedBox(height: gap),
        itemBuilder: (context, index) {
          final entry = entries[index];
          return _ShareCreatedTile(
            entry: entry,
            shareColors: shareColors,
            onTap: () => onEntryTap(entry),
          );
        },
      ),
    );
  }
}

class _ShareCreatedTile extends StatelessWidget {
  const _ShareCreatedTile({
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KinlyListTile(
          title: entry.description,
          subtitle:
              entry.isActive ? progressLabel : s.shareCreatedListDraftSubtitle,
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (badge != null) ...[badge, SizedBox(height: spacing?.xs ?? 6)],
              Text(
                amountLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: shareColors?.icon ?? theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
        if (entry.isActive) ...[
          SizedBox(height: spacing?.xs ?? 6),
          LinearProgressIndicator(
            value:
                entry.totalShares == 0
                    ? 0
                    : entry.paidShares / entry.totalShares,
            minHeight: 8,
            backgroundColor:
                shareColors?.card ?? theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(
              shareColors?.accent ?? theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: spacing?.xs ?? 6),
          Text(
            amountProgress,
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  shareColors?.icon.withValues(alpha: 0.7) ??
                  theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
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
    final s = S.of(context);

    return KinlyEmptyState(
      title: title,
      body: subtitle,
      ctaLabel: s.shareCreateSubmit,
      onCtaTap: onCreateTap,
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
    final spacing = theme.extension<Spacing>();
    final s = S.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          KinlyInfoBanner(message: message, type: KinlyBannerType.error),
          SizedBox(height: spacing?.md ?? 16),
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
    final spacing = Theme.of(context).extension<Spacing>();
    final corners = Theme.of(context).extension<Corners>();
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing?.md ?? 12,
        vertical: spacing?.xs ?? 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(corners?.large ?? 16),
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
