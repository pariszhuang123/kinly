import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_details_screen.dart';
import 'package:kinly/features/house_directory/ui/house_directory_route_args.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/theme/kinly_theme.dart';
import 'package:mocktail/mocktail.dart';

class _MockHouseDirectoryBloc
    extends MockBloc<HouseDirectoryEvent, HouseDirectoryState>
    implements HouseDirectoryBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const HouseDirectoryStarted());
  });

  group('HouseDirectoryDetailsScreen', () {
    late _MockHouseDirectoryBloc bloc;

    setUp(() {
      bloc = _MockHouseDirectoryBloc();
    });

    testWidgets('defaults to segmented browse mode and switches sections', (
      tester,
    ) async {
      final state = _buildState();
      when(() => bloc.state).thenReturn(state);
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildHarness(bloc));
      await tester.pumpAndSettle();
      final s = _strings(tester);

      expect(find.text('Searching all house details'), findsNothing);
      expect(find.text('Landlord'), findsOneWidget);
      expect(find.text('Move-in checklist'), findsNothing);
      expect(find.text('How to reset the boiler'), findsNothing);

      await tester.tap(find.text(s.houseDirectoryNotesTitle));
      await tester.pumpAndSettle();

      expect(find.text('Move-in checklist'), findsOneWidget);
      expect(find.text('Landlord'), findsNothing);

      await tester.tap(find.text('Tutorials'));
      await tester.pumpAndSettle();

      expect(find.text('How to reset the boiler'), findsOneWidget);
      expect(find.text('Move-in checklist'), findsNothing);
    });

    testWidgets('search switches to stacked all-results mode and clear restores browse mode', (
      tester,
    ) async {
      final state = _buildState();
      when(() => bloc.state).thenReturn(state);
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildHarness(bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tutorials'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'reset');
      await tester.pumpAndSettle();
      final s = _strings(tester);

      expect(find.text('Searching all house details'), findsOneWidget);
      expect(find.text('How to reset the boiler'), findsOneWidget);
      expect(find.text(s.houseDirectoryTutorialsTitle), findsAtLeastNWidgets(1));
      expect(find.text(s.houseDirectoryNotesTitle), findsNothing);
      expect(find.text(s.houseDirectoryServicesTitle), findsNothing);

      final clearButton = find.byTooltip('Clear');
      if (clearButton.evaluate().isNotEmpty) {
        await tester.tap(clearButton);
      } else {
        await tester.enterText(find.byType(TextField), '');
      }
      await tester.pumpAndSettle();

      expect(find.text('Searching all house details'), findsNothing);
      expect(find.text('How to reset the boiler'), findsOneWidget);
      expect(find.text('Move-in checklist'), findsNothing);
    });

    testWidgets(
      'empty browse mode keeps pills visible and shows section-specific empty copy',
      (tester) async {
        final state = _buildEmptyState();
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<HouseDirectoryState>.empty(),
          initialState: state,
        );

        await tester.pumpWidget(_buildHarness(bloc));
        await tester.pumpAndSettle();
        final s = _strings(tester);

        expect(find.text(s.houseDirectoryServicesTitle), findsOneWidget);
        expect(find.text(s.houseDirectoryNotesTitle), findsOneWidget);
        expect(find.text(s.houseDirectoryTutorialsTitle), findsOneWidget);
        expect(find.text(s.houseDirectoryServicesEmpty), findsOneWidget);
        expect(find.text(s.houseDirectoryAddService), findsOneWidget);
        expect(find.byType(TextField), findsNothing);

        await tester.tap(find.text(s.houseDirectoryNotesTitle));
        await tester.pumpAndSettle();

        expect(find.text(s.houseDirectoryNotesEmpty), findsOneWidget);
        expect(find.text(s.houseDirectoryAddNote), findsOneWidget);

        await tester.tap(find.text(s.houseDirectoryTutorialsTitle));
        await tester.pumpAndSettle();

        expect(find.text(s.houseDirectoryTutorialsEmpty), findsOneWidget);
        expect(find.text(s.houseDirectoryAddTutorial), findsOneWidget);
      },
    );

    testWidgets(
      'returned route results show mutation snackbars',
      (tester) async {
        final state = _buildState();
        when(() => bloc.state).thenReturn(state);
        whenListen(
          bloc,
          const Stream<HouseDirectoryState>.empty(),
          initialState: state,
        );

        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder:
                  (_, __) => BlocProvider<HouseDirectoryBloc>.value(
                    value: bloc,
                    child: const HouseDirectoryDetailsScreen(homeId: 'home-1'),
                  ),
              routes: [
                GoRoute(
                  path: 'service',
                  name: AppRouteNames.houseDirectoryService,
                  builder: (_, routeState) {
                    final args =
                        routeState.extra as HouseDirectoryServiceRouteArgs?;
                    return _ResultRouteScreen(
                      result:
                          args?.serviceId == null
                              ? HouseDirectoryRouteResult.serviceCreated
                              : HouseDirectoryRouteResult.serviceArchived,
                    );
                  },
                ),
                GoRoute(
                  path: 'note',
                  name: AppRouteNames.houseDirectoryNote,
                  builder: (_, routeState) {
                    final args =
                        routeState.extra as HouseDirectoryNoteRouteArgs?;
                    final result = switch ((args?.noteId, args?.initialNoteType)) {
                      (null, HouseDirectoryNoteType.tutorial) =>
                        HouseDirectoryRouteResult.tutorialCreated,
                      ('tutorial-1', HouseDirectoryNoteType.tutorial) =>
                        HouseDirectoryRouteResult.tutorialArchived,
                      (_, _) => HouseDirectoryRouteResult.noteArchived,
                    };
                    return _ResultRouteScreen(result: result);
                  },
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(_buildRouterHarness(router));
        await tester.pumpAndSettle();
        final s = _strings(tester);

        await tester.tap(find.text(s.houseDirectoryAddService));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Return result'));
        await tester.pumpAndSettle();

        expect(find.text(s.houseDirectoryServiceSaved), findsOneWidget);
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle();

        await tester.tap(find.text(s.houseDirectoryNotesTitle));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Move-in checklist'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Return result'));
        await tester.pumpAndSettle();

        expect(find.text(s.houseDirectoryNoteArchived), findsOneWidget);
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle();

        await tester.tap(find.text(s.houseDirectoryTutorialsTitle));
        await tester.pumpAndSettle();
        await tester.tap(find.text(s.houseDirectoryAddTutorial));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Return result'));
        await tester.pumpAndSettle();

        expect(find.text(s.houseDirectoryNoteSaved), findsOneWidget);
      },
    );

    testWidgets('owner opens existing note directly in edit mode', (
      tester,
    ) async {
      final state = _buildState();
      when(() => bloc.state).thenReturn(state);
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: state,
      );

      HouseDirectoryNoteRouteArgs? receivedArgs;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder:
                (_, __) => BlocProvider<HouseDirectoryBloc>.value(
                  value: bloc,
                  child: const HouseDirectoryDetailsScreen(homeId: 'home-1'),
                ),
            routes: [
              GoRoute(
                path: 'note',
                name: AppRouteNames.houseDirectoryNote,
                builder: (_, routeState) {
                  receivedArgs = routeState.extra as HouseDirectoryNoteRouteArgs?;
                  return const Scaffold(body: Text('note-route'));
                },
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(_buildRouterHarness(router));
      await tester.pumpAndSettle();

      final s = _strings(tester);
      await tester.tap(find.text(s.houseDirectoryNotesTitle));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Move-in checklist'));
      await tester.pumpAndSettle();

      expect(find.text('note-route'), findsOneWidget);
      expect(receivedArgs?.noteId, 'note-1');
      expect(receivedArgs?.startInEditMode, isTrue);
    });

    testWidgets('non-owner opens existing note in read-only mode', (
      tester,
    ) async {
      final state = _buildState(isOwner: false);
      when(() => bloc.state).thenReturn(state);
      whenListen(
        bloc,
        const Stream<HouseDirectoryState>.empty(),
        initialState: state,
      );

      HouseDirectoryNoteRouteArgs? receivedArgs;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder:
                (_, __) => BlocProvider<HouseDirectoryBloc>.value(
                  value: bloc,
                  child: const HouseDirectoryDetailsScreen(homeId: 'home-1'),
                ),
            routes: [
              GoRoute(
                path: 'note',
                name: AppRouteNames.houseDirectoryNote,
                builder: (_, routeState) {
                  receivedArgs = routeState.extra as HouseDirectoryNoteRouteArgs?;
                  return const Scaffold(body: Text('note-route'));
                },
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(_buildRouterHarness(router));
      await tester.pumpAndSettle();

      final s = _strings(tester);
      await tester.tap(find.text(s.houseDirectoryNotesTitle));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Move-in checklist'));
      await tester.pumpAndSettle();

      expect(find.text('note-route'), findsOneWidget);
      expect(receivedArgs?.noteId, 'note-1');
      expect(receivedArgs?.startInEditMode, isFalse);
    });
  });
}

class _ResultRouteScreen extends StatelessWidget {
  const _ResultRouteScreen({required this.result});

  final HouseDirectoryRouteResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.of(context).pop(result),
          child: const Text('Return result'),
        ),
      ),
    );
  }
}

Widget _buildHarness(HouseDirectoryBloc bloc) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: BlocProvider<HouseDirectoryBloc>.value(
      value: bloc,
      child: const HouseDirectoryDetailsScreen(homeId: 'home-1'),
    ),
  );
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

S _strings(WidgetTester tester) {
  final context = tester.element(find.byType(HouseDirectoryDetailsScreen));
  return S.of(context);
}

HouseDirectoryState _buildState({bool isOwner = true}) {
  final now = DateTime(2026, 3, 14);
  return HouseDirectoryState(
    status: HouseDirectoryStatus.success,
    isOwner: isOwner,
    services: [
      HouseDirectoryService(
        id: 'service-1',
        homeId: 'home-1',
        serviceType: HouseDirectoryServiceType.rent,
        providerName: 'Landlord',
        createdAt: now,
        updatedAt: now,
      ),
    ],
    notes: [
      HouseDirectoryNote(
        id: 'note-1',
        homeId: 'home-1',
        title: 'Move-in checklist',
        details: 'How to settle into the house',
        noteType: HouseDirectoryNoteType.general,
        createdAt: now,
        updatedAt: now,
      ),
    ],
    tutorials: [
      HouseDirectoryNote(
        id: 'tutorial-1',
        homeId: 'home-1',
        title: 'How to reset the boiler',
        details: 'Hold the reset button for ten seconds',
        noteType: HouseDirectoryNoteType.tutorial,
        createdAt: now,
        updatedAt: now,
      ),
    ],
    members: const [],
    reminders: const [],
  );
}

HouseDirectoryState _buildEmptyState() {
  return HouseDirectoryState(
    status: HouseDirectoryStatus.success,
    isOwner: true,
    services: const [],
    notes: const [],
    tutorials: const [],
    members: const [],
    reminders: const [],
  );
}
