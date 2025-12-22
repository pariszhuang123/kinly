// lib/features/today/ui/widgets/today_flow_section.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/kinly_sections.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/section_container.dart';
import '../../../../../core/ui/kinly_list_tile.dart';
import '../../../../../core/ui/kinly_tab_bar.dart';
import '../../../../../generated/l10n.dart';
import '../../../domain/models.dart';
import '../../../../flow/ui/flow_list_filter.dart';
import '../../../../../core/theme/section_assets.dart';
import '../today_section_tabs.dart';
import '../../../../../core/ui/badges/kinly_badge.dart';

class TodayFlowSection extends StatefulWidget {
  const TodayFlowSection({
    super.key,
    required this.activeTasks,
    required this.draftTasks,
    required this.onTaskTap,
    required this.onSeeAllTap,
  });

  final List<TodayFlowTask> activeTasks;
  final List<TodayFlowTask> draftTasks;
  final void Function(TodayFlowTask) onTaskTap;
  final void Function(FlowListFilter filter) onSeeAllTap;

  @override
  State<TodayFlowSection> createState() => _TodayFlowSectionState();
}

class _TodayFlowSectionState extends State<TodayFlowSection> {
  late TodaySectionTabType _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab =
        TodaySectionTabs.defaultTab(
          hasActive: widget.activeTasks.isNotEmpty,
          hasReceived: false,
          hasDrafts: widget.draftTasks.isNotEmpty,
        ) ??
        TodaySectionTabType.active; // fallback, won't render if both empty
  }

  @override
  void didUpdateWidget(covariant TodayFlowSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final tabs = TodaySectionTabs.available(
      hasActive: widget.activeTasks.isNotEmpty,
      hasReceived: false,
      hasDrafts: widget.draftTasks.isNotEmpty,
    );

    if (!tabs.contains(_selectedTab)) {
      final defaultTab = TodaySectionTabs.defaultTab(
        hasActive: widget.activeTasks.isNotEmpty,
        hasReceived: false,
        hasDrafts: widget.draftTasks.isNotEmpty,
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
    final colors = sections.flow;

    final tabs = TodaySectionTabs.available(
      hasActive: widget.activeTasks.isNotEmpty,
      hasReceived: false,
      hasDrafts: widget.draftTasks.isNotEmpty,
    );

    // No active or draft tasks → hide section
    if (tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    const flowIconSize = 28.0;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tabs.length > 1) ...[
          KinlyTabBar<TodaySectionTabType>(
            tabs: {
              if (widget.activeTasks.isNotEmpty)
                TodaySectionTabType.active: s.todayFlowTabActive,
              if (widget.draftTasks.isNotEmpty)
                TodaySectionTabType.drafts: s.todayFlowTabDrafts,
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
        _buildTabContent(context, colors: colors, spacing: spacing, strings: s),
      ],
    );

    return SectionContainer(
      title: s.todayFlowSectionTitle,
      colors: colors,
      leading: SectionAssets.flow.build(
        color: colors.icon,
        size: flowIconSize,
      ),
      child: content,
    );
  }

  Widget _buildTabContent(
    BuildContext context, {
    required SectionColors colors,
    required Spacing? spacing,
    required S strings,
  }) {
    switch (_selectedTab) {
      case TodaySectionTabType.active:
        return _FlowTaskListWithSeeAll(
          tasks: widget.activeTasks,
          colors: colors,
          spacing: spacing,
          onTaskTap: widget.onTaskTap,
          onSeeAllTap: widget.onSeeAllTap,
          filter: FlowListFilter.active,
          strings: strings,
        );
      case TodaySectionTabType.received:
        return const SizedBox.shrink();
      case TodaySectionTabType.drafts:
        return _FlowTaskListWithSeeAll(
          tasks: widget.draftTasks,
          colors: colors,
          spacing: spacing,
          onTaskTap: widget.onTaskTap,
          onSeeAllTap: widget.onSeeAllTap,
          filter: FlowListFilter.drafts,
          strings: strings,
        );
    }
  }
}

class _FlowTaskListWithSeeAll extends StatelessWidget {
  const _FlowTaskListWithSeeAll({
    required this.tasks,
    required this.colors,
    required this.spacing,
    required this.onTaskTap,
    required this.onSeeAllTap,
    required this.filter,
    required this.strings,
  });

  final List<TodayFlowTask> tasks;
  final SectionColors colors;
  final Spacing? spacing;
  final void Function(TodayFlowTask) onTaskTap;
  final void Function(FlowListFilter) onSeeAllTap;
  final FlowListFilter filter;
  final S strings;

  @override
  Widget build(BuildContext context) {
    const maxVisible = 3;
    final showSeeAll = tasks.length > maxVisible;

    return Column(
      children: [
        _TaskList(
          tasks: tasks,
          colors: colors,
          spacing: spacing,
          onTaskTap: onTaskTap,
          maxVisible: maxVisible,
        ),
        if (showSeeAll)
          _SeeAllButton(
            colors: colors,
            onTap: () => onSeeAllTap(filter),
            label: _replaceCountPlaceholder(
              strings.todayFlowSeeAll(tasks.length),
              tasks.length.toString(),
            ),
          ),
      ],
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    required this.colors,
    required this.spacing,
    required this.onTaskTap,
    this.maxVisible,
  });

  final List<TodayFlowTask> tasks;
  final SectionColors colors;
  final Spacing? spacing;
  final void Function(TodayFlowTask) onTaskTap;
  final int? maxVisible;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final visibleTasks =
        maxVisible != null
            ? tasks.take(maxVisible!).toList(growable: false)
            : tasks;

    return Column(
      children: [
        for (final task in visibleTasks) ...[
          KinlyListTile(
            title: task.title,
            semanticsLabel:
                task.isNewToday ? '${task.title}, ${s.todayFlowBadgeNew}' : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (task.isNewToday)
                  KinlyBadge(
                    label: s.todayFlowBadgeNew,
                    accentColor: colors.accent,
                  ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: 0.7,
                  ),
                ),
              ],
            ),
            onTap: () => onTaskTap(task),
          ),
          if (task != visibleTasks.last) SizedBox(height: spacing?.sm ?? 8),
        ],
      ],
    );
  }
}

class _SeeAllButton extends StatelessWidget {
  const _SeeAllButton({
    required this.colors,
    required this.onTap,
    required this.label,
  });

  final SectionColors colors;
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: onTap,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

String _replaceCountPlaceholder(String text, String replacement) {
  final pattern = RegExp(r'#|\\d+', unicode: true);
  return pattern.hasMatch(text)
      ? text.replaceFirst(pattern, replacement)
      : '$text ($replacement)';
}
