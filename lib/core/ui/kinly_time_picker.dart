import 'package:flutter/material.dart';
import '../theme/control_tokens.dart';
import '../theme/kinly_palette.dart';

/// Kinly-themed time picker that aligns with KinlyFilledButton colors.
Future<TimeOfDay?> showKinlyTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
}) {
  final theme = Theme.of(context);
  final controls =
      theme.extension<KinlyControlColors>() ??
      KinlyPalette.controls(theme.brightness, theme.colorScheme);
  final pickerPrimary = controls.pickerPrimary;
  final pickerOnPrimary = controls.pickerOnPrimary;

  return showTimePicker(
    context: context,
    initialTime: initialTime,
    initialEntryMode: initialEntryMode,
    builder: (context, child) {
      final theme = Theme.of(context);

      return Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: pickerPrimary,
            onPrimary: pickerOnPrimary,
          ),
          timePickerTheme: theme.timePickerTheme.copyWith(
            hourMinuteTextColor: pickerOnPrimary,
            hourMinuteColor: pickerPrimary,
            dialHandColor: pickerPrimary,
            dialTextColor: theme.colorScheme.onSurface,
            dialBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(pickerPrimary),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
