import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/ui/kinly_date_picker.dart';
import 'package:kinly/core/ui/kinly_time_picker.dart';
import 'package:kinly/core/theme/kinly_palette.dart';

void main() {
  final controls = KinlyPalette.build(Brightness.light).controlColors;

  Widget buildApp(Widget child) {
    return MaterialApp(theme: ThemeData.light(), home: child);
  }

  testWidgets('showKinlyTimePicker applies Kinly colors', (tester) async {
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder:
              (context) => Scaffold(
                body: ElevatedButton(
                  onPressed:
                      () => showKinlyTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 9, minute: 0),
                      ),
                  child: const Text('open-time'),
                ),
              ),
        ),
      ),
    );

    await tester.tap(find.text('open-time'));
    await tester.pumpAndSettle();

    final themeWidget = tester.widget<Theme>(
      find
          .ancestor(
            of: find.byType(TimePickerDialog),
            matching: find.byType(Theme),
          )
          .first,
    );
    final theme = themeWidget.data;

    expect(theme.timePickerTheme.dialHandColor, controls.pickerPrimary);
    expect(theme.timePickerTheme.hourMinuteColor, controls.pickerPrimary);
    expect(theme.timePickerTheme.hourMinuteTextColor, controls.pickerOnPrimary);
    expect(
      theme.textButtonTheme.style?.foregroundColor?.resolve({}),
      controls.pickerPrimary,
    );
  });

  testWidgets('showKinlyDatePicker applies Kinly colors', (tester) async {
    final now = DateTime.now();
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder:
              (context) => Scaffold(
                body: ElevatedButton(
                  onPressed:
                      () => showKinlyDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: now.subtract(const Duration(days: 1)),
                        lastDate: now.add(const Duration(days: 1)),
                      ),
                  child: const Text('open-date'),
                ),
              ),
        ),
      ),
    );

    await tester.tap(find.text('open-date'));
    await tester.pumpAndSettle();

    final themeWidget = tester.widget<Theme>(
      find
          .ancestor(
            of: find.byType(DatePickerDialog),
            matching: find.byType(Theme),
          )
          .first,
    );
    final theme = themeWidget.data;

    expect(theme.datePickerTheme.headerBackgroundColor, controls.pickerPrimary);
    expect(
      theme.datePickerTheme.headerForegroundColor,
      controls.pickerOnPrimary,
    );
    expect(
      theme.textButtonTheme.style?.foregroundColor?.resolve({}),
      controls.pickerPrimary,
    );
  });
}
