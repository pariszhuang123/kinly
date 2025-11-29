import 'package:flutter/material.dart';

class KinlySnackBar {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      background: _successBackground(context),
      foreground: _successForeground(context),
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      background: Theme.of(context).colorScheme.error,
      foreground: Theme.of(context).colorScheme.onError,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message,
      background: _infoBackground(context),
      foreground: _infoForeground(context),
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color background,
    required Color foreground,
  }) {
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
        ),
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // --- Color helpers (mirrors KinlyFilledButton logic) ---

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color _successBackground(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _isDark(context) ? scheme.inversePrimary : scheme.primary;
  }

  static Color _successForeground(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _isDark(context) ? scheme.onInverseSurface : scheme.onPrimary;
  }

  static Color _infoBackground(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _isDark(context) ? scheme.inversePrimary : scheme.primary;
  }

  static Color _infoForeground(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _isDark(context) ? scheme.onInverseSurface : scheme.onPrimary;
  }
}
