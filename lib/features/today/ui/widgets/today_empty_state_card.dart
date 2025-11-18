import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/ui/section_list_card.dart';

class TodayEmptyStateCard extends StatelessWidget {
  const TodayEmptyStateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>()!;

    // Use Flow section colors (or create a neutral “today” section later)
    final colors = sections.flow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionListCard(
          colors: colors,
          icon: Icons.self_improvement_rounded,
          title: S.of(context).todayEmptyCardTitle,
          badgeText: S.of(context).todayEmptyCardBadge,
          onTap: () {
            // Optional: open Hub, reflection, or just do nothing.
          },
        ),
        SizedBox(height: spacing.sm),
        Text(
          S.of(context).todayEmptyBody,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
