import 'package:flutter/material.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/section_container.dart';
import '../../../../core/ui/section_list_card.dart';
import '../../../../generated/l10n.dart';
import '../../domain/models.dart';

class TodayFlowSection extends StatelessWidget {
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
  final VoidCallback onSeeAllTap;

  @override
  Widget build(BuildContext context) {
    final sections = Theme.of(context).extension<KinlySections>()!;
    final spacing = Theme.of(context).extension<Spacing>();
    final s = S.of(context);
    final colors = sections.flow;
    final tabs = _buildTabs(context);

    if (tabs.isEmpty) return const SizedBox.shrink();

    final totalTasks = activeTasks.length + draftTasks.length;
    final showSeeAll = totalTasks > 3;

    if (tabs.length == 1) {
      return SectionContainer(
        title: s.todayFlowSectionTitle,
        colors: colors,
        child: Column(
          children: [
            _TaskList(
              tasks: tabs.single.tasks,
              colors: colors,
              spacing: spacing,
              onTaskTap: onTaskTap,
            ),
            if (showSeeAll)
              _SeeAllButton(
                colors: colors,
                onTap: onSeeAllTap,
                label: S.of(context).todayFlowSeeAll(totalTasks),
              ),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          final controller = DefaultTabController.of(context);
          return SectionContainer(
            title: s.todayFlowSectionTitle,
            colors: colors,
            child: Column(
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
                    return _TaskList(
                      tasks: tab.tasks,
                      colors: colors,
                      spacing: spacing,
                      onTaskTap: onTaskTap,
                    );
                  },
                ),
                if (showSeeAll)
                  _SeeAllButton(
                    colors: colors,
                    onTap: onSeeAllTap,
                    label: S.of(context).todayFlowSeeAll(totalTasks),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<_FlowTab> _buildTabs(BuildContext context) {
    final s = S.of(context);
    final tabs = <_FlowTab>[];
    if (activeTasks.isNotEmpty) {
      tabs.add(_FlowTab(label: s.todayFlowTabActive, tasks: activeTasks));
    }
    if (draftTasks.isNotEmpty) {
      tabs.add(_FlowTab(label: s.todayFlowTabDrafts, tasks: draftTasks));
    }
    return tabs;
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    required this.colors,
    required this.spacing,
    required this.onTaskTap,
  });

  final List<TodayFlowTask> tasks;
  final SectionColors colors;
  final Spacing? spacing;
  final void Function(TodayFlowTask) onTaskTap;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        for (final task in tasks) ...[
          SectionListCard(
            colors: colors,
            icon: Icons.home_repair_service_rounded,
            title: task.title,
            badgeText: task.isNewToday ? s.todayFlowBadgeNew : null,
            onTap: () => onTaskTap(task),
          ),
          if (task != tasks.last) SizedBox(height: spacing?.sm ?? 8),
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
              color: colors.icon,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _FlowTab {
  const _FlowTab({required this.label, required this.tasks});

  final String label;
  final List<TodayFlowTask> tasks;
}
