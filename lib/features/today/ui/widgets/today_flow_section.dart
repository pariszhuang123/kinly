import 'package:flutter/material.dart';
import '../../../../core/ui/section_container.dart';
import '../../../../core/ui/section_list_card.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/models.dart';

class TodayFlowSection extends StatelessWidget {
  final List<TodayFlowTask> tasks;
  final void Function(TodayFlowTask) onTaskTap;
  final VoidCallback onSeeAllTap;

  const TodayFlowSection({
    super.key,
    required this.tasks,
    required this.onTaskTap,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final sections = Theme.of(context).extension<KinlySections>()!;
    final spacing = Theme.of(context).extension<Spacing>();
    final visibleTasks = tasks.length > 3 ? tasks.take(3).toList() : tasks;

    return SectionContainer(
      title: 'Flow',
      colors: sections.flow,
      child: Column(
        children: [
          ...visibleTasks.map(
            (t) => SectionListCard(
              colors: sections.flow,
              icon: Icons.home_repair_service_rounded,
              title: t.title,
              badgeText: t.isNewToday ? 'new today' : null,
              onTap: () => onTaskTap(t),
            ),
          ),
          if (tasks.length > 3)
            Padding(
              padding: EdgeInsets.only(top: spacing?.sm ?? 8),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: onSeeAllTap,
                  child: Text(
                    'See all (${tasks.length})',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: sections.flow.icon,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
