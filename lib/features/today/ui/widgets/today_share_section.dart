import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/section_container.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/today_bloc.dart';
import '../../domain/models.dart';

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

class TodayShareSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final sections = Theme.of(context).extension<KinlySections>()!;
    final spacing = Theme.of(context).extension<Spacing>();
    final s = S.of(context);
    final colors = sections.share;
    final tabs = _buildTabs(s, colors);

    if (tabs.isEmpty) {
      return _ShareEmptyState(message: s.todayShareEmptyState);
    }

    final content = Column(
      children: [
        if (errorMessage != null)
          Padding(
            padding: EdgeInsets.only(bottom: spacing?.sm ?? 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                s.todayShareError,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.icon),
              ),
            ),
          ),
        if (tabs.length == 1)
          tabs.single.builder(context)
        else
          DefaultTabController(
            length: tabs.length,
            child: Builder(
              builder: (context) {
                final controller = DefaultTabController.of(context);
                return Column(
                  children: [
                    TabBar(
                      controller: controller,
                      tabs: tabs.map((tab) => Tab(text: tab.label)).toList(),
                      labelColor: colors.icon,
                      indicatorColor: colors.accent,
                      unselectedLabelColor: colors.icon.withValues(alpha: 0.6),
                    ),
                    SizedBox(height: spacing?.sm ?? 8),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) {
                        final tab = tabs[controller.index];
                        return tab.builder(context);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );

    return SectionContainer(
      title: s.todayShareSectionTitle,
      colors: colors,
      child: content,
    );
  }

  List<_ShareTab> _buildTabs(S s, SectionColors colors) {
    final tabs = <_ShareTab>[];
    if (owed.isNotEmpty) {
      tabs.add(
        _ShareTab(
          label: s.todayShareTabActive,
          builder: (context) => _OwedList(owed: owed, onTap: onOwedTap),
        ),
      );
    }
    if (drafts.isNotEmpty) {
      tabs.add(
        _ShareTab(
          label: s.todayShareTabDrafts,
          builder: (context) {
            return _DraftList(
              drafts: drafts,
              onTap: onDraftTap,
              onSeeAllTap: onSeeAllDraftsTap,
              colors: colors,
            );
          },
        ),
      );
    }
    return tabs;
  }
}

class _OwedList extends StatelessWidget {
  const _OwedList({required this.owed, required this.onTap});

  final List<TodayShareOwed> owed;
  final void Function(TodayShareOwed) onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    final s = S.of(context);
    return Column(
      children: [
        for (final entry in owed) ...[
          _ShareCard(
            leading: KinlyCircleAvatar(
              avatarUrl: entry.avatarUrl,
              radius: 20,
              isOwner: entry.isOwner,
            ),
            title: entry.displayName,
            subtitle: s.todayShareActiveSubtitle(entry.items.length),
            amountLabel: _formatCurrency(entry.totalOwedCents),
            onTap: () => onTap(entry),
          ),
          if (entry != owed.last) SizedBox(height: spacing.sm),
        ],
      ],
    );
  }
}

class _DraftList extends StatelessWidget {
  const _DraftList({
    required this.drafts,
    required this.onTap,
    required this.colors,
    this.onSeeAllTap,
    this.maxVisible = 3,
  });

  final List<TodayShareDraft> drafts;
  final void Function(TodayShareDraft) onTap;
  final SectionColors colors;
  final VoidCallback? onSeeAllTap;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    final s = S.of(context);
    final visibleDrafts = drafts.take(maxVisible).toList(growable: false);
    return Column(
      children: [
        for (final draft in visibleDrafts) ...[
          _ShareCard(
            title: draft.description,
            amountLabel: _formatCurrency(draft.amountCents),
            onTap: () => onTap(draft),
          ),
          if (draft != visibleDrafts.last) SizedBox(height: spacing.sm),
        ],
        if (onSeeAllTap != null && drafts.length > maxVisible)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: onSeeAllTap,
                child: Text(
                  s.todayFlowSeeAll(drafts.length),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.icon,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ShareCard extends StatelessWidget {
  const _ShareCard({
    required this.title,
    required this.amountLabel,
    required this.onTap,
    this.leading,
    this.subtitle,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final String amountLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 12)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                amountLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareEmptyState extends StatelessWidget {
  const _ShareEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final sections = Theme.of(context).extension<KinlySections>()!;
    return SectionContainer(
      title: S.of(context).todayShareSectionTitle,
      colors: sections.share,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _ShareTab {
  const _ShareTab({required this.label, required this.builder});

  final String label;
  final WidgetBuilder builder;
}

String _formatCurrency(int amountCents) {
  final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
  return formatter.format(amountCents / 100.0);
}
