import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/ui/kinly_date_picker.dart';
import 'package:kinly/core/ui/kinly_time_picker.dart';

void main() {
  const primary = Color(0xFF3366FF);
  const onPrimary = Color(0xFFFFFFFF);

  Widget buildApp(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: primary,
          onPrimary: onPrimary,
          inversePrimary: Color(0xFF009688),
          onInverseSurface: Color(0xFF111111),
        ),
      ),
      home: child,
    );
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

    expect(theme.colorScheme.primary, primary);
    expect(theme.colorScheme.onPrimary, onPrimary);
    expect(theme.timePickerTheme.dialHandColor, primary);
    expect(theme.textButtonTheme.style?.foregroundColor?.resolve({}), primary);
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

    expect(theme.colorScheme.primary, primary);
    expect(theme.colorScheme.onPrimary, onPrimary);
    expect(theme.datePickerTheme.headerBackgroundColor, primary);
    expect(theme.textButtonTheme.style?.foregroundColor?.resolve({}), primary);
  });
}
