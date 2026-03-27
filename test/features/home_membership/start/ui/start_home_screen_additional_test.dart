import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/features/home_membership/start/ui/start_home_screen.dart';
import 'package:kinly/features/home_membership/start/bloc/start_home_bloc.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/app/router/app_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/auth/models/user_context.dart';
import 'package:kinly/contracts/auth/ports/user_context_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/house_norms/routes/house_norm_onboarding_args.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockStartHomeBloc extends MockBloc<StartHomeEvent, StartHomeState>
    implements StartHomeBloc {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

class _FakeAuthState extends Fake implements AuthState {}

class _FakeUserContextRepository implements UserContextRepository {
  @override
  Future<UserContext> fetch() async => const UserContext(
        userId: 'user-ctx',
        hasPreferenceReport: false,
        hasPersonalMentions: false,
        hasPersonalDirectoryContent: false,
        avatarUrl: null,
      );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthEvent());
    registerFallbackValue(_FakeAuthState());
  });

  late _MockAuthBloc authBloc;
  late _MockStartHomeBloc startHomeBloc;

  setUp(() async {
    await sl.reset();
    sl.registerLazySingleton<UserContextRepository>(
      () => _FakeUserContextRepository(),
    );

    authBloc = _MockAuthBloc();
    startHomeBloc = _MockStartHomeBloc();
    when(
      () => authBloc.stream,
    ).thenAnswer((_) => const Stream<AuthState>.empty());
    when(
      () => authBloc.state,
    ).thenReturn(const AuthState(membershipStatus: AuthMembershipStatus.none));
  });

  tearDown(() async {
    await sl.reset();
  });

  Widget buildApp() {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<StartHomeBloc>.value(value: startHomeBloc),
        ],
        child: const StartHomeScreen(),
      ),
    );
  }

  testWidgets('when start home succeeds, membership refresh is requested', (
    tester,
  ) async {
    when(() => startHomeBloc.state).thenReturn(const StartHomeState());
    whenListen(
      startHomeBloc,
      Stream<StartHomeState>.fromIterable(const [
        StartHomeState(status: StartHomeStatus.loading),
        StartHomeState(status: StartHomeStatus.success),
      ]),
      initialState: const StartHomeState(),
    );

    await tester.pumpWidget(buildApp());
    await tester.pump();

    verify(
      () => authBloc.add(const AuthMembershipRefreshRequested()),
    ).called(1);
  });

  testWidgets('join button navigates to join route', (tester) async {
    when(() => startHomeBloc.state).thenReturn(const StartHomeState());
    when(
      () => startHomeBloc.stream,
    ).thenAnswer((_) => const Stream<StartHomeState>.empty());
    when(
      () => authBloc.state,
    ).thenReturn(const AuthState(membershipStatus: AuthMembershipStatus.none));

    final router = GoRouter(
      initialLocation: AppRoutes.start,
      routes: [
        GoRoute(
          path: AppRoutes.start,
          name: AppRouteNames.start,
          builder:
              (_, __) => MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(value: authBloc),
                  BlocProvider<StartHomeBloc>.value(value: startHomeBloc),
                ],
                child: const StartHomeScreen(),
              ),
        ),
        GoRoute(
          path: AppRoutes.join,
          name: AppRouteNames.join,
          builder: (_, __) => const Scaffold(body: Text('join-screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        routerConfig: router,
      ),
    );

    await tester.pump();
    await tester.tap(find.text(S.current.welcome_join));
    await tester.pumpAndSettle();

    expect(find.text('join-screen'), findsOneWidget);
  });

  testWidgets(
    'start home success refreshes membership and does not auto-navigate to house norms',
    (tester) async {
      when(() => startHomeBloc.state).thenReturn(const StartHomeState());
      whenListen(
        startHomeBloc,
        Stream<StartHomeState>.fromIterable(const [
          StartHomeState(status: StartHomeStatus.loading),
          StartHomeState(status: StartHomeStatus.success),
        ]),
        initialState: const StartHomeState(),
      );

      final router = GoRouter(
        initialLocation: AppRoutes.start,
        routes: [
          GoRoute(
            path: AppRoutes.start,
            name: AppRouteNames.start,
            builder:
                (_, __) => MultiBlocProvider(
                  providers: [
                    BlocProvider<AuthBloc>.value(value: authBloc),
                    BlocProvider<StartHomeBloc>.value(value: startHomeBloc),
                  ],
                  child: const StartHomeScreen(),
                ),
          ),
          GoRoute(
            path: AppRoutes.houseNormsOnboarding,
            name: AppRouteNames.houseNormsOnboarding,
            builder: (_, state) {
              final args = state.extra as HouseNormOnboardingArgs?;
              return Text(
                'house-norms:${args?.entrySource ?? 'none'}',
              );
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: buildKinlyTheme(Brightness.light),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StartHomeScreen), findsOneWidget);
      expect(find.textContaining('house-norms:'), findsNothing);
      verify(
        () => authBloc.add(const AuthMembershipRefreshRequested()),
      ).called(1);
    },
  );

  testWidgets('start home success routes to fit check attach when draft is pending', (
    tester,
  ) async {
    when(() => startHomeBloc.state).thenReturn(const StartHomeState());
    whenListen(
      startHomeBloc,
      Stream<StartHomeState>.fromIterable(const [
        StartHomeState(status: StartHomeStatus.loading),
        StartHomeState(
          status: StartHomeStatus.success,
          createdHomeId: 'home-1',
        ),
      ]),
      initialState: const StartHomeState(),
    );

    final router = GoRouter(
      initialLocation: AppRoutes.start,
      routes: [
        GoRoute(
          path: AppRoutes.start,
          name: AppRouteNames.start,
          builder:
              (_, __) => MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(value: authBloc),
                  BlocProvider<StartHomeBloc>.value(value: startHomeBloc),
                ],
                child: const StartHomeScreen(
                  pendingFitCheckDraftId: 'draft-1',
                ),
              ),
        ),
        GoRoute(
          path: '/fit-check/:draftId/attach',
          name: AppRouteNames.fitCheckAttach,
          builder: (_, state) {
            return Text(
              'attach:${state.pathParameters['draftId']}:${state.uri.queryParameters['homeId']}',
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('attach:draft-1:home-1'), findsOneWidget);
    verify(
      () => authBloc.add(const AuthMembershipRefreshRequested()),
    ).called(1);
  });
}
