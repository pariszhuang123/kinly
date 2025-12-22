import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/kinly_bottom_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const openLabel = 'Open sheet';
  const bodyText = 'Sheet body';

  Future<void> openSheet(
    WidgetTester tester, {
    double keyboardInset = 0,
  }) async {
    final view = tester.view;
    final mediaQueryData = MediaQueryData.fromView(view).copyWith(
      viewInsets: EdgeInsets.only(bottom: keyboardInset),
    );

    await tester.pumpWidget(
      MediaQuery(
        data: mediaQueryData,
        child: MaterialApp(
          theme: buildKinlyTheme(Brightness.light),
          home: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
            body: Builder(
              builder: (context) => Center(
                child: KinlyFilledButton.text(
                  label: openLabel,
                  onPressed: () => KinlyBottomSheet.show(
                    context: context,
                    title: 'Title',
                    body: const SizedBox(
                      height: 200,
                      child: Center(child: Text(bodyText)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text(openLabel));
    await tester.pumpAndSettle();
  }

  testWidgets('rests flush against the bottom navigation bar', (tester) async {
    await openSheet(tester);

    final sheetMaterialFinder = find.descendant(
      of: find.byType(KinlyBottomSheet),
      matching: find.byType(Material),
    ).first;
    final rect = tester.getRect(sheetMaterialFinder);
    final view = tester.view;
    final screenHeight = view.physicalSize.height / view.devicePixelRatio;

    expect(rect.bottom, closeTo(screenHeight, 0.01));
  });

  testWidgets('respects keyboard viewInsets while staying anchored', (
    tester,
  ) async {
    const keyboardInset = 200.0;

    await openSheet(tester, keyboardInset: keyboardInset);

    final sheetMaterialFinder = find.descendant(
      of: find.byType(KinlyBottomSheet),
      matching: find.byType(Material),
    ).first;
    final rect = tester.getRect(sheetMaterialFinder);
    final view = tester.view;
    final screenHeight = view.physicalSize.height / view.devicePixelRatio;

    expect(rect.bottom, closeTo(screenHeight - keyboardInset, 0.01));
  });
}
