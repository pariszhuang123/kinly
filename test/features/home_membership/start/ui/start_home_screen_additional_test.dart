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

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockStartHomeBloc extends MockBloc<StartHomeEvent, StartHomeState>
    implements StartHomeBloc {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

class _FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthEvent());
    registerFallbackValue(_FakeAuthState());
  });

  late _MockAuthBloc authBloc;
  late _MockStartHomeBloc startHomeBloc;

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

  setUp(() {
    authBloc = _MockAuthBloc();
    startHomeBloc = _MockStartHomeBloc();
    when(
      () => authBloc.stream,
    ).thenAnswer((_) => const Stream<AuthState>.empty());
    when(
      () => authBloc.state,
    ).thenReturn(const AuthState(membershipStatus: AuthMembershipStatus.none));
  });

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
}
