import 'package:flutter/material.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/section_container.dart';
import '../../../../core/ui/kinly_tap_target.dart';
import '../../../../generated/l10n.dart';

class TodayGratitudeSection extends StatelessWidget {
  const TodayGratitudeSection({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sections = theme.extension<KinlySections>()!;
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return KinlyTapTarget(
      onTap: onTap,
      alignment: AlignmentDirectional.centerStart,
      child: SectionContainer(
        title: s.todayGratitudeSectionTitle,
        colors: sections.pulse,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.todayGratitudeUnreadBody, style: theme.textTheme.bodyMedium),
            SizedBox(height: spacing.sm),
            // Optional: tiny visual cue that it's tappable
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  s.todayGratitudeOpenCta, // e.g. "Open gratitude wall"
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
