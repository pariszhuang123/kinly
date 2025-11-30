import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/kinly_tab_bar.dart';
import '../../../../core/ui/kinly_list_tile.dart';
import '../../../../core/ui/kinly_empty_state.dart';
import '../../../../core/ui/feedback/kinly_info_banner.dart';
import '../../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../../core/ui/section_container.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/today_bloc.dart';
import '../../domain/models.dart';

enum _ShareTabType { active, drafts }

class TodayShareSectionContainer extends StatelessWidget {
  const TodayShareSectionContainer({
    super.key,
    required this.onOwedTap,
    required this.onDraftTap,
    required this.onSeeAllDraftsTap,
  });

  final void Function(TodayShareOwed) onOwedTap;
  final void Function(TodayShareDraft) onDraftTap;
  final VoidCallback onSeeAllDraftsTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodayBloc, TodayState>(
      buildWhen:
          (previous, current) =>
              previous.shareOwed != current.shareOwed ||
              previous.shareDrafts != current.shareDrafts ||
              previous.shareErrorMessage != current.shareErrorMessage ||
              previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading && !state.hasShareContent) {
          return const Center(child: KinlyLoader(size: 40));
        }
        if (!state.hasShareContent) {
          return _ShareEmptyState(message: S.of(context).todayShareEmptyState);
        }
        return TodayShareSection(
          owed: state.shareOwed,
          drafts: state.shareDrafts,
          errorMessage: state.shareErrorMessage,
          onOwedTap: onOwedTap,
          onDraftTap: onDraftTap,
          onSeeAllDraftsTap: onSeeAllDraftsTap,
        );
      },
    );
  }
}

class TodayShareSection extends StatefulWidget {
  const TodayShareSection({
    super.key,
    required this.owed,
    required this.drafts,
    required this.onOwedTap,
    required this.onDraftTap,
    required this.onSeeAllDraftsTap,
    this.errorMessage,
  });

  final List<TodayShareOwed> owed;
  final List<TodayShareDraft> drafts;
  final void Function(TodayShareOwed) onOwedTap;
  final void Function(TodayShareDraft) onDraftTap;
  final VoidCallback onSeeAllDraftsTap;
  final String? errorMessage;

  @override
  State<TodayShareSection> createState() => _TodayShareSectionState();
}

class _TodayShareSectionState extends State<TodayShareSection> {
  late _ShareTabType _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = _defaultTab;
  }

  @override
  void didUpdateWidget(covariant TodayShareSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final tabs = _availableTabs;
    if (!tabs.contains(_selectedTab)) {
      _selectedTab = _defaultTab;
    }
  }

  _ShareTabType get _defaultTab {
    if (widget.owed.isNotEmpty) return _ShareTabType.active;
    return _ShareTabType.drafts;
  }

  List<_ShareTabType> get _availableTabs {
    final tabs = <_ShareTabType>[];
    if (widget.owed.isNotEmpty) tabs.add(_ShareTabType.active);
    if (widget.drafts.isNotEmpty) tabs.add(_ShareTabType.drafts);
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sections = theme.extension<KinlySections>()!;
    final spacing = theme.extension<Spacing>();
    final s = S.of(context);
    final colors = sections.share;
    final tabs = _availableTabs;

    if (tabs.isEmpty) {
      return _ShareEmptyState(
        message: s.todayShareEmptyState,
        onSeeAllDraftsTap: widget.onSeeAllDraftsTap,
      );
    }

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
          KinlyTabBar<_ShareTabType>(
            tabs: {
              if (widget.owed.isNotEmpty)
                _ShareTabType.active: s.todayShareTabActive,
              if (widget.drafts.isNotEmpty)
                _ShareTabType.drafts: s.todayShareTabDrafts,
            },
            selected: _selectedTab,
            onChanged: (tab) => setState(() => _selectedTab = tab),
          ),
          SizedBox(height: spacing?.md ?? 12),
        ],
        _buildTabContent(
          context,
          colors: colors,
          strings: s,
        ),
      ],
    );

    return SectionContainer(
      title: s.todayShareSectionTitle,
      colors: colors,
      leading: SvgPicture.asset(
        'assets/icons/feature/Share.svg',
        width: 32,
        height: 32,
        colorFilter: ColorFilter.mode(colors.icon, BlendMode.srcIn),
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
      case _ShareTabType.active:
        return _OwedList(
          owed: widget.owed,
          onTap: widget.onOwedTap,
          colors: colors,
        );
      case _ShareTabType.drafts:
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
                label: s.todayFlowSeeAll(drafts.length),
              ),
            ),
          ),
      ],
    );
  }
}

class _ShareEmptyState extends StatelessWidget {
  const _ShareEmptyState({
    required this.message,
    this.onSeeAllDraftsTap,
  });

  final String message;
  final VoidCallback? onSeeAllDraftsTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sections = theme.extension<KinlySections>()!;
    final colors = sections.share;
    final s = S.of(context);

    return SectionContainer(
      title: S.of(context).todayShareSectionTitle,
      colors: colors,
      leading: SvgPicture.asset(
        'assets/icons/feature/Share.svg',
        width: 32,
        height: 32,
        colorFilter: ColorFilter.mode(colors.icon, BlendMode.srcIn),
      ),
      child: KinlyEmptyState(
        title: message,
        icon: SvgPicture.asset(
          'assets/icons/feature/Share.svg',
          width: 40,
          height: 40,
          colorFilter: ColorFilter.mode(colors.icon, BlendMode.srcIn),
        ),
        ctaLabel: onSeeAllDraftsTap != null ? s.todayShareSeeAll : null,
        onCtaTap: onSeeAllDraftsTap,
      ),
    );
  }
}

String _formatCurrency(int amountCents) {
  final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
  return formatter.format(amountCents / 100.0);
}
