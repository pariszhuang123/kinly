// lib/core/ui/buttons/kinly_filled_button.dart
import 'package:flutter/material.dart';

import '../../theme/control_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/opacity.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

/// Kinly-branded filled button that adapts to light/dark mode.
///
/// Uses:
/// - Light: primary / onPrimary
/// - Dark:  inverseSurface / onInverseSurface (to match KinlyAddTileButton / FAB / TabBar)
class KinlyFilledButton extends StatelessWidget {
  const KinlyFilledButton._({
    required this.onPressed,
    required this.label,
    this.icon,
    this.compact = false,
    this.fullWidth = false,
    this.destructive = false,
    this.semanticsLabel,
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
    String? semanticsLabel,
    Key? key,
  }) {
    return KinlyFilledButton._(
      onPressed: onPressed,
      label: label,
      icon: Icon(icon),
      compact: compact,
      fullWidth: fullWidth,
      destructive: destructive,
      semanticsLabel: semanticsLabel,
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
    String? semanticsLabel,
    Key? key,
  }) {
    return KinlyFilledButton.icon(
      onPressed: onPressed,
      label: label,
      icon: icon,
      compact: compact,
      fullWidth: fullWidth,
      destructive: true,
      semanticsLabel: semanticsLabel,
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
    String? semanticsLabel,
    Key? key,
  }) {
    return KinlyFilledButton._(
      onPressed: onPressed,
      label: label,
      icon: null,
      compact: compact,
      fullWidth: fullWidth,
      destructive: destructive,
      semanticsLabel: semanticsLabel,
      key: key,
    );
  }

  /// Text-only destructive filled button (error colors).
  factory KinlyFilledButton.destructiveText({
    required VoidCallback? onPressed,
    required String label,
    bool compact = false,
    bool fullWidth = false,
    String? semanticsLabel,
    Key? key,
  }) {
    return KinlyFilledButton.text(
      onPressed: onPressed,
      label: label,
      compact: compact,
      fullWidth: fullWidth,
      destructive: true,
      semanticsLabel: semanticsLabel,
      key: key,
    );
  }

  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;
  final bool compact;
  final bool fullWidth;
  final bool destructive;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    assert((semanticsLabel ?? label).isNotEmpty, 'Semantic label must not be empty');

    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final corners = theme.extension<Corners>();
    final tokens =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.build(theme.brightness).controlColors;
    final type = theme.extension<KinlyTypography>();
    final disabled = onPressed == null;

    final horizontal = compact ? spacing.sm : spacing.lg;
    final vertical = compact ? spacing.xs : spacing.sm;

    final Widget child =
        icon != null
            ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!,
                SizedBox(width: spacing.xs),
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            )
            : Text(label, overflow: TextOverflow.ellipsis);

    // ---- COLOR LOGIC (aligned with KinlyAddTileButton / FAB / TabBar) ----
    final Color backgroundColor =
        destructive
            ? (disabled
                ? tokens.filledDestructiveDisabledBg
                : tokens.filledDestructiveBg)
            : (disabled ? tokens.filledDisabledBg : tokens.filledBg);
    final Color foregroundColor =
        destructive
            ? (disabled
                ? tokens.filledDestructiveDisabledFg
                : tokens.filledDestructiveFg)
            : (disabled ? tokens.filledDisabledFg : tokens.filledFg);

    final baseStyle = FilledButton.styleFrom(
      minimumSize: const Size(48, 48),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: type?.labelMedium ?? theme.textTheme.labelLarge,
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corners?.medium ?? 12),
      ),
    );

    final overlay = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        final opacities = Theme.of(context).extension<KinlyOpacity>()!;
        return foregroundColor.withValues(alpha: opacities.alphaSM);
      }
      return null;
    });

    final button = FilledButton(
      onPressed: onPressed,
      style: baseStyle.copyWith(overlayColor: overlay),
      child: child,
    );

    final Widget finalButton =
        fullWidth ? SizedBox(width: double.infinity, child: button) : button;

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticsLabel ?? label,
      child: finalButton,
    );
  }
}
