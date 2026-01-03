import 'package:flutter/material.dart';

import 'kinly_alert_dialog.dart';

Future<bool?> showKinlyConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
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
          secondaryLabel: cancelLabel,
          onSecondaryPressed: () => Navigator.of(context).pop(false),
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
