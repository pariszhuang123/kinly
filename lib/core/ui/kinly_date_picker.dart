// lib/core/ui/kinly_date_picker.dart
import 'package:flutter/material.dart';
import '../theme/kinly_palette.dart';
import '../time/date_only.dart';

Future<DateTime?> showKinlyDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      final theme = Theme.of(context);
      final palette = KinlyPalette.build(theme.brightness);
      final tokens = palette.colorTokens;
      final controls = palette.controlColors;
      return Theme(
        data: theme.copyWith(
          datePickerTheme: theme.datePickerTheme.copyWith(
            headerBackgroundColor: controls.pickerPrimary,
            headerForegroundColor: controls.pickerOnPrimary,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return controls.pickerOnPrimary;
              }
              return tokens.onSurface;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return controls.pickerPrimary;
              }
              return Colors.transparent;
            }),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(controls.pickerPrimary),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}

Future<DateTime?> showKinlyDateOnlyPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  final picked = await showKinlyDatePicker(
    context: context,
    initialDate: dateOnly(initialDate),
    firstDate: dateOnly(firstDate),
    lastDate: dateOnly(lastDate),
  );
  if (picked == null) return null;
  return dateOnly(picked);
}
