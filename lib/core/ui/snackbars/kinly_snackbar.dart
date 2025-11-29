import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

class KinlySnackBar {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      background: _colors(context)?.success ??
          Theme.of(context).colorScheme.primaryContainer,
      foreground: _colors(context)?.onSurface ??
          Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      background: _colors(context)?.error ??
          Theme.of(context).colorScheme.error,
      foreground: _colors(context)?.onError ??
          Theme.of(context).colorScheme.onError,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message,
      background: _colors(context)?.info ??
          Theme.of(context).colorScheme.inversePrimary,
      foreground: _colors(context)?.onSurface ??
          Theme.of(context).colorScheme.onInverseSurface,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _show(
      context,
      message,
      background: _colors(context)?.warning ??
          Theme.of(context).colorScheme.tertiaryContainer,
      foreground: _colors(context)?.onSurface ??
          Theme.of(context).colorScheme.onTertiaryContainer,
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
      ),
    );
  }

  static KinlyColorTokens? _colors(BuildContext context) =>
      Theme.of(context).extension<KinlyColorTokens>();
}
