import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../buttons/kinly_filled_button.dart';

class KinlyAlertDialog extends StatelessWidget {
  const KinlyAlertDialog._({
    required this.title,
    required this.message,
    required this.primaryLabel,
    this.onPrimaryPressed,
    this.destructive = false,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final bool destructive;

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
    bool destructive = false,
  }) {
    return KinlyAlertDialog._(
      title: title,
      message: message,
      primaryLabel: primaryLabel,
      onPrimaryPressed: onPrimaryPressed,
      destructive: destructive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colorScheme = theme.colorScheme;

    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
    );

    final messageStyle = theme.textTheme.bodyMedium?.copyWith(
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

    return AlertDialog(
      title: Text(title, style: titleStyle),
      content: Padding(
        padding: EdgeInsets.only(top: spacing.xs),
        child: Text(message, style: messageStyle),
      ),
      actionsPadding: EdgeInsets.only(right: spacing.md, bottom: spacing.sm),
      actions: [primaryButton],
    );
  }
}
