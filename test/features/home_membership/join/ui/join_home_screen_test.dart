import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/home_membership/join/ui/join_home_screen.dart';
import 'package:kinly/features/home_membership/join/ui/join_home_blocked_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_router.dart';
import 'package:kinly/core/homes/models.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

class _FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthEvent());
    registerFallbackValue(_FakeAuthState());
  });

  late _MockHomeRepository homeRepository;
  late _MockAuthBloc authBloc;

  setUp(() async {
    await sl.reset();
    homeRepository = _MockHomeRepository();
    sl.registerLazySingleton<HomeRepository>(() => homeRepository);
    authBloc = _MockAuthBloc();
    when(
      () => authBloc.stream,
    ).thenAnswer((_) => const Stream<AuthState>.empty());
    when(() => authBloc.state).thenReturn(const AuthState());
  });

  tearDown(() async {
    await sl.reset();
  });

  Widget buildApp(Widget child) {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider<AuthBloc>.value(value: authBloc, child: child),
    );
  }

  testWidgets('submit button enables only after entering a code', (
    tester,
  ) async {
    when(() => homeRepository.join(any())).thenAnswer(
      (_) async =>
          const HomeJoinResult(homeId: 'hid', outcome: JoinOutcome.success),
    );

    await tester.pumpWidget(buildApp(const JoinHomeScreen()));

    var button = tester.widget<KinlyFilledButton>(
      find.byType(KinlyFilledButton),
    );
    expect(button.onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'ABC123');
    await tester.pump();

    button = tester.widget<KinlyFilledButton>(find.byType(KinlyFilledButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('shows friendly error when code invalid', (tester) async {
    when(() => homeRepository.join(any())).thenThrow(
      HomeJoinException(JoinErrorCode.invalidCode, 'Invalid code'),
    );
    when(() => authBloc.state).thenReturn(const AuthState());

    await tester.pumpWidget(buildApp(const JoinHomeScreen()));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'BADCODE');
    await tester.pump();
    await tester.tap(find.byType(KinlyFilledButton));
    await tester.pump(); // submit -> submitting
    await tester.pump(); // failure state processed

    expect(find.text(S.current.join_error_invalid_code), findsOneWidget);
    verify(() => homeRepository.join('BADCODE')).called(1);
  });

  testWidgets('success navigates to today and refreshes membership', (tester) async {
    when(() => homeRepository.join(any())).thenAnswer(
      (_) async =>
          const HomeJoinResult(homeId: 'hid', outcome: JoinOutcome.success),
    );
    when(() => authBloc.state).thenReturn(const AuthState());

    final router = GoRouter(
      initialLocation: AppRoutes.join,
      routes: [
        GoRoute(
          path: AppRoutes.join,
          builder: (context, state) => const JoinHomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.today,
          builder: (context, state) => const Scaffold(body: Text('today')),
        ),
        GoRoute(
          path: AppRoutes.start,
          builder: (context, state) => const Scaffold(body: Text('start')),
        ),
      ],
    );

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: MaterialApp.router(
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
      ),
    );

    await tester.pump();
    await tester.enterText(find.byType(TextField), 'OKCODE');
    await tester.pump();
    await tester.tap(find.byType(KinlyFilledButton));
    await tester.pumpAndSettle();

    expect(find.text('today'), findsOneWidget);
    verify(() => homeRepository.join('OKCODE')).called(1);
    verify(() => authBloc.add(const AuthMembershipRefreshRequested())).called(1);
  });

  testWidgets('blocked joins navigate to blocked screen', (tester) async {
    when(() => homeRepository.join(any())).thenAnswer(
      (_) async =>
          const HomeJoinResult(homeId: 'hid', outcome: JoinOutcome.blocked),
    );
    when(() => authBloc.state).thenReturn(const AuthState());

    final router = GoRouter(
      initialLocation: AppRoutes.join,
      routes: [
        GoRoute(
          path: AppRoutes.join,
          builder: (context, state) => const JoinHomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.joinBlocked,
          builder: (context, state) => const JoinHomeBlockedScreen(),
        ),
        GoRoute(
          path: AppRoutes.start,
          builder: (context, state) => const Scaffold(body: Text('start')),
        ),
      ],
    );

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: MaterialApp.router(
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
      ),
    );

    await tester.pump();
    await tester.enterText(find.byType(TextField), 'CAP123');
    await tester.pump();
    await tester.tap(find.byType(KinlyFilledButton));
    await tester.pumpAndSettle();

    expect(find.text(S.current.join_blocked_title), findsNWidgets(2));
    verify(() => homeRepository.join('CAP123')).called(1);
  });
}
