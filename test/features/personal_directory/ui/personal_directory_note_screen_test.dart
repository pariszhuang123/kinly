import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/core/ui/inputs/kinly_choice_chip.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_note_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:mocktail/mocktail.dart';

class _MockPersonalDirectoryRepository extends Mock
    implements PersonalDirectoryRepository {}

void main() {
  group('PersonalDirectoryNoteScreen', () {
    late _MockPersonalDirectoryRepository repository;

    setUp(() {
      repository = _MockPersonalDirectoryRepository();
    });

    testWidgets(
      'shows helper copy and hides details field for allergy notes',
      (tester) async {
        await tester.pumpWidget(
          _buildHarness(
            PersonalDirectoryNoteScreen(
              repository: repository,
              canEdit: true,
              availableNoteTypes: const [
                PersonalDirectoryNoteType.allergy,
                PersonalDirectoryNoteType.other,
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        final s = _strings(tester);

        expect(
          find.widgetWithText(
            KinlyChoiceChip,
            s.personalDirectoryAllergyTitle,
          ),
          findsOneWidget,
        );
        expect(_findTextFieldLabel(s.personalDirectoryAllergyLabel), findsOneWidget);
        expect(_findTextFieldLabel(s.personalDirectoryDetailsLabel), findsNothing);

        await tester.tap(find.text(s.personalDirectoryOtherTitle));
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(KinlyChoiceChip, s.personalDirectoryOtherTitle),
          findsOneWidget,
        );
        expect(
          _findTextFieldLabel(s.personalDirectoryNoteTitleLabel),
          findsOneWidget,
        );
        expect(_findTextFieldLabel(s.personalDirectoryDetailsLabel), findsOneWidget);
      },
    );

    testWidgets(
      'shows emergency contact guidance and keeps details field visible',
      (tester) async {
        await tester.pumpWidget(
          _buildHarness(
            PersonalDirectoryNoteScreen(
              repository: repository,
              canEdit: true,
              availableNoteTypes: const [
                PersonalDirectoryNoteType.emergencyContact,
                PersonalDirectoryNoteType.other,
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        final s = _strings(tester);

        expect(
          find.widgetWithText(
            KinlyChoiceChip,
            s.personalDirectoryEmergencyContactTitle,
          ),
          findsOneWidget,
        );
        expect(
          _findTextFieldLabel(s.personalDirectoryContactNameLabel),
          findsOneWidget,
        );
        expect(
          _findTextFieldLabel(s.personalDirectoryPhoneNumberLabel),
          findsOneWidget,
        );
        expect(_findTextFieldLabel(s.personalDirectoryDetailsLabel), findsOneWidget);
      },
    );
  });
}

Finder _findTextFieldLabel(String label) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is TextField && widget.decoration?.labelText == label,
    description: 'TextField with label "$label"',
  );
}

S _strings(WidgetTester tester) {
  final context = tester.element(find.byType(PersonalDirectoryNoteScreen));
  return S.of(context);
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
    home: child,
  );
}
