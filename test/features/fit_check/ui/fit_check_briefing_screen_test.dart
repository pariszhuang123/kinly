import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_briefing_cubit.dart';
import 'package:kinly/features/fit_check/ui/fit_check_briefing_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockFitCheckBriefingCubit extends MockCubit<FitCheckBriefingState>
    implements FitCheckBriefingCubit {}

void main() {
  late _MockFitCheckBriefingCubit cubit;

  setUpAll(() {
    registerFallbackValue(FitCheckBriefingState.loading());
  });

  setUp(() {
    cubit = _MockFitCheckBriefingCubit();
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
      home: BlocProvider<FitCheckBriefingCubit>.value(
        value: cubit,
        child: const FitCheckBriefingScreen(),
      ),
    );
  }

  testWidgets('renders focus text and prioritizes primary watchouts', (
    tester,
  ) async {
    final briefing = FitCheckOwnerBriefing.fromJson({
      'submission_id': 'submission-1',
      'draft_id': 'draft-1',
      'candidate': {
        'display_name': 'Alex',
        'submitted_at': '2026-03-21T09:00:00Z',
        'answers': {
          'fit_cleanliness': 2,
        },
      },
      'briefing': {
        'focus_text': 'Start with the top watchouts first.',
        'watchouts': [
          {
            'scenario_id': 'fit_cleanliness',
            'distance': 2,
            'direction': 'candidate_higher',
            'watchout_text': 'Primary watchout',
            'question_texts': ['What does clean enough look like?'],
            'is_primary_focus': true,
          },
          {
            'scenario_id': 'fit_conflict',
            'distance': 1,
            'direction': 'candidate_higher',
            'watchout_text': 'Secondary watchout',
            'question_texts': ['How do you raise issues?'],
            'is_primary_focus': false,
          },
        ],
        'limitation_text': 'Use this to guide the conversation.',
      },
    });

    when(
      () => cubit.state,
    ).thenReturn(FitCheckBriefingState.ready(briefing));
    whenListen(
      cubit,
      Stream<FitCheckBriefingState>.value(FitCheckBriefingState.ready(briefing)),
      initialState: FitCheckBriefingState.ready(briefing),
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Where to start'), findsOneWidget);
    expect(find.text('Start with the top watchouts first.'), findsOneWidget);
    expect(find.text('Top watchouts'), findsOneWidget);
    expect(find.text('Other watchouts'), findsOneWidget);
    expect(find.text('Primary watchout'), findsOneWidget);
    expect(find.text('Secondary watchout'), findsOneWidget);

    final primaryTop = tester.getTopLeft(find.text('Primary watchout')).dy;
    final secondaryTop = tester.getTopLeft(find.text('Secondary watchout')).dy;
    expect(primaryTop, lessThan(secondaryTop));
  });
}
