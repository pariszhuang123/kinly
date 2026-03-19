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
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _MockPersonalDirectoryRepository extends Mock
    implements PersonalDirectoryRepository {}

class _FakeUrlLauncherPlatform extends UrlLauncherPlatform
    with MockPlatformInterfaceMixin {
  String? launchedUrl;
  LaunchOptions? launchOptions;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    launchOptions = options;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PersonalDirectoryNoteScreen', () {
    late _MockPersonalDirectoryRepository repository;
    late UrlLauncherPlatform previousLauncher;
    late _FakeUrlLauncherPlatform fakeLauncher;

    setUp(() {
      repository = _MockPersonalDirectoryRepository();
      previousLauncher = UrlLauncherPlatform.instance;
      fakeLauncher = _FakeUrlLauncherPlatform();
      UrlLauncherPlatform.instance = fakeLauncher;
    });

    tearDown(() {
      UrlLauncherPlatform.instance = previousLauncher;
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
      'dedicated emergency contact flow hides type selector and keeps details field visible',
      (tester) async {
        await tester.pumpWidget(
          _buildHarness(
            PersonalDirectoryNoteScreen(
              repository: repository,
              canEdit: true,
              availableNoteTypes: const [
                PersonalDirectoryNoteType.emergencyContact,
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();
        final s = _strings(tester);

        expect(
          find.text(s.personalDirectoryNoteTypeLabel),
          findsNothing,
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

    testWidgets(
      'view-only emergency contact launches dialer',
      (tester) async {
        const phoneNumber = '+64 21 111 2222';

        await tester.pumpWidget(
          _buildHarness(
            PersonalDirectoryNoteScreen(
              repository: repository,
              canEdit: false,
              note: PersonalDirectoryNote(
                id: 'emergency-1',
                noteType: PersonalDirectoryNoteType.emergencyContact,
                contactName: 'Alex',
                phoneNumber: phoneNumber,
                details: 'Call if something urgent happens.',
                createdAt: DateTime(2026, 3, 18),
                updatedAt: DateTime(2026, 3, 18),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(OutlinedButton, phoneNumber));
        await tester.pumpAndSettle();

        expect(fakeLauncher.launchedUrl, 'tel:+64211112222');
        expect(
          fakeLauncher.launchOptions?.mode,
          PreferredLaunchMode.externalApplication,
        );
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
