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
/// - Dark:  primaryContainer border + onSurface text
///          (so it visually pairs with KinlyFilledButton in dark mode).
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
    final spacing = theme.extension<Spacing>()!;
    final corners = theme.extension<Corners>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();

    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // ---- COLOR LOGIC (aligned with KinlyFilledButton) ----
    // Light:
    //   text/border = primary
    // Dark:
    //   text       = onSurface        (same as filled foreground)
    //   border     = primaryContainer (same as filled background)
    late final Color foreground;
    late final Color borderColor;

    if (isDark) {
      foreground = colorScheme.onSurface;
      borderColor = colorScheme.primaryContainer;
    } else {
      foreground = colors?.primary ?? colorScheme.primary;
      borderColor = foreground;
    }

    final double horizontal = compact ? spacing.sm : spacing.md;
    final double vertical = compact ? spacing.xs : spacing.sm;

    final Widget child = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              SizedBox(width: spacing.xs),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        : Text(
            label,
            overflow: TextOverflow.ellipsis,
          );

    // Explicit finite minSize so it behaves nicely in Rows.
    final baseStyle = OutlinedButton.styleFrom(
      foregroundColor: foreground,
      side: BorderSide(color: borderColor),
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      minimumSize: Size(
        0, // allow intrinsic width
        compact ? 36.0 : 44.0,
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corners?.medium ?? 12),
      ),
      textStyle: type?.labelMedium ??
          theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
    );

    final overlay = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return foreground.withValues(alpha: 0.08);
      }
      if (states.contains(WidgetState.disabled)) {
        return foreground.withValues(alpha: 0.0);
      }
      return null;
    });

    final button = OutlinedButton(
      onPressed: onPressed,
      style: baseStyle.copyWith(overlayColor: overlay),
      child: child,
    );

    if (!fullWidth) return button;

    return SizedBox(width: double.infinity, child: button);
  }
}
