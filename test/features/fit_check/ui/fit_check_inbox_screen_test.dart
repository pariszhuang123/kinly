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
import 'package:kinly/features/fit_check/bloc/fit_check_inbox_cubit.dart';
import 'package:kinly/features/fit_check/ui/fit_check_inbox_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/kinly_theme.dart';

class _MockFitCheckInboxCubit extends MockCubit<FitCheckInboxState>
    implements FitCheckInboxCubit {}

void main() {
  late _MockFitCheckInboxCubit cubit;

  setUpAll(() {
    registerFallbackValue(FitCheckInboxState.loading());
  });

  setUp(() {
    cubit = _MockFitCheckInboxCubit();
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

  testWidgets('renders duplicate candidate names as separate cards', (
    tester,
  ) async {
    final review = FitCheckOwnerReview.fromJson({
      'draft_id': 'draft-1',
      'home_id': 'home-1',
      'owner_summary': {
        'labels': ['Quiet nights'],
      },
      'submissions': [
        {
          'submission_id': 'submission-newer',
          'display_name': 'Alex',
          'review_label': 'Alex · Mar 21',
          'submitted_at': '2026-03-21T09:00:00Z',
          'preview': {
            'summary_label': 'A few things to discuss',
          },
        },
        {
          'submission_id': 'submission-older',
          'display_name': 'Alex',
          'review_label': 'Alex · Mar 10',
          'submitted_at': '2026-03-10T09:00:00Z',
          'preview': {
            'summary_label': 'Older response',
          },
        },
      ],
    });

    when(() => cubit.state).thenReturn(FitCheckInboxState.ready(review));
    whenListen(
      cubit,
      Stream<FitCheckInboxState>.value(FitCheckInboxState.ready(review)),
      initialState: FitCheckInboxState.ready(review),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => BlocProvider<FitCheckInboxCubit>.value(
                value: cubit,
                child: const FitCheckInboxScreen(),
              ),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pumpAndSettle();

    expect(find.text('Alex'), findsNWidgets(2));
    expect(find.text('Alex · Mar 21'), findsOneWidget);
    expect(find.text('Alex · Mar 10'), findsOneWidget);
  });

  testWidgets('opens briefing with the tapped submission id', (tester) async {
    final review = FitCheckOwnerReview.fromJson({
      'draft_id': 'draft-1',
      'home_id': 'home-1',
      'owner_summary': {
        'labels': ['Quiet nights'],
      },
      'submissions': [
        {
          'submission_id': 'submission-exact',
          'display_name': 'Alex',
          'review_label': 'Alex · Mar 21',
          'submitted_at': '2026-03-21T09:00:00Z',
          'preview': {
            'summary_label': 'A few things to discuss',
          },
        },
      ],
    });

    when(() => cubit.state).thenReturn(FitCheckInboxState.ready(review));
    whenListen(
      cubit,
      Stream<FitCheckInboxState>.value(FitCheckInboxState.ready(review)),
      initialState: FitCheckInboxState.ready(review),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => BlocProvider<FitCheckInboxCubit>.value(
                value: cubit,
                child: const FitCheckInboxScreen(),
              ),
        ),
        GoRoute(
          path: AppRoutePaths.fitCheckBriefing,
          name: AppRouteNames.fitCheckBriefing,
          builder: (_, state) {
            return Text(
              'briefing:${state.pathParameters['draftId']}:${state.pathParameters['submissionId']}',
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open briefing'));
    await tester.pumpAndSettle();

    expect(find.text('briefing:draft-1:submission-exact'), findsOneWidget);
  });

  testWidgets('empty state still shows house norms CTA when home is attached', (
    tester,
  ) async {
    final review = FitCheckOwnerReview.fromJson({
      'draft_id': 'draft-1',
      'home_id': 'home-1',
      'owner_summary': {
        'labels': ['Quiet nights'],
      },
      'submissions': [],
    });

    when(() => cubit.state).thenReturn(FitCheckInboxState.ready(review));
    when(
      () => cubit.getPrefillPayload(),
    ).thenAnswer(
      (_) async => FitCheckPrefillPayload.fromJson({
        'draft_id': 'draft-1',
        'onboarding_seed': {
          'house_norms': {
            'initial_responses': {
              'norms_shared_spaces': 0,
            },
          },
          'preferences': {
            'initial_responses': {},
          },
        },
      }),
    );
    whenListen(
      cubit,
      Stream<FitCheckInboxState>.value(FitCheckInboxState.ready(review)),
      initialState: FitCheckInboxState.ready(review),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => BlocProvider<FitCheckInboxCubit>.value(
                value: cubit,
                child: const FitCheckInboxScreen(),
              ),
        ),
        GoRoute(
          path: AppRoutePaths.houseNormsOnboarding,
          name: AppRouteNames.houseNormsOnboarding,
          builder: (_, __) => const Text('house-norms-onboarding'),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pumpAndSettle();

    expect(find.text('Use for house norms'), findsOneWidget);

    await tester.tap(find.text('Use for house norms'));
    await tester.pumpAndSettle();

    expect(find.text('house-norms-onboarding'), findsOneWidget);
    verify(() => cubit.getPrefillPayload()).called(1);
  });

  testWidgets('renders current share before historical shares', (tester) async {
    final review = FitCheckOwnerReview.fromJson({
      'draft_id': 'draft-1',
      'home_id': 'home-1',
      'owner_summary': {
        'labels': ['Quiet nights'],
      },
      'share_groups': [
        {
          'share_generation_id': 'older',
          'share_token_status': 'revoked',
          'created_at': '2026-03-10T09:00:00Z',
          'submissions': [
            {
              'submission_id': 'submission-older',
              'display_name': 'Jordan',
              'review_label': 'Jordan · Mar 10',
              'submitted_at': '2026-03-10T10:00:00Z',
              'preview': {
                'summary_label': 'Older response',
              },
            },
          ],
        },
        {
          'share_generation_id': 'current',
          'share_token_status': 'active',
          'created_at': '2026-03-21T09:00:00Z',
          'submissions': [
            {
              'submission_id': 'submission-current',
              'display_name': 'Alex',
              'review_label': 'Alex · Mar 21',
              'submitted_at': '2026-03-21T10:00:00Z',
              'preview': {
                'summary_label': 'Current response',
              },
            },
          ],
        },
      ],
    });

    when(() => cubit.state).thenReturn(FitCheckInboxState.ready(review));
    whenListen(
      cubit,
      Stream<FitCheckInboxState>.value(FitCheckInboxState.ready(review)),
      initialState: FitCheckInboxState.ready(review),
    );
    when(() => cubit.rotateShareToken()).thenAnswer(
      (_) async => FitCheckShareTokenActionResult.fromJson({
        'draft_id': 'draft-1',
        'share_token_status': 'active',
      }),
    );
    when(() => cubit.revokeShareToken()).thenAnswer(
      (_) async => FitCheckShareTokenActionResult.fromJson({
        'draft_id': 'draft-1',
        'share_token_status': 'revoked',
      }),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => BlocProvider<FitCheckInboxCubit>.value(
                value: cubit,
                child: const FitCheckInboxScreen(),
              ),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterApp(router));
    await tester.pumpAndSettle();

    expect(find.text('Current share'), findsOneWidget);
    expect(find.textContaining('Previous share'), findsOneWidget);
    final currentTop = tester.getTopLeft(find.text('Current share')).dy;
    final previousTop =
        tester.getTopLeft(find.textContaining('Previous share')).dy;
    expect(currentTop, lessThan(previousTop));

    await tester.tap(find.text('Rotate link'));
    await tester.pumpAndSettle();
    verify(() => cubit.rotateShareToken()).called(1);

    await tester.tap(find.text('Stop responses'));
    await tester.pumpAndSettle();
    verify(() => cubit.revokeShareToken()).called(1);
  });
}
