import 'package:flutter/material.dart';
import '../theme/kinly_palette.dart';

/// Kinly-themed time picker that aligns with KinlyFilledButton colors.
Future<TimeOfDay?> showKinlyTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    initialEntryMode: initialEntryMode,
    builder: (context, child) {
      final theme = Theme.of(context);
      final palette = KinlyPalette.build(theme.brightness);
      final controls = palette.controlColors;
      final tokens = palette.colorTokens;

      return Theme(
        data: theme.copyWith(
          timePickerTheme: theme.timePickerTheme.copyWith(
            hourMinuteTextColor: controls.pickerOnPrimary,
            hourMinuteColor: controls.pickerPrimary,
            dialHandColor: controls.pickerPrimary,
            dialTextColor: tokens.onSurface,
            dialBackgroundColor: tokens.surfaceVariant,
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
