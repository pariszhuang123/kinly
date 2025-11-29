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
/// - Dark:  inversePrimary / onInverseSurface
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
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();

    final horizontal =
        spacing != null
            ? (compact ? spacing.sm : spacing.lg)
            : (compact ? 12.0 : 16.0);
    final vertical =
        spacing != null
            ? (compact ? spacing.xs : spacing.sm)
            : (compact ? 6.0 : 10.0);

    final child =
        icon != null
            ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!,
                SizedBox(width: spacing?.xs ?? 8.0),
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            )
            : Text(label, overflow: TextOverflow.ellipsis);

    final backgroundColor =
        destructive
            ? (colors?.error ?? colorScheme.error)
            : isDark
            ? (colors?.primary ?? colorScheme.inversePrimary)
            : (colors?.primary ?? colorScheme.primary);
    final foregroundColor =
        destructive
            ? (colors?.onError ?? colorScheme.onError)
            : isDark
            ? (colors?.onInverseSurface ?? colorScheme.onInverseSurface)
            : (colors?.onPrimary ?? colorScheme.onPrimary);

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

    final overlay = MaterialStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(MaterialState.pressed)) {
          return foregroundColor.withValues(alpha: 0.12);
        }
        if (states.contains(MaterialState.disabled)) {
          return foregroundColor.withValues(alpha: 0.0);
        }
        return null;
      },
    );

    final button = FilledButton(
      onPressed: onPressed,
      style: baseStyle.copyWith(overlayColor: overlay),
      child: child,
    );

    if (!fullWidth) return button;

    return SizedBox(width: double.infinity, child: button);
  }
}
