// lib/core/ui/buttons/kinly_outlined_button.dart
import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/control_tokens.dart';
import '../../theme/kinly_palette.dart';
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
    this.semanticsLabel,
    super.key,
  });

  /// Icon + label outlined button.
  factory KinlyOutlinedButton.icon({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    bool compact = false,
    bool fullWidth = false,
    String? semanticsLabel,
    Key? key,
  }) {
    return KinlyOutlinedButton._(
      onPressed: onPressed,
      label: label,
      icon: Icon(icon, size: 16),
      compact: compact,
      fullWidth: fullWidth,
      semanticsLabel: semanticsLabel,
      key: key,
    );
  }

  /// Text-only outlined button.
  factory KinlyOutlinedButton.text({
    required VoidCallback onPressed,
    required String label,
    bool compact = false,
    bool fullWidth = false,
    String? semanticsLabel,
    Key? key,
  }) {
    return KinlyOutlinedButton._(
      onPressed: onPressed,
      label: label,
      icon: null,
      compact: compact,
      fullWidth: fullWidth,
      semanticsLabel: semanticsLabel,
      key: key,
    );
  }

  final VoidCallback onPressed;
  final String label;
  final Widget? icon;
  final bool compact;
  final bool fullWidth;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    assert((semanticsLabel ?? label).isNotEmpty, 'Semantic label must not be empty');

    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final corners = theme.extension<Corners>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();
    final controls =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.controls(theme.brightness, theme.colorScheme);

    // ---- COLOR LOGIC (aligned with KinlyFilledButton) ----
    // Light:
    //   text/border = primary
    // Dark:
    //   text       = onSurface        (same as filled foreground)
    //   border     = primaryContainer (same as filled background)
    final Color foreground = controls.outlinedFg;
    final Color borderColor = controls.outlinedBorder;

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
      minimumSize: const Size(48, 48),
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

    final Widget finalButton =
        fullWidth ? SizedBox(width: double.infinity, child: button) : button;

    return Semantics(
      button: true,
      enabled: true,
      label: semanticsLabel ?? label,
      child: finalButton,
    );
  }
}
