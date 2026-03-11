import 'package:flutter/widgets.dart';

import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';

class KinlyOnboardingOptionCard extends StatelessWidget {
  const KinlyOnboardingOptionCard({
    required this.label,
    required this.isSelected,
    required this.colors,
    this.icon,
    this.onTap,
    super.key,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
  final SectionColors colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final colorScheme = theme.colorScheme;
    final iconColor = isSelected ? colors.accent : colorScheme.onSurfaceVariant;
    final hasIcon = icon != null;

    return Semantics(
      button: true,
      selected: isSelected,
      child: KinlyTapTarget(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        alignment: AlignmentDirectional.centerStart,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 88),
          padding: EdgeInsetsDirectional.fromSTEB(
            spacing?.lg ?? 16,
            spacing?.m ?? 12,
            spacing?.lg ?? 16,
            spacing?.m ?? 12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colors.card : colors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? colors.accent : colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              if (hasIcon) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? colors.accent.withValues(alpha: 0.14)
                            : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                SizedBox(width: spacing?.m ?? 12),
              ],
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color:
                        isSelected
                            ? colors.accent
                            : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(width: spacing?.s ?? 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? colors.accent.withValues(alpha: 0.2)
                          : colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child:
                    isSelected
                        ? Icon(
                          KinlyIcons.checkRounded,
                          size: 16,
                          color: colors.accent,
                        )
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
