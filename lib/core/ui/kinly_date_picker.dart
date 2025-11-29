// lib/core/ui/kinly_date_picker.dart
import 'package:flutter/material.dart';

Future<DateTime?> showKinlyDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  final baseTheme = Theme.of(context);
  final colorScheme = baseTheme.colorScheme;
  final isDark = baseTheme.brightness == Brightness.dark;

  // Match KinlyFilledButton logic
  final pickerPrimary =
      isDark ? colorScheme.inversePrimary : colorScheme.primary;
  final pickerOnPrimary =
      isDark ? colorScheme.onInverseSurface : colorScheme.onPrimary;

  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      final theme = Theme.of(context);

      return Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: pickerPrimary,
            onPrimary: pickerOnPrimary,
          ),
          datePickerTheme: theme.datePickerTheme.copyWith(
            headerBackgroundColor: pickerPrimary,
            headerForegroundColor: pickerOnPrimary,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return pickerOnPrimary;
              }
              return theme.colorScheme.onSurface;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return pickerPrimary;
              }
              return Colors.transparent;
            }),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: pickerPrimary),
          ),
        ),
        child: child!,
      );
    },
  );
}
