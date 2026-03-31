import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/contracts/personal_directory/route_args.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/personal_directory/bloc/personal_directory_bloc.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_note_screen.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _MockPersonalDirectoryBloc
    extends MockBloc<PersonalDirectoryEvent, PersonalDirectoryState>
    implements PersonalDirectoryBloc {}

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

  setUpAll(() {
    registerFallbackValue(const PersonalDirectoryStarted());
  });

  group('PersonalDirectoryScreen', () {
    late _MockPersonalDirectoryBloc bloc;
    late _MockPersonalDirectoryRepository repository;
    late UrlLauncherPlatform previousLauncher;
    late _FakeUrlLauncherPlatform fakeLauncher;

    setUp(() {
      bloc = _MockPersonalDirectoryBloc();
      repository = _MockPersonalDirectoryRepository();
      previousLauncher = UrlLauncherPlatform.instance;
      fakeLauncher = _FakeUrlLauncherPlatform();
      UrlLauncherPlatform.instance = fakeLauncher;
    });

    tearDown(() {
      UrlLauncherPlatform.instance = previousLauncher;
    });

    testWidgets(
      'add note flow only shows allergy and other types',
      (tester) async {
        final state = _buildState(notes: [
          _note(
            id: 'emergency-1',
            type: PersonalDirectoryNoteType.emergencyContact,
            contactName: 'Alex',
            phoneNumber: '+64 21 111 2222',
          ),
        ]);
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(),
                  ),
            ),
            GoRoute(
              path: '/note',
              name: AppRouteNames.personalDirectoryNote,
              builder: (_, routeState) {
                final args =
                    routeState.extra as PersonalDirectoryNoteRouteArgs;
                return PersonalDirectoryNoteScreen(
                  repository: repository,
                  canEdit: args.canEdit,
                  note: args.note,
                  availableNoteTypes: args.availableNoteTypes,
                );
              },
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Add note'));
        await tester.pumpAndSettle();

        expect(find.text('Emergency contact'), findsNothing);
        expect(
          find.text('Add an allergy so housemates know what to avoid.'),
          findsOneWidget,
        );
        expect(find.text('Other'), findsOneWidget);
      },
    );

    testWidgets(
      'emergency contact card shows tappable phone number without duplicate pill label',
      (tester) async {
        const phoneNumber = '+64 21 111 2222';
        final state = _buildState(notes: [
          _note(
            id: 'emergency-1',
            type: PersonalDirectoryNoteType.emergencyContact,
            contactName: 'Alex',
            phoneNumber: phoneNumber,
            details: 'Call first.',
          ),
          _note(
            id: 'other-1',
            type: PersonalDirectoryNoteType.other,
            customTitle: 'Medication',
            details: 'In the kitchen drawer.',
          ),
        ]);
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(),
                  ),
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        expect(find.text('Emergency contact'), findsOneWidget);
        expect(find.text(phoneNumber), findsOneWidget);
        expect(find.text('Call first.'), findsOneWidget);
        expect(find.text('Edit'), findsNothing);
        expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);

        await tester.tap(find.text(phoneNumber));
        await tester.pumpAndSettle();

        expect(fakeLauncher.launchedUrl, 'tel:+64211112222');
        expect(
          fakeLauncher.launchOptions?.mode,
          PreferredLaunchMode.externalApplication,
        );
      },
    );

    testWidgets(
      'self emergency contact card opens note screen for editing',
      (tester) async {
        final state = _buildState(notes: [
          _note(
            id: 'emergency-1',
            type: PersonalDirectoryNoteType.emergencyContact,
            contactName: 'Alex',
            phoneNumber: '+64 21 111 2222',
          ),
        ]);
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(),
                  ),
            ),
            GoRoute(
              path: '/note',
              name: AppRouteNames.personalDirectoryNote,
              builder: (_, routeState) {
                final args =
                    routeState.extra as PersonalDirectoryNoteRouteArgs;
                return Text(args.canEdit ? 'editable note' : 'readonly note');
              },
            ),
            GoRoute(
              path: '/bank',
              name: AppRouteNames.personalDirectoryBank,
              builder: (_, routeState) {
                final args =
                    routeState.extra as PersonalDirectoryBankRouteArgs;
                return Text(args.canEdit ? 'editable bank' : 'readonly bank');
              },
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Emergency contact'));
        await tester.pumpAndSettle();

        expect(find.text('editable note'), findsOneWidget);
      },
    );

    testWidgets(
      'editable self sees empty emergency contact card and can open create flow',
      (tester) async {
        final state = _buildState(notes: const []);
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(canEdit: true),
                  ),
            ),
            GoRoute(
              path: '/note',
              name: AppRouteNames.personalDirectoryNote,
              builder: (_, routeState) {
                final args =
                    routeState.extra as PersonalDirectoryNoteRouteArgs;
                return Text(
                  args.availableNoteTypes.length == 1 &&
                          args.availableNoteTypes.first ==
                              PersonalDirectoryNoteType.emergencyContact
                      ? 'create emergency contact'
                      : 'other route',
                );
              },
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        expect(find.text('Emergency contact'), findsOneWidget);
        expect(find.text('Add note'), findsOneWidget);

        await tester.tap(find.text('Emergency contact'));
        await tester.pumpAndSettle();

        expect(find.text('create emergency contact'), findsOneWidget);
      },
    );

    testWidgets(
      'read-only self hides empty bank and emergency cards',
      (tester) async {
        final state = _buildState(notes: const []);
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(canEdit: false),
                  ),
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        expect(find.text('Bank account'), findsNothing);
        expect(find.text('Emergency contact'), findsNothing);
      },
    );

    testWidgets(
      'read-only self shows bank card when bank details exist',
      (tester) async {
        final state = _buildState(
          notes: const [],
          bankAccount: PersonalDirectoryBankAccount(
            id: 'bank-1',
            accountHolderName: 'Alex',
            accountNumber: '12-1234-1234567-00',
            createdAt: DateTime(2026, 3, 18),
            updatedAt: DateTime(2026, 3, 18),
          ),
        );
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(canEdit: false),
                  ),
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        expect(find.text('Bank account'), findsOneWidget);
        expect(find.text('Alex'), findsAtLeastNWidgets(1));
        expect(find.text('12-1234-1234567-00'), findsOneWidget);
        expect(find.text('Emergency contact'), findsNothing);
      },
    );

    testWidgets(
      'read-only self shows emergency card when contact exists',
      (tester) async {
        const phoneNumber = '+64 21 111 2222';
        final state = _buildState(notes: [
          _note(
            id: 'emergency-1',
            type: PersonalDirectoryNoteType.emergencyContact,
            contactName: 'Alex',
            phoneNumber: phoneNumber,
            details: 'Call first.',
          ),
        ]);
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(canEdit: false),
                  ),
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        expect(find.text('Bank account'), findsNothing);
        expect(find.text('Emergency contact'), findsOneWidget);
        expect(find.text(phoneNumber), findsOneWidget);
      },
    );

    testWidgets(
      'self bank card opens bank screen for editing',
      (tester) async {
        final state = _buildState(
          notes: const [],
          bankAccount: PersonalDirectoryBankAccount(
            id: 'bank-1',
            accountHolderName: 'Alex',
            accountNumber: '12-1234-1234567-00',
            createdAt: DateTime(2026, 3, 18),
            updatedAt: DateTime(2026, 3, 18),
          ),
        );
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(),
                  ),
            ),
            GoRoute(
              path: '/bank',
              name: AppRouteNames.personalDirectoryBank,
              builder: (_, routeState) {
                final args =
                    routeState.extra as PersonalDirectoryBankRouteArgs;
                return Text(args.canEdit ? 'editable bank' : 'readonly bank');
              },
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Bank account'));
        await tester.pumpAndSettle();

        expect(find.text('editable bank'), findsOneWidget);
      },
    );

    testWidgets(
      'editable self renders bank and emergency cards in the editable grid',
      (tester) async {
        final state = _buildState(
          notes: [
            _note(
              id: 'emergency-1',
              type: PersonalDirectoryNoteType.emergencyContact,
              contactName: 'Alex',
              phoneNumber: '+64 21 111 2222',
              details: 'Call first.',
            ),
          ],
          bankAccount: PersonalDirectoryBankAccount(
            id: 'bank-1',
            accountHolderName: 'Alex',
            accountNumber: '12-1234-1234567-00',
            createdAt: DateTime(2026, 3, 18),
            updatedAt: DateTime(2026, 3, 18),
          ),
        );
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(canEdit: true),
                  ),
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        expect(find.byType(Wrap), findsWidgets);
        expect(find.text('Bank account'), findsOneWidget);
        expect(find.text('Emergency contact'), findsOneWidget);
      },
    );

    testWidgets(
      'allergy and other notes use pill browsing when search is inactive',
      (tester) async {
        final state = _buildState(notes: [
          _note(
            id: 'allergy-1',
            type: PersonalDirectoryNoteType.allergy,
            label: 'Peanuts',
            details: 'Carries antihistamines.',
          ),
          _note(
            id: 'other-1',
            type: PersonalDirectoryNoteType.other,
            customTitle: 'Medication',
            details: 'In the kitchen drawer.',
          ),
        ]);
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(),
                  ),
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        expect(find.text('Peanuts'), findsOneWidget);
        expect(find.text('Medication'), findsNothing);

        await tester.tap(find.text('Other'));
        await tester.pumpAndSettle();

        expect(find.text('Medication'), findsOneWidget);
      },
    );

    testWidgets(
      'search field is hidden when there are no allergy or other notes',
      (tester) async {
        final state = _buildState(notes: [
          _note(
            id: 'emergency-1',
            type: PersonalDirectoryNoteType.emergencyContact,
            contactName: 'Alex',
            phoneNumber: '+64 21 111 2222',
          ),
        ]);
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(),
                  ),
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        expect(find.text('Search notes'), findsNothing);
      },
    );

    testWidgets(
      'single note type shows label without pills and no duplicate section title',
      (tester) async {
        final state = _buildState(notes: [
          _note(
            id: 'allergy-1',
            type: PersonalDirectoryNoteType.allergy,
            label: 'Peanuts',
            details: 'Carries antihistamines.',
          ),
        ]);
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<PersonalDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<PersonalDirectoryBloc>.value(
                    value: bloc,
                    child: const PersonalDirectoryScreen(),
                  ),
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();

        expect(find.text('Allergy'), findsOneWidget);
        expect(find.text('Other'), findsNothing);
        expect(find.text('Peanuts'), findsOneWidget);
      },
    );

  });
}

Widget _buildRouterHarness(GoRouter router) {
  return MaterialApp.router(
    theme: buildKinlyTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    routerConfig: router,
  );
}

PersonalDirectoryState _buildState({
  required List<PersonalDirectoryNote> notes,
  PersonalDirectoryBankAccount? bankAccount,
  String currentUserId = 'user-1',
}) {
  return PersonalDirectoryState(
    status: PersonalDirectoryStatus.success,
    target: const PersonalDirectoryMemberSummary(
      userId: 'user-1',
      username: 'Alex',
      isHomeOwner: false,
    ),
    currentUserId: currentUserId,
    bankAccount: bankAccount,
    notes: notes,
  );
}

PersonalDirectoryNote _note({
  required String id,
  required PersonalDirectoryNoteType type,
  String? label,
  String? customTitle,
  String? contactName,
  String? phoneNumber,
  String? details,
  String? referenceUrl,
}) {
  final timestamp = DateTime(2026, 3, 18);
  return PersonalDirectoryNote(
    id: id,
    noteType: type,
    label: label,
    customTitle: customTitle,
    contactName: contactName,
    phoneNumber: phoneNumber,
    details: details,
    referenceUrl: referenceUrl,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}
