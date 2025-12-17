import 'package:flutter/material.dart';

import '../../theme/control_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

class KinlySnackBar {
  static void showSuccess(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final palette = KinlyPalette.build(Theme.of(context).brightness);
    final colors = palette.colorTokens;
    final controls = palette.controlColors;

    _show(
      context,
      message,
      background: colors.success,
      foreground: controls.textFg,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final palette = KinlyPalette.build(Theme.of(context).brightness);
    final colors = palette.colorTokens;
    final controls = palette.controlColors;

    _show(
      context,
      message,
      background: colors.error,
      foreground: controls.textFg,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final palette = KinlyPalette.build(Theme.of(context).brightness);
    final colors = palette.colorTokens;
    final controls = palette.controlColors;

    _show(
      context,
      message,
      background: colors.info,
      foreground: controls.textFg,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final palette = KinlyPalette.build(Theme.of(context).brightness);
    final colors = palette.colorTokens;
    final controls = palette.controlColors;

    _show(
      context,
      message,
      background: colors.warning,
      foreground: controls.textFg,
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
    final controls =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.build(theme.brightness).controlColors;

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
                  textColor: controls.textFg,
                )
                : null,
      ),
    );
  }
}
