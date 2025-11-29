// lib/core/ui/dialogs/kinly_dialogs.dart
import 'package:flutter/material.dart';
import 'kinly_alert_dialog.dart';

Future<bool?> showKinlyConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder:
        (_) => KinlyAlertDialog.confirm(
          title: title,
          message: message,
          primaryLabel: confirmLabel,
          destructive: destructive,
          onPrimaryPressed: () => Navigator.of(context).pop(true),
        ),
  );
}

Future<void> showKinlyInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String closeLabel,
}) {
  return showDialog<void>(
    context: context,
    builder:
        (_) => KinlyAlertDialog.info(
          title: title,
          message: message,
          primaryLabel: closeLabel,
          onPrimaryPressed: () => Navigator.of(context).pop(),
        ),
  );
}
