import 'package:flutter/material.dart';
import '../theme/color_tokens.dart';
import '../theme/kinly_palette.dart';

class KinlyToast {
  KinlyToast._();

  static void showSuccess(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colors =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final snackBar = SnackBar(
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colors.onPrimary,
        ),
      ),
      backgroundColor: colors.primary,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }
}
