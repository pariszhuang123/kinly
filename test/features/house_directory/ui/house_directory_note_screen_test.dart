import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/features/house_directory/ui/house_directory_note_screen_content.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/theme/kinly_theme.dart';

void main() {
  group('HouseDirectoryNoteReadOnlyContent', () {
    testWidgets('hides details field when details are empty', (tester) async {
      await tester.pumpWidget(
        _buildHarness(
          const HouseDirectoryNoteReadOnlyContent(
            title: 'Move-in checklist',
            details: '',
            referenceUrl: '',
            photoUrl: '',
          ),
        ),
      );
      await tester.pumpAndSettle();

      final s = _strings(tester);
      expect(find.text(s.houseDirectoryTitleLabel), findsOneWidget);
      expect(find.text('Move-in checklist'), findsOneWidget);
      expect(find.text(s.houseDirectoryNoteDetailsLabel), findsNothing);
    });
  });
}

Widget _buildHarness(Widget child) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(body: child),
  );
}

S _strings(WidgetTester tester) {
  final context = tester.element(find.byType(HouseDirectoryNoteReadOnlyContent));
  return S.of(context);
}
