// lib/features/share/ui/widgets/share_created_list_view.dart
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/opacity.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/badges/kinly_badge.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../core/ui/kinly_list_tile.dart';
import '../../../../core/ui/feedback/kinly_info_banner.dart';
import '../../../../core/ui/enums/kinly_banner_type.dart';
import '../../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../../core/ui/kinly_refresh_indicator.dart';
import '../../../../core/ui/kinly_linear_progress_indicator.dart';
import '../../../../generated/l10n.dart';
import '../share_period_label.dart';
import '../../bloc/share_created_list_bloc/share_created_list_bloc.dart';
import '../../../../core/ui/kinly_theme_access.dart';

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
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
    final gap = spacing?.md ?? 12.0;
    final bottomSpacer = spacing?.lg ?? 16.0;
    return KinlyScrollFade(
      child: KinlyRefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsetsDirectional.only(bottom: bottomSpacer),
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
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final opacities = theme.extension<KinlyOpacity>()!;
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
    final periodLabel =
        entry.isRecurring
            ? sharePeriodLabel(
              recurrenceEvery: entry.recurrenceEvery,
              recurrenceUnit: entry.recurrenceUnit,
              startDate: entry.startDate,
              strings: s,
            )
            : null;

    final badgeColor = shareColors?.accent ?? theme.colorScheme.secondary;
    final shareStatus = _ShareStatus.resolve(entry);

    final paidBadge = KinlyBadge(
      label: s.shareCreatedListPaidBadge,
      compact: false,
      backgroundColor: badgeColor,
      foregroundColor: theme.colorScheme.onPrimary,
    );

    final String? subtitle = _buildSubtitle(
      entry,
      shareStatus: shareStatus,
      progressLabel: progressLabel,
      draftLabel: s.shareCreatedListDraftSubtitle,
      periodLabel: periodLabel,
    );

    final double progressValue =
        entry.amountCents == 0
            ? 0
            : (entry.paidAmountCents / entry.amountCents)
                .clamp(0.0, 1.0)
                .toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KinlyListTile(
          title: entry.description,
          subtitle: subtitle,
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
        if (shareStatus.isPaidOff || shareStatus.isDraft) ...[
          SizedBox(height: spacing?.xs ?? 6),
          if (shareStatus.isPaidOff) paidBadge,
          if (shareStatus.isDraft)
            KinlyBadge(label: s.shareCreatedListDraftBadge, compact: false),
        ],
        if (entry.isActive && !entry.allPaid) ...[
          SizedBox(height: spacing?.xs ?? 6),
          KinlyLinearProgressIndicator(
            value: progressValue,
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
                  shareColors?.icon.withValues(alpha: opacities.alphaFaint) ??
                  theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  String? _buildSubtitle(
    ShareCreatedListEntry entry, {
    required _ShareStatus shareStatus,
    required String progressLabel,
    required String draftLabel,
    required String? periodLabel,
  }) {
    final baseLabel =
        shareStatus.isPaidOff || shareStatus.isDraft
            ? null
            : (entry.isActive ? progressLabel : draftLabel);
    if (periodLabel == null) {
      return baseLabel;
    }
    if (baseLabel == null) {
      return periodLabel;
    }
    return '$periodLabel\n$baseLabel';
  }
}

class _ShareStatus {
  const _ShareStatus({required this.isPaidOff, required this.isDraft});

  final bool isPaidOff;
  final bool isDraft;

  static _ShareStatus resolve(ShareCreatedListEntry entry) {
    return _ShareStatus(
      isPaidOff: entry.isActive && entry.allPaid,
      isDraft: entry.isDraft,
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
    final theme = KinlyThemeAccess.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
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
    final theme = KinlyThemeAccess.of(context);
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
