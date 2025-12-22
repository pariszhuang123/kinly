// lib/features/today/ui/widgets/today_share_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/kinly_sections.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../../core/ui/kinly_list_tile.dart';
import '../../../../../core/ui/kinly_tab_bar.dart';
import '../../../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../../../core/ui/feedback/kinly_info_banner.dart';
import '../../../../../core/ui/enums/kinly_banner_type.dart';
import '../../../../../core/ui/section_container.dart';
import '../../../../../generated/l10n.dart';
import '../../../domain/models.dart';
import '../../../../../core/theme/section_assets.dart';
import '../today_section_tabs.dart';

class TodayShareSection extends StatefulWidget {
  const TodayShareSection({
    super.key,
    required this.owed,
    required this.paidToMe,
    required this.drafts,
    required this.onOwedTap,
    required this.onPaidToMeTap,
    required this.onDraftTap,
    required this.onSeeAllDraftsTap,
    this.errorMessage,
  });

  final List<TodayShareOwed> owed;
  final List<TodaySharePaidToMe> paidToMe;
  final List<TodayShareDraft> drafts;
  final void Function(TodayShareOwed) onOwedTap;
  final void Function(TodaySharePaidToMe) onPaidToMeTap;
  final void Function(TodayShareDraft) onDraftTap;
  final VoidCallback onSeeAllDraftsTap;
  final String? errorMessage;

  @override
  State<TodayShareSection> createState() => _TodayShareSectionState();
}

class _TodayShareSectionState extends State<TodayShareSection> {
  late TodaySectionTabType _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab =
        TodaySectionTabs.defaultTab(
          hasActive: widget.owed.isNotEmpty,
          hasReceived: widget.paidToMe.isNotEmpty,
          hasDrafts: widget.drafts.isNotEmpty,
        ) ??
        TodaySectionTabType.active; // safe fallback
  }

  @override
  void didUpdateWidget(covariant TodayShareSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final tabs = TodaySectionTabs.available(
      hasActive: widget.owed.isNotEmpty,
      hasReceived: widget.paidToMe.isNotEmpty,
      hasDrafts: widget.drafts.isNotEmpty,
    );

    if (!tabs.contains(_selectedTab)) {
      final defaultTab = TodaySectionTabs.defaultTab(
        hasActive: widget.owed.isNotEmpty,
        hasReceived: widget.paidToMe.isNotEmpty,
        hasDrafts: widget.drafts.isNotEmpty,
      );
      if (defaultTab != null) {
        _selectedTab = defaultTab;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sections = theme.extension<KinlySections>()!;
    final spacing = theme.extension<Spacing>();
    final s = S.of(context);
    final colors = sections.share;

    final tabs = TodaySectionTabs.available(
      hasActive: widget.owed.isNotEmpty,
      hasReceived: widget.paidToMe.isNotEmpty,
      hasDrafts: widget.drafts.isNotEmpty,
    );

    // If there are no owed items and no drafts, don't render this section.
    if (tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    const shareIconSize = 32.0;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.errorMessage != null)
          Padding(
            padding: EdgeInsets.only(bottom: spacing?.sm ?? 8),
            child: KinlyInfoBanner(
              message: s.todayShareError,
              type: KinlyBannerType.error,
            ),
          ),
        if (tabs.length > 1) ...[
          KinlyTabBar<TodaySectionTabType>(
            tabs: {
              if (widget.owed.isNotEmpty)
                TodaySectionTabType.active: s.todayShareTabActive,
              if (widget.paidToMe.isNotEmpty)
                TodaySectionTabType.received: s.todayShareTabPaidToMe,
              if (widget.drafts.isNotEmpty)
                TodaySectionTabType.drafts: s.todayShareTabDrafts,
            },
            selected: _selectedTab,
            emptySelectionAllowed: false,
            onChanged: (tab) {
              // tab is TodaySectionTabType?; but with emptySelectionAllowed=false
              // we can safely assert non-null:
              if (tab == null) return; // extra safety
              setState(() {
                _selectedTab = tab;
              });
            },
          ),
          SizedBox(height: spacing?.md ?? 12),
        ],
        _buildTabContent(context, colors: colors, strings: s),
      ],
    );

    return SectionContainer(
      title: s.todayShareSectionTitle,
      colors: colors,
      leading: SectionAssets.share.build(
        color: colors.icon,
        size: shareIconSize,
      ),
      child: content,
    );
  }

  Widget _buildTabContent(
    BuildContext context, {
    required SectionColors colors,
    required S strings,
  }) {
    switch (_selectedTab) {
      case TodaySectionTabType.active:
        return _OwedList(
          owed: widget.owed,
          onTap: widget.onOwedTap,
          colors: colors,
        );
      case TodaySectionTabType.received:
        return _PaidToMeList(
          entries: widget.paidToMe,
          onTap: widget.onPaidToMeTap,
          colors: colors,
          strings: strings,
        );
      case TodaySectionTabType.drafts:
        return _DraftList(
          drafts: widget.drafts,
          onTap: widget.onDraftTap,
          onSeeAllTap: widget.onSeeAllDraftsTap,
          colors: colors,
          strings: strings,
        );
    }
  }
}

class _OwedList extends StatelessWidget {
  const _OwedList({
    required this.owed,
    required this.onTap,
    required this.colors,
  });

  final List<TodayShareOwed> owed;
  final void Function(TodayShareOwed) onTap;
  final SectionColors colors;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    final s = S.of(context);

    return Column(
      children: List.generate(owed.length, (index) {
        final entry = owed[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == owed.length - 1 ? 0 : spacing.sm,
          ),
          child: KinlyListTile(
            leading: KinlyCircleAvatar(
              avatarUrl: entry.avatarUrl,
              radius: 20,
              isOwner: entry.isOwner,
            ),
            title: entry.displayName,
            subtitle: s.todayShareActiveSubtitle(entry.items.length),
            trailing: Text(
              _formatCurrency(entry.totalOwedCents),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.icon,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () => onTap(entry),
          ),
        );
      }),
    );
  }
}

class _PaidToMeList extends StatelessWidget {
  const _PaidToMeList({
    required this.entries,
    required this.onTap,
    required this.colors,
    required this.strings,
  });

  final List<TodaySharePaidToMe> entries;
  final void Function(TodaySharePaidToMe) onTap;
  final SectionColors colors;
  final S strings;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;

    return Column(
      children: List.generate(entries.length, (index) {
        final entry = entries[index];
        final subtitle = entry.hasUnseen
            ? strings.todaySharePaidUnseen(entry.unseenCount)
            : strings.todaySharePaidSubtitle;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == entries.length - 1 ? 0 : spacing.sm,
          ),
          child: KinlyListTile(
            leading: KinlyCircleAvatar(
              avatarUrl: null,
              radius: 20,
            ),
            title: entry.debtorUsername,
            subtitle: subtitle,
            trailing: Text(
              _formatCurrency(entry.totalPaidCents),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.icon,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () => onTap(entry),
          ),
        );
      }),
    );
  }
}

class _DraftList extends StatelessWidget {
  const _DraftList({
    required this.drafts,
    required this.onTap,
    required this.colors,
    this.onSeeAllTap,
    this.strings,
  });

  final List<TodayShareDraft> drafts;
  final void Function(TodayShareDraft) onTap;
  final SectionColors colors;
  final VoidCallback? onSeeAllTap;
  final S? strings;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    final s = strings ?? S.of(context);
    const maxVisible = 3;
    final visibleDrafts = drafts.take(maxVisible).toList(growable: false);

    return Column(
      children: [
        for (var i = 0; i < visibleDrafts.length; i++) ...[
          KinlyListTile(
            title: visibleDrafts[i].description,
            trailing: Text(
              _formatCurrency(visibleDrafts[i].amountCents),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.icon,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () => onTap(visibleDrafts[i]),
          ),
          if (i != visibleDrafts.length - 1) SizedBox(height: spacing.sm),
        ],
        if (onSeeAllTap != null && drafts.length > maxVisible)
          Padding(
            padding: EdgeInsets.only(top: spacing.sm),
            child: Align(
              alignment: Alignment.center,
              child: KinlyOutlinedButton.text(
                compact: true,
                onPressed: onSeeAllTap!,
                label: _replaceCountPlaceholder(
                  s.todayFlowSeeAll(drafts.length),
                  drafts.length.toString(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String _formatCurrency(int amountCents) {
  final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
  return formatter.format(amountCents / 100.0);
}

String _replaceCountPlaceholder(String text, String replacement) {
  final pattern = RegExp(r'#|\\d+', unicode: true);
  return pattern.hasMatch(text)
      ? text.replaceFirst(pattern, replacement)
      : '$text ($replacement)';
}
