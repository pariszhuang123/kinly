import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/core/auth/bloc/auth_bloc.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_attach_cubit.dart';
import 'package:kinly/features/fit_check/ui/fit_check_attach_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockFitCheckAttachCubit extends MockCubit<FitCheckAttachState>
    implements FitCheckAttachCubit {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late _MockFitCheckAttachCubit cubit;
  late _MockAuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(FitCheckAttachState.ready());
  });

  setUp(() {
    cubit = _MockFitCheckAttachCubit();
    authBloc = _MockAuthBloc();
  });

  Widget buildRouterApp(GoRouter router) {
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

  testWidgets('attaches using the provided home id', (tester) async {
    const authState = AuthState(
      status: AuthStatus.authenticated,
      membershipStatus: AuthMembershipStatus.none,
    );
    when(() => authBloc.state).thenReturn(authState);
    whenListen(
      authBloc,
      Stream<AuthState>.value(authState),
      initialState: authState,
    );
    when(() => cubit.state).thenReturn(FitCheckAttachState.ready());
    whenListen(
      cubit,
      Stream<FitCheckAttachState>.value(FitCheckAttachState.ready()),
      initialState: FitCheckAttachState.ready(),
    );
    when(() => cubit.attach(homeId: 'home-1')).thenAnswer((_) async {});

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => MultiBlocProvider(
                providers: [
                  BlocProvider<FitCheckAttachCubit>.value(value: cubit),
                  BlocProvider<AuthBloc>.value(value: authBloc),
                ],
                child: const FitCheckAttachScreen(
                  draftId: 'draft-1',
                  homeId: 'home-1',
                ),
              ),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Attach to home'));
    await tester.pumpAndSettle();

    verify(() => cubit.attach(homeId: 'home-1')).called(1);
  });

  testWidgets('routes to start when no home is available', (tester) async {
    const authState = AuthState(
      status: AuthStatus.authenticated,
      membershipStatus: AuthMembershipStatus.none,
    );
    when(() => authBloc.state).thenReturn(authState);
    whenListen(
      authBloc,
      Stream<AuthState>.value(authState),
      initialState: authState,
    );
    when(() => cubit.state).thenReturn(FitCheckAttachState.ready());
    whenListen(
      cubit,
      Stream<FitCheckAttachState>.value(FitCheckAttachState.ready()),
      initialState: FitCheckAttachState.ready(),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => MultiBlocProvider(
                providers: [
                  BlocProvider<FitCheckAttachCubit>.value(value: cubit),
                  BlocProvider<AuthBloc>.value(value: authBloc),
                ],
                child: const FitCheckAttachScreen(draftId: 'draft-1'),
              ),
        ),
        GoRoute(
          path: AppRoutePaths.start,
          name: AppRouteNames.start,
          builder: (_, state) => Text(
            'start:${state.uri.queryParameters['fitCheckDraftId']}',
          ),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create home first'));
    await tester.pumpAndSettle();

    expect(find.text('start:draft-1'), findsOneWidget);
  });
}
