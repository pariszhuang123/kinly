// lib/core/ui/buttons/kinly_outlined_button.dart
import 'package:flutter/material.dart';

import '../../theme/spacing.dart';

/// Kinly-branded outlined button that adapts to light/dark mode.
///
/// Uses:
/// - Light: primary border/text
/// - Dark:  outline border, onSurface text
class KinlyOutlinedButton extends StatelessWidget {
  const KinlyOutlinedButton._({
    required this.onPressed,
    required this.label,
    this.icon,
    this.compact = false,
    this.fullWidth = false,
    super.key,
  });

  /// Icon + label outlined button.
  factory KinlyOutlinedButton.icon({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    bool compact = false,
    bool fullWidth = false,
    Key? key,
  }) {
    return KinlyOutlinedButton._(
      onPressed: onPressed,
      label: label,
      icon: Icon(icon, size: 16),
      compact: compact,
      fullWidth: fullWidth,
      key: key,
    );
  }

  /// Text-only outlined button.
  factory KinlyOutlinedButton.text({
    required VoidCallback onPressed,
    required String label,
    bool compact = false,
    bool fullWidth = false,
    Key? key,
  }) {
    return KinlyOutlinedButton._(
      onPressed: onPressed,
      label: label,
      icon: null,
      compact: compact,
      fullWidth: fullWidth,
      key: key,
    );
  }

  final VoidCallback onPressed;
  final String label;
  final Widget? icon;
  final bool compact;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final spacing = theme.extension<Spacing>();

    final foreground = isDark ? colorScheme.onSurface : colorScheme.primary;
    final borderColor = isDark ? colorScheme.outline : colorScheme.primary;

    final horizontal =
        spacing != null
            ? (compact ? spacing.sm : spacing.md)
            : (compact ? 10.0 : 14.0);
    final vertical =
        spacing != null
            ? (compact ? spacing.xs : spacing.sm)
            : (compact ? 6.0 : 8.0);

    final child =
        icon != null
            ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon!,
                SizedBox(width: spacing?.xs ?? 6.0),
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            )
            : Text(label, overflow: TextOverflow.ellipsis);

    // ✅ IMPORTANT: explicitly set a finite minimumSize,
    // so this button can live inside a Row without blowing up.
    final button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: foreground,
        side: BorderSide(color: borderColor),
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        minimumSize: Size(
          0, // allow intrinsic width, not Infinity
          compact ? 32.0 : 40.0, // reasonable min height
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      child: child,
    );

    if (!fullWidth) return button;

    return SizedBox(width: double.infinity, child: button);
  }
}
