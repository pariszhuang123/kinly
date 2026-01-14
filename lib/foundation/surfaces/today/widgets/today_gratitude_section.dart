import 'package:flutter/widgets.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/section_container.dart';
import '../../../../core/ui/kinly_tap_target.dart';
import '../../../../core/ui/kinly_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/ui/kinly_theme_access.dart';

class TodayGratitudeSection extends StatelessWidget {
  const TodayGratitudeSection({
    super.key,
    required this.onHouseTap,
    required this.onPersonalTap,
    this.showPersonal = false,
    this.personalHasUnread = false,
  });

  final VoidCallback onHouseTap;
  final VoidCallback onPersonalTap;
  final bool showPersonal;
  final bool personalHasUnread;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final sections = theme.extension<KinlySections>()!;
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return SectionContainer(
      title: s.todayGratitudeSectionTitle,
      colors: sections.pulse,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.todayGratitudeUnreadBody, style: theme.textTheme.bodyMedium),
          SizedBox(height: spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CTAChip(
                label: s.todayGratitudeHouseCta,
                onTap: onHouseTap,
                icon: KinlyIcons.arrowForwardRounded,
              ),
              if (showPersonal)
                _CTAChip(
                  label: s.todayGratitudePersonalCta,
                  onTap: onPersonalTap,
                  icon: personalHasUnread
                      ? KinlyIcons.notificationsActiveOutlined
                      : KinlyIcons.arrowForwardRounded,
                  emphasize: personalHasUnread,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CTAChip extends StatelessWidget {
  const _CTAChip({
    required this.label,
    required this.onTap,
    required this.icon,
    this.emphasize = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData icon;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colors = theme.extension<KinlySections>()!.pulse;

    return KinlyTapTarget(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(
          spacing.m,
          spacing.xs,
          spacing.m,
          spacing.xs,
        ),
        decoration: BoxDecoration(
          color: emphasize ? colors.accent.withValues(alpha: 0.15) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(width: 4),
            Icon(icon, size: 16),
          ],
        ),
      ),
    );
  }
}
