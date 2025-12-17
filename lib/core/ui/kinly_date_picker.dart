// lib/core/ui/kinly_date_picker.dart
import 'package:flutter/material.dart';
import '../theme/control_tokens.dart';
import '../theme/kinly_palette.dart';

Future<DateTime?> showKinlyDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  final theme = Theme.of(context);
  final controls =
      theme.extension<KinlyControlColors>() ??
      KinlyPalette.controls(theme.brightness, theme.colorScheme);
  final pickerPrimary = controls.pickerPrimary;
  final pickerOnPrimary = controls.pickerOnPrimary;

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
