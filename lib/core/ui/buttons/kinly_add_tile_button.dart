import 'package:flutter/material.dart';

import '../../theme/spacing.dart';

class KinlyAddTileButton extends StatelessWidget {
  const KinlyAddTileButton({
    super.key,
    this.label, // 👈 OPTIONAL
    required this.onTap,
    this.icon = Icons.add,
    this.size = 56,
    this.borderRadius = 16,
  });

  final String? label;
  final VoidCallback onTap;
  final IconData icon;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Light/dark mode friendly colors
    final Color containerColor =
        isDark ? colorScheme.secondaryContainer : colorScheme.primaryContainer;

    final Color iconColor =
        isDark ? colorScheme.onInverseSurface : colorScheme.onPrimaryContainer;

    final Color textColor =
        isDark ? colorScheme.onSurface : colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
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

          // ---- Only show text if label is provided ----
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
    );
  }
}
