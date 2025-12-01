// lib/core/ui/buttons/kinly_filled_button.dart
import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

/// Kinly-branded filled button that adapts to light/dark mode.
///
/// Uses:
/// - Light: primary / onPrimary
/// - Dark:  secondaryContainer / onInverseSurface (to match KinlyAddTileButton)
class KinlyFilledButton extends StatelessWidget {
  const KinlyFilledButton._({
    required this.onPressed,
    required this.label,
    this.icon,
    this.compact = false,
    this.fullWidth = false,
    this.destructive = false,
    super.key,
  });

  /// Icon + label filled button.
  factory KinlyFilledButton.icon({
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
    bool compact = false,
    bool fullWidth = false,
    bool destructive = false,
    Key? key,
  }) {
    return KinlyFilledButton._(
      onPressed: onPressed,
      label: label,
      icon: Icon(icon),
      compact: compact,
      fullWidth: fullWidth,
      destructive: destructive,
      key: key,
    );
  }

  /// Icon + label destructive filled button (error colors).
  factory KinlyFilledButton.destructiveIcon({
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
    bool compact = false,
    bool fullWidth = false,
    Key? key,
  }) {
    return KinlyFilledButton.icon(
      onPressed: onPressed,
      label: label,
      icon: icon,
      compact: compact,
      fullWidth: fullWidth,
      destructive: true,
      key: key,
    );
  }

  /// Text-only filled button (no icon).
  factory KinlyFilledButton.text({
    required VoidCallback? onPressed,
    required String label,
    bool compact = false,
    bool fullWidth = false,
    bool destructive = false,
    Key? key,
  }) {
    return KinlyFilledButton._(
      onPressed: onPressed,
      label: label,
      icon: null,
      compact: compact,
      fullWidth: fullWidth,
      destructive: destructive,
      key: key,
    );
  }

  /// Text-only destructive filled button (error colors).
  factory KinlyFilledButton.destructiveText({
    required VoidCallback? onPressed,
    required String label,
    bool compact = false,
    bool fullWidth = false,
    Key? key,
  }) {
    return KinlyFilledButton.text(
      onPressed: onPressed,
      label: label,
      compact: compact,
      fullWidth: fullWidth,
      destructive: true,
      key: key,
    );
  }

  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;
  final bool compact;
  final bool fullWidth;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final spacing = theme.extension<Spacing>()!;
    final corners = theme.extension<Corners>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();

    final horizontal = compact ? spacing.sm : spacing.lg;
    final vertical = compact ? spacing.xs : spacing.sm;

    final Widget child = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
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

    // ---- COLOR LOGIC (aligned with KinlyAddTileButton in dark mode) ----
    final Color backgroundColor;
    final Color foregroundColor;

    if (destructive) {
      backgroundColor = colors?.error ?? colorScheme.error;
      foregroundColor = colors?.onError ?? colorScheme.onError;
    } else if (isDark) {
      // Match KinlyAddTileButton behaviour in dark mode:
      // - container: secondaryContainer
      // - content:   onInverseSurface (good contrast on filled CTA)
      backgroundColor = colorScheme.secondaryContainer;
      foregroundColor = colorScheme.onInverseSurface;
    } else {
      // Light mode: keep as primary CTA
      backgroundColor = colors?.primary ?? colorScheme.primary;
      foregroundColor = colors?.onPrimary ?? colorScheme.onPrimary;
    }

    final baseStyle = FilledButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: type?.labelMedium ?? theme.textTheme.labelLarge,
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corners?.medium ?? 12),
      ),
    );

    final overlay = WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return foregroundColor.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.disabled)) {
          return foregroundColor.withValues(alpha: 0.0);
        }
        return null;
      },
    );

    final button = FilledButton(
      onPressed: onPressed,
      style: baseStyle.copyWith(
        overlayColor: overlay,
      ),
      child: child,
    );

    if (!fullWidth) return button;

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}
