import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme/kinly_palette.dart';
import 'theme/radius.dart';
import 'theme/spacing.dart';
import 'theme/typography_tokens.dart';

class KinlySnackBar {
  static Color _foregroundFor(Color background) {
    final brightness = ThemeData.estimateBrightnessForColor(background);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  // WCAG-ish contrast ratio for non-text UI elements.
  // For accents (borders/strips), aim for >= 3:1 against the snackbar background
  // so the section flavor is visible without changing semantic background colors.
  static double _contrastRatio(Color a, Color b) {
    double linearize(double v) {
      return v <= 0.03928
          ? v / 12.92
          : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    }

    double luminance(Color c) {
      final r = linearize(c.r);
      final g = linearize(c.g);
      final b = linearize(c.b);
      return 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }

    final l1 = luminance(a) + 0.05;
    final l2 = luminance(b) + 0.05;
    return l1 > l2 ? l1 / l2 : l2 / l1;
  }

  static Color _accentFor(Color background, Color accent) {
    const minContrast = 3.0;
    if (_contrastRatio(background, accent) >= minContrast) return accent;

    // Prefer preserving the hue by shifting lightness (and slightly boosting
    // saturation) before falling back to neutral black/white.
    final hsl = HSLColor.fromColor(accent);
    final baseLightness = hsl.lightness;
    final candidates = <double>[
      baseLightness - 0.30,
      baseLightness + 0.30,
      baseLightness - 0.45,
      baseLightness + 0.45,
      baseLightness - 0.60,
      baseLightness + 0.60,
    ].map((l) => l.clamp(0.08, 0.92)).toList(growable: false);

    for (final lightness in candidates) {
      final candidate =
          hsl
              .withSaturation((hsl.saturation + 0.15).clamp(0.0, 1.0))
              .withLightness(lightness)
              .toColor();
      if (_contrastRatio(background, candidate) >= minContrast) {
        return candidate;
      }
    }

    final target = _foregroundFor(background);
    for (final t in <double>[0.25, 0.4, 0.55, 0.7, 0.85, 1.0]) {
      final candidate = Color.lerp(accent, target, t) ?? target;
      if (_contrastRatio(background, candidate) >= minContrast) {
        return candidate;
      }
    }

    return target;
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    Color? accentColor,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final palette = KinlyPalette.build(Theme.of(context).brightness);
    final colors = palette.colorTokens;
    final foreground = _foregroundFor(colors.success);

    _show(
      context,
      message,
      background: colors.success,
      foreground: foreground,
      accentColor: accentColor,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Color? accentColor,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final palette = KinlyPalette.build(Theme.of(context).brightness);
    final colors = palette.colorTokens;
    final foreground = _foregroundFor(colors.error);

    _show(
      context,
      message,
      background: colors.error,
      foreground: foreground,
      accentColor: accentColor,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Color? accentColor,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final palette = KinlyPalette.build(Theme.of(context).brightness);
    final colors = palette.colorTokens;
    final foreground = _foregroundFor(colors.info);

    _show(
      context,
      message,
      background: colors.info,
      foreground: foreground,
      accentColor: accentColor,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Color? accentColor,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final palette = KinlyPalette.build(Theme.of(context).brightness);
    final colors = palette.colorTokens;
    final foreground = _foregroundFor(colors.warning);

    _show(
      context,
      message,
      background: colors.warning,
      foreground: foreground,
      accentColor: accentColor,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color background,
    required Color foreground,
    Color? accentColor,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final type = theme.extension<KinlyTypography>();

    messenger.hideCurrentSnackBar();

    final effectiveAccent =
        accentColor == null ? null : _accentFor(background, accentColor);

    final accentStrip =
        effectiveAccent == null
            ? null
            : ClipRRect(
              borderRadius: BorderRadius.circular(corners?.small ?? 8),
              child: SizedBox(
                width: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: effectiveAccent),
                  child: const SizedBox.expand(),
                ),
              ),
            );

    final content = IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (accentStrip != null) ...[
            accentStrip,
            SizedBox(width: spacing?.m ?? 12),
          ],
          Expanded(
            child: Text(
              message,
              style: (type?.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );

    messenger.showSnackBar(
      SnackBar(
        content: content,
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          horizontal: spacing?.l ?? 16,
          vertical: spacing?.m ?? 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(corners?.medium ?? 12),
          side:
              effectiveAccent != null
                  ? BorderSide(color: effectiveAccent, width: 1.5)
                  : BorderSide.none,
        ),
        duration: const Duration(milliseconds: 3000),
        action:
            actionLabel != null && onAction != null
                ? SnackBarAction(
                  label: actionLabel,
                  onPressed: onAction,
                  textColor: foreground,
                )
                : null,
      ),
    );
  }
}
