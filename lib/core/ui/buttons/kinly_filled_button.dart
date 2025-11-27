// lib/core/ui/buttons/kinly_filled_button.dart
import 'package:flutter/material.dart';

import '../../theme/spacing.dart';

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
            ? colorScheme.error
            : isDark
            ? colorScheme.inversePrimary
            : colorScheme.primary;
    final foregroundColor =
        destructive
            ? colorScheme.onError
            : isDark
            ? colorScheme.onInverseSurface
            : colorScheme.onPrimary;

    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: child,
    );

    if (!fullWidth) return button;

    return SizedBox(width: double.infinity, child: button);
  }
}
