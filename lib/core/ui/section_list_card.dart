import 'package:flutter/material.dart';
import '../theme/kinly_sections.dart';
import '../theme/spacing.dart';

/// Generic list card used inside a section (Flow, Share, etc.).
///
/// You configure it with:
/// - colors: SectionColors
/// - icon: optional leading icon
/// - title: main text
/// - trailingText: e.g. amount
/// - badgeText: e.g. "new today"
/// - onTap: tap handler
class SectionListCard extends StatelessWidget {
  final SectionColors colors;
  final IconData? icon;
  final String title;
  final String? trailingText;
  final String? badgeText;
  final VoidCallback? onTap;

  const SectionListCard({
    super.key,
    required this.colors,
    required this.title,
    this.icon,
    this.trailingText,
    this.badgeText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing?.xs ?? 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing?.md ?? 12,
            vertical: spacing?.sm ?? 8,
          ),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: colors.icon),
                SizedBox(width: spacing?.sm ?? 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: colors.icon),
                ),
              ),
              if (badgeText != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(end: spacing?.xs ?? 4),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing?.xs ?? 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: .07),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeText!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              if (trailingText != null) ...[
                SizedBox(width: spacing?.xs ?? 4),
                Text(
                  trailingText!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.icon,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              Icon(Icons.chevron_right_rounded, color: colors.icon),
            ],
          ),
        ),
      ),
    );
  }
}
