import 'package:flutter/material.dart';

/// Kinly-themed time picker that aligns with KinlyFilledButton colors.
Future<TimeOfDay?> showKinlyTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
}) {
  final baseTheme = Theme.of(context);
  final colorScheme = baseTheme.colorScheme;
  final isDark = baseTheme.brightness == Brightness.dark;

  // Match KinlyFilledButton logic.
  final pickerPrimary =
      isDark ? colorScheme.inversePrimary : colorScheme.primary;
  final pickerOnPrimary =
      isDark ? colorScheme.onInverseSurface : colorScheme.onPrimary;

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
            dialBackgroundColor: theme.colorScheme.surfaceVariant,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(pickerPrimary),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
