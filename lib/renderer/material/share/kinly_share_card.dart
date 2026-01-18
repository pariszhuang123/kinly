import 'package:flutter/material.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';

/// A standardized card format for sharing content (Story style).
///
/// Used by:
/// - HouseVibeShareScreen (via HouseInfoShareCard)
/// - TodayHousePulseDetailScreen (via HousePulseShareCard)
class KinlyShareCard extends StatelessWidget {
  const KinlyShareCard({
    super.key,
    required this.header,
    required this.title,
    required this.summary,
    required this.palette,
    required this.visualContent,
    required this.footerContent,
    this.useGradientBackground = false,
  });

  final String header;
  final String title;
  final String summary;
  final SectionColors palette;
  final Widget visualContent;
  final Widget footerContent;
  final bool useGradientBackground;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    BoxDecoration decoration;
    if (useGradientBackground) {
      decoration = BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            palette.card,
            palette.card.withValues(alpha: 0.92),
            palette.card.withValues(alpha: 0.86),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );
    } else {
      decoration = BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(28),
      );
    }

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              header,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: palette.accent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            visualContent,
            SizedBox(height: spacing.md),
            Text(
              summary,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            footerContent,
          ],
        ),
      ),
    );
  }
}
