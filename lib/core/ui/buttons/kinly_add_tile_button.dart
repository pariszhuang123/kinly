import 'package:flutter/material.dart';

import '../../theme/spacing.dart';

class KinlyAddTileButton extends StatelessWidget {
  const KinlyAddTileButton({
    super.key,
    this.label,
    required this.onTap,
    this.icon = Icons.add,
    this.size = 56,
    this.borderRadius = 16,
    this.semanticsLabel,
  });

  final String? label;
  final VoidCallback onTap;
  final IconData icon;
  final double size;
  final double borderRadius;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // --- MATCH KinlyTabBar + KinlyFilledButton ---
    final Color containerColor =
        isDark ? colors.primaryContainer : colors.primary;

    final Color iconColor = isDark ? colors.onSurface : colors.onPrimary;

    final Color textColor = isDark ? colors.onSurface : colors.primary;

    final displayedLabel = label ?? semanticsLabel ?? 'Add';

    return Semantics(
      button: true,
      enabled: true,
      label: semanticsLabel ?? displayedLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Icon(icon, color: iconColor),
              ),

              if (label != null) ...[
                SizedBox(height: spacing.sm),
                SizedBox(
                  width: size + 8,
                  child: Text(
                    label!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
