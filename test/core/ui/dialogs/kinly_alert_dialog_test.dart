import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/theme/elevation.dart';
import 'package:kinly/core/theme/radius.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/dialogs/kinly_alert_dialog.dart';

void main() {
  const spacing = Spacing(
    xxs: 2,
    xs: 4,
    s: 8,
    m: 12,
    l: 16,
    xl: 24,
    xxl: 32,
    xxxl: 40,
  );
  const corners = Corners(xs: 4, sm: 8, md: 12, lg: 16, xl: 24, pill: 999);
  const elevations = Elevations(
    level0: 0,
    level1: 1,
    level2: 3,
    level3: 6,
    level4: 10,
    level5: 16,
  );

  testWidgets('KinlyAlertDialog uses token radius and renders actions in RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Theme(
          data: ThemeData(
            extensions: const [spacing, corners, elevations],
          ),
          child: Scaffold(
            body: KinlyAlertDialog.confirm(
              title: 'Title',
              message: 'Message',
              primaryLabel: 'Confirm',
              secondaryLabel: 'Cancel',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
    final shape = dialog.shape as RoundedRectangleBorder?;
    final radius = shape?.borderRadius.resolve(TextDirection.rtl).topLeft.x;

    expect(radius, closeTo(corners.large, 0.001));
    expect(find.text('Confirm'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });
}
