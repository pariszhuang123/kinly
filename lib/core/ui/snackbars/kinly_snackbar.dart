import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

class KinlySnackBar {
  static void showSuccess(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool? isDarkOverride,
  }) {
    final isDark = _isDark(context, isDarkOverride);
    final colors = _colors(context);
    final scheme = Theme.of(context).colorScheme;

    _show(
      context,
      message,
      background: colors?.success ?? scheme.primaryContainer,
      foreground: _foregroundColor(
        colors: colors,
        scheme: scheme,
        isDark: isDark,
        fallback: scheme.onPrimaryContainer,
      ),
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool? isDarkOverride,
  }) {
    final isDark = _isDark(context, isDarkOverride);
    final colors = _colors(context);
    final scheme = Theme.of(context).colorScheme;

    _show(
      context,
      message,
      background: colors?.error ?? scheme.error,
      foreground: _foregroundColor(
        colors: colors,
        scheme: scheme,
        isDark: isDark,
        fallback: scheme.onError,
      ),
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool? isDarkOverride,
  }) {
    final isDark = _isDark(context, isDarkOverride);
    final colors = _colors(context);
    final scheme = Theme.of(context).colorScheme;

    _show(
      context,
      message,
      background: colors?.info ?? scheme.inversePrimary,
      foreground: _foregroundColor(
        colors: colors,
        scheme: scheme,
        isDark: isDark,
        fallback: scheme.onInverseSurface,
      ),
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool? isDarkOverride,
  }) {
    final isDark = _isDark(context, isDarkOverride);
    final colors = _colors(context);
    final scheme = Theme.of(context).colorScheme;

    _show(
      context,
      message,
      background: colors?.warning ?? scheme.tertiaryContainer,
      foreground: _foregroundColor(
        colors: colors,
        scheme: scheme,
        isDark: isDark,
        fallback: scheme.onTertiaryContainer,
      ),
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color background,
    required Color foreground,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final type = theme.extension<KinlyTypography>();

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: (type?.bodyMedium ?? theme.textTheme.bodyMedium)?.copyWith(
            color: foreground,
          ),
        ),
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          horizontal: spacing?.l ?? 16,
          vertical: spacing?.m ?? 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(corners?.medium ?? 12),
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

  static KinlyColorTokens? _colors(BuildContext context) =>
      Theme.of(context).extension<KinlyColorTokens>();

  static bool _isDark(BuildContext context, bool? override) =>
      override ?? Theme.of(context).brightness == Brightness.dark;

  static Color _foregroundColor({
    required KinlyColorTokens? colors,
    required ColorScheme scheme,
    required bool isDark,
    required Color fallback,
  }) {
    if (colors != null) {
      return isDark ? colors.onSurfaceDark : colors.onSurface;
    }
    return fallback;
  }
}
