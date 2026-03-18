import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
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

        expect(
          find.text(
            'Add an allergy so housemates know what to avoid.',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            'Name the allergy clearly, like peanuts or penicillin.',
          ),
          findsOneWidget,
        );
        expect(find.text('Details'), findsNothing);

        await tester.tap(find.text('Other'));
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Add any other personal note that helps your housemates live with you.',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            'Give this note a short title so housemates know what it is about.',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            'Add any extra details your housemates should know.',
          ),
          findsOneWidget,
        );
        expect(find.text('Details'), findsOneWidget);
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

        expect(
          find.text(
            'Add one person your housemates can contact quickly in an emergency.',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            'Who should a housemate contact if something urgent happens?',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            'Add the best number to call or text for this person.',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            'Add any extra context that would help in an emergency.',
          ),
          findsOneWidget,
        );
        expect(find.text('Details'), findsOneWidget);
      },
    );
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
    home: child,
  );
}
