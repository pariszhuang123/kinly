import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/elevation.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';
import '../buttons/kinly_filled_button.dart';
import '../buttons/kinly_outlined_button.dart';

class KinlyAlertDialog extends StatelessWidget {
  const KinlyAlertDialog._({
    required this.title,
    required this.message,
    required this.primaryLabel,
    this.onPrimaryPressed,
    this.destructive = false,
    this.secondaryLabel,
    this.onSecondaryPressed,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final bool destructive;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  /// Simple info dialog with a single primary button
  factory KinlyAlertDialog.info({
    required String title,
    required String message,
    required String primaryLabel,
    VoidCallback? onPrimaryPressed,
  }) {
    return KinlyAlertDialog._(
      title: title,
      message: message,
      primaryLabel: primaryLabel,
      onPrimaryPressed: onPrimaryPressed,
    );
  }

  /// Confirmation dialog with primary + secondary buttons
  factory KinlyAlertDialog.confirm({
    required String title,
    required String message,
    required String primaryLabel,
    VoidCallback? onPrimaryPressed,
    String? secondaryLabel,
    VoidCallback? onSecondaryPressed,
    bool destructive = false,
  }) {
    return KinlyAlertDialog._(
      title: title,
      message: message,
      primaryLabel: primaryLabel,
      onPrimaryPressed: onPrimaryPressed,
      destructive: destructive,
      secondaryLabel: secondaryLabel,
      onSecondaryPressed: onSecondaryPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final corners = theme.extension<Corners>();
    final elevations = theme.extension<Elevations>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();
    final colorScheme = theme.colorScheme;

    final titleStyle =
        type?.titleMedium ??
        theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700);

    final messageStyle =
        type?.bodyMedium ??
        theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );

    final primaryButton =
        destructive
            ? KinlyFilledButton.destructiveText(
              onPressed: onPrimaryPressed,
              label: primaryLabel,
            )
            : KinlyFilledButton.text(
              onPressed: onPrimaryPressed,
              label: primaryLabel,
            );

    final secondaryButton =
        secondaryLabel != null
            ? KinlyOutlinedButton.text(
              onPressed:
                  onSecondaryPressed ?? () => Navigator.of(context).pop(),
              label: secondaryLabel!,
              fullWidth: false,
              compact: true,
            )
            : null;

    return AlertDialog(
      elevation: elevations?.level4 ?? 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corners?.large ?? 16),
      ),
      backgroundColor: colors?.surface ?? colorScheme.surface,
      title: Text(title, style: titleStyle),
      content: Padding(
        padding: EdgeInsets.only(top: spacing.xs),
        child: Text(message, style: messageStyle),
      ),
      actionsPadding: EdgeInsetsDirectional.only(
        start: spacing.md,
        end: spacing.md,
        bottom: spacing.sm,
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [if (secondaryButton != null) secondaryButton, primaryButton],
    );
  }
}
