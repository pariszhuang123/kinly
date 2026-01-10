import 'package:flutter/widgets.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/badges/kinly_badge.dart';
import '../../../../core/ui/kinly_list_tile.dart';
import '../../../../core/ui/kinly_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/ui/kinly_theme_access.dart';

class TodayEmptyStateCard extends StatelessWidget {
  const TodayEmptyStateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);

    // Use Flow section colors (or create a neutral “Today” section later)
    final colors = sections.flow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KinlyListTile(
          leading: Icon(
            KinlyIcons.selfImprovementRounded,
            color: colors.accent,
          ),
          title: s.todayEmptyCardTitle,
          semanticsLabel: '${s.todayEmptyCardTitle}, ${s.todayEmptyCardBadge}',
          trailing: KinlyBadge(
            label: s.todayEmptyCardBadge,
            accentColor: colors.accent,
          ),
          onTap: () {},
        ),
        SizedBox(height: spacing.sm),
        Text(
          s.todayEmptyBody,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
