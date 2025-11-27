import 'package:flutter/material.dart';

class KinlyToast {
  KinlyToast._();

  static void showSuccess(BuildContext context, String message) {
    final theme = Theme.of(context);
    final snackBar = SnackBar(
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: theme.colorScheme.primary,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }
}
