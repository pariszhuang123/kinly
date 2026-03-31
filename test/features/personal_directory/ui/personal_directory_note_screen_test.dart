import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
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

class _FakeCreatePersonalDirectoryNoteInput extends Fake
    implements CreatePersonalDirectoryNoteInput {}

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
    String? clipboardText;

    setUp(() {
      repository = _MockPersonalDirectoryRepository();
      previousLauncher = UrlLauncherPlatform.instance;
      fakeLauncher = _FakeUrlLauncherPlatform();
      UrlLauncherPlatform.instance = fakeLauncher;
      clipboardText = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            switch (call.method) {
              case 'Clipboard.setData':
                clipboardText =
                    (call.arguments as Map?)?['text'] as String?;
                return null;
              case 'Clipboard.getData':
                return <String, dynamic>{'text': clipboardText};
            }
            return null;
          });
      if (!sl.isRegistered<Logger>()) {
        sl.registerLazySingleton<Logger>(() => const DebugLogger());
      }
    });

    setUpAll(() {
      registerFallbackValue(_FakeCreatePersonalDirectoryNoteInput());
    });

    tearDown(() {
      UrlLauncherPlatform.instance = previousLauncher;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
      if (sl.isRegistered<Logger>()) {
        sl.unregister<Logger>();
      }
    });

    testWidgets('shows helper copy and hides details field for allergy notes', (
      tester,
    ) async {
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
        find.widgetWithText(KinlyChoiceChip, s.personalDirectoryAllergyTitle),
        findsOneWidget,
      );
      expect(
        _findTextFieldLabel(s.personalDirectoryAllergyLabel),
        findsOneWidget,
      );
      expect(
        _findTextFieldLabel(s.personalDirectoryDetailsLabel),
        findsNothing,
      );

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
      expect(
        _findTextFieldLabel(s.personalDirectoryDetailsLabel),
        findsOneWidget,
      );
    });

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

        expect(find.text(s.personalDirectoryNoteTypeLabel), findsNothing);
        expect(
          _findTextFieldLabel(s.personalDirectoryContactNameLabel),
          findsOneWidget,
        );
        expect(
          _findTextFieldLabel(s.personalDirectoryPhoneNumberLabel),
          findsOneWidget,
        );
        expect(
          _findTextFieldLabel(s.personalDirectoryDetailsLabel),
          findsOneWidget,
        );
      },
    );

    testWidgets('view-only emergency contact launches dialer', (tester) async {
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
    });

    testWidgets('view-only other note can copy details and open link', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildHarness(
          PersonalDirectoryNoteScreen(
            repository: repository,
            canEdit: false,
            note: PersonalDirectoryNote(
              id: 'other-1',
              noteType: PersonalDirectoryNoteType.other,
              customTitle: 'Medication',
              details: 'In the kitchen drawer.',
              referenceUrl: 'https://example.com/medication',
              createdAt: DateTime(2026, 3, 18),
              updatedAt: DateTime(2026, 3, 18),
            ),
          ),
        ),
      );

      await tester.pump();
      final s = _strings(tester);

      expect(
        find.widgetWithText(OutlinedButton, s.shareOwedCopyCta),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(OutlinedButton, s.houseDirectoryOpenLink),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(OutlinedButton, s.shareOwedCopyCta));
      await tester.pump();

      final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
      expect(clipboard?.text, 'In the kitchen drawer.');

      await tester.tap(
        find.widgetWithText(OutlinedButton, s.houseDirectoryOpenLink),
      );
      await tester.pump();

      expect(fakeLauncher.launchedUrl, 'https://example.com/medication');
      expect(
        fakeLauncher.launchOptions?.mode,
        PreferredLaunchMode.externalApplication,
      );
    });

    testWidgets(
      'editing an existing other note swaps archive for edit when fields change',
      (tester) async {
        await tester.pumpWidget(
          _buildHarness(
            PersonalDirectoryNoteScreen(
              repository: repository,
              canEdit: true,
              note: PersonalDirectoryNote(
                id: 'other-1',
                noteType: PersonalDirectoryNoteType.other,
                customTitle: 'Medication',
                details: 'In the kitchen drawer.',
                createdAt: DateTime(2026, 3, 18),
                updatedAt: DateTime(2026, 3, 18),
              ),
              availableNoteTypes: const [PersonalDirectoryNoteType.other],
            ),
          ),
        );

        await tester.pumpAndSettle();
        final s = _strings(tester);

        expect(find.text(s.houseDirectoryArchiveConfirm), findsOneWidget);
        expect(find.text(s.shoppingSubmitEdit), findsNothing);

        await tester.enterText(
          find.byType(TextField).first,
          'Medication updated',
        );
        await tester.pump();

        expect(find.text(s.houseDirectoryArchiveConfirm), findsNothing);
        expect(find.text(s.shoppingSubmitEdit), findsOneWidget);
      },
    );

    testWidgets('existing allergy note hides the type selector', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildHarness(
          PersonalDirectoryNoteScreen(
            repository: repository,
            canEdit: true,
            note: PersonalDirectoryNote(
              id: 'allergy-1',
              noteType: PersonalDirectoryNoteType.allergy,
              label: 'Peanuts',
              createdAt: DateTime(2026, 3, 18),
              updatedAt: DateTime(2026, 3, 18),
            ),
            availableNoteTypes: const [PersonalDirectoryNoteType.allergy],
          ),
        ),
      );

      await tester.pumpAndSettle();
      final s = _strings(tester);

      expect(find.text(s.personalDirectoryNoteTypeLabel), findsNothing);
      expect(
        find.widgetWithText(
          KinlyChoiceChip,
          s.personalDirectoryEmergencyContactTitle,
        ),
        findsNothing,
      );
      expect(
        _findTextFieldLabel(s.houseDirectoryNoteUrlLabel),
        findsNothing,
      );
    });

    testWidgets('other note can save with title only', (tester) async {
      when(() => repository.createNote(any())).thenAnswer(
        (_) async => PersonalDirectoryNote(
          id: 'other-1',
          noteType: PersonalDirectoryNoteType.other,
          customTitle: 'Medication',
          details: null,
          createdAt: DateTime(2026, 3, 18),
          updatedAt: DateTime(2026, 3, 18),
        ),
      );

      await tester.pumpWidget(
        _buildNavigatorHarness(
          (context) => PersonalDirectoryNoteScreen(
            repository: repository,
            canEdit: true,
            availableNoteTypes: const [PersonalDirectoryNoteType.other],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final s = _strings(tester);

      await tester.enterText(find.byType(TextField).first, 'Medication');
      await tester.tap(find.text(s.personalDirectorySave));
      await tester.pumpAndSettle();

      verify(() => repository.createNote(any())).called(1);
      expect(find.text(s.personalDirectoryNoteValidation), findsNothing);
      expect(find.byType(PersonalDirectoryNoteScreen), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}

Finder _findTextFieldLabel(String label) {
  return find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.labelText == label,
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

class _NavigatorPushHarness extends StatefulWidget {
  const _NavigatorPushHarness({required this.builder});

  final WidgetBuilder builder;

  @override
  State<_NavigatorPushHarness> createState() => _NavigatorPushHarnessState();
}

class _NavigatorPushHarnessState extends State<_NavigatorPushHarness> {
  bool _pushed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pushed) return;
    _pushed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(
        context,
      ).push<void>(MaterialPageRoute<void>(builder: widget.builder));
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

Widget _buildNavigatorHarness(WidgetBuilder builder) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: _NavigatorPushHarness(builder: builder),
  );
}
