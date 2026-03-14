import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/features/house_directory/ui/house_directory_forms.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/theme/kinly_theme.dart';

void main() {
  group('showHouseDirectoryWifiSheet', () {
    testWidgets('returns null password when the password field is left blank', (
      tester,
    ) async {
      UpsertHouseDirectoryWifiInput? result;

      await tester.pumpWidget(
        _buildHarness(
          onOpen: (context) async {
            result = await showHouseDirectoryWifiSheet(
              context,
              homeId: 'home-1',
            );
            return result;
          },
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Guest Wifi');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.ssid, 'Guest Wifi');
      expect(result!.password, isNull);
    });

    testWidgets('prefills ssid for edits without exposing the password', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildHarness(
          onOpen: (context) {
            return showHouseDirectoryWifiSheet(
              context,
              homeId: 'home-1',
              wifi: HouseDirectoryWifi(
                id: 'wifi-1',
                homeId: 'home-1',
                ssid: 'Existing Wifi',
                qrPayload: 'WIFI:T:WPA;S:Existing Wifi;P:test;;',
                createdAt: DateTime(2026, 3, 14),
                updatedAt: DateTime(2026, 3, 14),
              ),
            );
          },
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final textFields = tester.widgetList<TextField>(find.byType(TextField)).toList();
      expect(textFields[0].controller?.text, 'Existing Wifi');
      expect(textFields[1].controller?.text, isEmpty);
    });
  });
}

Widget _buildHarness({
  required Future<Object?> Function(BuildContext context) onOpen,
}) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return Center(
            child: TextButton(
              onPressed: () => onOpen(context),
              child: const Text('Open'),
            ),
          );
        },
      ),
    ),
  );
}
