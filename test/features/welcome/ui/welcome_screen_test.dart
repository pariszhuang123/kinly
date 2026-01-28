import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/welcome/ui/welcome_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kinly/app/router/app_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/links/join_intent_coordinator.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/welcome/ui/welcome_surface_registry.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

class _FakeAuthState extends Fake implements AuthState {}

class _MockJoinIntentCoordinator extends Mock
    implements JoinIntentCoordinator {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthEvent());
    registerFallbackValue(_FakeAuthState());
  });

  late _MockAuthBloc authBloc;
  late StreamController<AuthState> authStateController;
  late _MockJoinIntentCoordinator joinCoordinator;

  setUp(() async {
    await sl.reset();
    WelcomeRegistry.clearForTest();
    joinCoordinator = _MockJoinIntentCoordinator();
    sl.registerLazySingleton<JoinIntentCoordinator>(() => joinCoordinator);

    authBloc = _MockAuthBloc();
    authStateController = StreamController<AuthState>.broadcast();
    when(() => authBloc.stream).thenAnswer((_) => authStateController.stream);
    when(() => authBloc.state).thenReturn(const AuthState());
  });

  tearDown(() async {
    await sl.reset();
    await authStateController.close();
  });

  Widget buildRouterApp(
    GoRouter router, {
    Brightness brightness = Brightness.light,
  }) {
    return BlocProvider<AuthBloc>.value(
      value: authBloc,
      child: MaterialApp.router(
        theme: buildKinlyTheme(brightness),
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
  }

  testWidgets('requires consent before enabling Google sign-in', (
    tester,
  ) async {
    when(() => authBloc.state).thenReturn(const AuthState());
    final router = GoRouter(
      initialLocation: AppRoutes.welcome,
      routes: [
        GoRoute(
          path: AppRoutes.welcome,
          name: AppRouteNames.welcome,
          builder: (_, __) => const WelcomeScreen(),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pump();

    final googleButton = find.text(S.current.login_with_google);
    expect(
      tester
          .widget<Opacity>(
            find.ancestor(of: googleButton, matching: find.byType(Opacity)),
          )
          .opacity,
      lessThan(1.0),
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(
      tester
          .widget<Opacity>(
            find.ancestor(of: googleButton, matching: find.byType(Opacity)),
          )
          .opacity,
      1.0,
    );

    await tester.tap(googleButton);
    verify(() => authBloc.add(const AuthSignInWithGoogleRequested())).called(1);
  });

  testWidgets('uses light Google style in light theme', (tester) async {
    when(() => authBloc.state).thenReturn(const AuthState());
    final router = GoRouter(
      initialLocation: AppRoutes.welcome,
      routes: [
        GoRoute(
          path: AppRoutes.welcome,
          name: AppRouteNames.welcome,
          builder: (_, __) => const WelcomeScreen(),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pump();

    final googleButton = tester.widget<SignInButton>(find.byType(SignInButton));
    expect(googleButton.button, Buttons.google);
  });

  testWidgets('uses light Google style in dark theme', (tester) async {
    when(() => authBloc.state).thenReturn(const AuthState());
    final router = GoRouter(
      initialLocation: AppRoutes.welcome,
      routes: [
        GoRoute(
          path: AppRoutes.welcome,
          name: AppRouteNames.welcome,
          builder: (_, __) => const WelcomeScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      buildRouterApp(router, brightness: Brightness.dark),
    );
    await tester.pump();

    final googleButton = tester.widget<SignInButton>(find.byType(SignInButton));
    expect(googleButton.button, Buttons.google);
  });

  testWidgets('navigates to start when authenticated without membership', (
    tester,
  ) async {
    when(() => authBloc.state).thenReturn(const AuthState());
    whenListen(
      authBloc,
      Stream<AuthState>.fromIterable(const [
        AuthState(
          status: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.none,
          userId: 'user-1',
        ),
      ]),
      initialState: const AuthState(),
    );

    final router = GoRouter(
      initialLocation: AppRoutes.welcome,
      routes: [
        GoRoute(
          path: AppRoutes.welcome,
          name: AppRouteNames.welcome,
          builder: (_, __) => const WelcomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.start,
          name: AppRouteNames.start,
          builder: (_, __) => const Scaffold(body: Text('start-screen')),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pumpAndSettle();

    expect(find.text('start-screen'), findsOneWidget);
  });

  testWidgets('navigates to today when authenticated with membership', (
    tester,
  ) async {
    when(() => authBloc.state).thenReturn(const AuthState());
    whenListen(
      authBloc,
      Stream<AuthState>.fromIterable(const [
        AuthState(
          status: AuthStatus.authenticated,
          membershipStatus: AuthMembershipStatus.active,
          userId: 'user-2',
        ),
      ]),
      initialState: const AuthState(),
    );

    final router = GoRouter(
      initialLocation: AppRoutes.welcome,
      routes: [
        GoRoute(
          path: AppRoutes.welcome,
          name: AppRouteNames.welcome,
          builder: (_, __) => const WelcomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.today,
          name: AppRouteNames.today,
          builder: (_, __) => const Scaffold(body: Text('today-screen')),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pumpAndSettle();

    expect(find.text('today-screen'), findsOneWidget);
  });

  testWidgets('disables Google sign-in while loading', (tester) async {
    when(() => authBloc.state).thenReturn(const AuthState(isLoading: true));
    final router = GoRouter(
      initialLocation: AppRoutes.welcome,
      routes: [
        GoRoute(
          path: AppRoutes.welcome,
          name: AppRouteNames.welcome,
          builder: (_, __) => const WelcomeScreen(),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pump();

    // Consent checked, but busy => button should stay disabled.
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    final googleButton = find.text(S.current.login_with_google);
    final opacityWidget = tester.widget<Opacity>(
      find.ancestor(of: googleButton, matching: find.byType(Opacity)),
    );
    expect(opacityWidget.opacity, lessThan(1.0));

    await tester.tap(googleButton, warnIfMissed: false);
    verifyNever(() => authBloc.add(const AuthSignInWithGoogleRequested()));
  });
}
