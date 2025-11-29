// lib/core/ui/buttons/kinly_outlined_button.dart
import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

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
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();

    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final foreground =
        isDark
            ? (colors?.onSurface ?? colorScheme.onSurface)
            : (colors?.primary ?? colorScheme.primary);
    final borderColor =
        isDark
            ? (colors?.outlineDark ?? colorScheme.outline)
            : (colors?.primary ?? colorScheme.primary);

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
    final baseStyle = OutlinedButton.styleFrom(
      foregroundColor: foreground,
      side: BorderSide(color: borderColor),
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      minimumSize: Size(
        0, // allow intrinsic width, not Infinity
        compact ? 36.0 : 44.0,
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corners?.medium ?? 12),
      ),
      textStyle: type?.labelMedium ??
          theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
    );

    final overlay = MaterialStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(MaterialState.pressed)) {
          return foreground.withValues(alpha: 0.08);
        }
        if (states.contains(MaterialState.disabled)) {
          return foreground.withValues(alpha: 0.0);
        }
        return null;
      },
    );

    final button = OutlinedButton(
      onPressed: onPressed,
      style: baseStyle.copyWith(overlayColor: overlay),
      child: child,
    );

    if (!fullWidth) return button;

    return SizedBox(width: double.infinity, child: button);
  }
}
