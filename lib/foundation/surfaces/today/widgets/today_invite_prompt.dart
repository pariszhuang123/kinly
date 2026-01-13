import 'package:flutter/widgets.dart';

import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../../core/ui/kinly_theme_access.dart';

class TodayInvitePrompt extends StatelessWidget {
  const TodayInvitePrompt({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.palette,
  });

  final String title;
  final String subtitle;
  final String primaryLabel;
  final String? secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final SectionColors? palette;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final secondaryTap = onSecondary;
    final secondaryText = secondaryLabel;
    final sectionColors = palette ?? context.preferenceSection;
    final cardColor = sectionColors.card;
    final accent = sectionColors.accent;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          SizedBox(height: spacing.xs),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: KinlyFilledButton.text(
                  onPressed: onPrimary,
                  label: primaryLabel,
                  backgroundColor: accent,
                  foregroundColor: sectionColors.onAccent(),
                ),
              ),
              if (secondaryText != null && secondaryTap != null) ...[
                SizedBox(width: spacing.sm),
                Expanded(
                  child: KinlyOutlinedButton.text(
                    onPressed: secondaryTap,
                    label: secondaryText,
                    foregroundColor: accent,
                    borderColor: accent,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
