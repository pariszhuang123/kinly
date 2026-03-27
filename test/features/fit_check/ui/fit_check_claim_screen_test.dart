import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/core/auth/bloc/auth_bloc.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_claim_cubit.dart';
import 'package:kinly/features/fit_check/ui/fit_check_claim_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockFitCheckClaimCubit extends MockCubit<FitCheckClaimState>
    implements FitCheckClaimCubit {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late _MockFitCheckClaimCubit cubit;
  late _MockAuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(FitCheckClaimState.loading());
  });

  setUp(() {
    cubit = _MockFitCheckClaimCubit();
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

  testWidgets('routes to attach when claim succeeds with an active home', (
    tester,
  ) async {
    final result = FitCheckClaimResult.fromJson({
      'draft_id': 'draft-1',
      'owner_user_id': 'user-1',
      'home_attachment_required': true,
      'owner_home_count': 1,
      'seed_house_norms_prefill_available': true,
      'submission_count': 0,
    });
    final authState = AuthState(
      status: AuthStatus.authenticated,
      membershipStatus: AuthMembershipStatus.active,
      membership: CurrentMembership(
        userId: 'user-1',
        homeId: 'home-1',
        role: 'owner',
        validFrom: DateTime(2026, 3, 28),
      ),
    );
    when(() => authBloc.state).thenReturn(authState);
    whenListen(
      authBloc,
      Stream<AuthState>.value(authState),
      initialState: authState,
    );
    when(() => cubit.state).thenReturn(FitCheckClaimState.ready(result));
    whenListen(
      cubit,
      Stream<FitCheckClaimState>.value(FitCheckClaimState.ready(result)),
      initialState: FitCheckClaimState.ready(result),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => MultiBlocProvider(
                providers: [
                  BlocProvider<FitCheckClaimCubit>.value(value: cubit),
                  BlocProvider<AuthBloc>.value(value: authBloc),
                ],
                child: const FitCheckClaimScreen(),
              ),
        ),
        GoRoute(
          path: AppRoutePaths.fitCheckAttach,
          name: AppRouteNames.fitCheckAttach,
          builder: (_, state) => Text(
            'attach:${state.pathParameters['draftId']}:${state.uri.queryParameters['homeId']}',
          ),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pumpAndSettle();

    expect(find.text('attach:draft-1:home-1'), findsOneWidget);
  });

  testWidgets('routes to start when claim succeeds without an active home', (
    tester,
  ) async {
    final result = FitCheckClaimResult.fromJson({
      'draft_id': 'draft-2',
      'owner_user_id': 'user-1',
      'home_attachment_required': true,
      'owner_home_count': 0,
      'seed_house_norms_prefill_available': true,
      'submission_count': 0,
    });
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
    when(() => cubit.state).thenReturn(FitCheckClaimState.ready(result));
    whenListen(
      cubit,
      Stream<FitCheckClaimState>.value(FitCheckClaimState.ready(result)),
      initialState: FitCheckClaimState.ready(result),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => MultiBlocProvider(
                providers: [
                  BlocProvider<FitCheckClaimCubit>.value(value: cubit),
                  BlocProvider<AuthBloc>.value(value: authBloc),
                ],
                child: const FitCheckClaimScreen(),
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

    expect(find.text('start:draft-2'), findsOneWidget);
  });
}
