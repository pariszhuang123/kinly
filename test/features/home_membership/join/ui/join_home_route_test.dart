import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/app/router/app_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/features/home_membership/join/ui/join_home_blocked_screen.dart';
import 'package:kinly/features/home_membership/join/ui/join_home_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockAuthBloc extends Mock implements AuthBloc {}

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

  testWidgets(
    'deep link /join/:code with blocked outcome navigates to blocked screen',
    (tester) async {
      when(() => homeRepository.join(any())).thenAnswer(
        (_) async =>
            const HomeJoinResult(homeId: 'hid', outcome: JoinOutcome.blocked),
      );

      final router = GoRouter(
        initialLocation: '/join/CAP123',
        routes: [
          GoRoute(
            path: AppRoutes.joinBlocked,
            name: AppRouteNames.joinBlocked,
            builder: (context, state) => const JoinHomeBlockedScreen(),
          ),
          GoRoute(
            path: '/join/:code',
            name: AppRouteNames.joinWithCode,
            builder:
                (context, state) =>
                    JoinHomeScreen(initialCode: state.pathParameters['code']),
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

      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'CAP123');
      await tester.pump();
      final button = tester.widget<KinlyFilledButton>(
        find.byType(KinlyFilledButton),
      );
      expect(button.onPressed, isNotNull);
      await tester.tap(find.byType(KinlyFilledButton));
      await tester.pumpAndSettle();

      verify(() => homeRepository.join('CAP123')).called(1);
      expect(find.byType(JoinHomeBlockedScreen), findsOneWidget);
    },
  );
}
