import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/preferences/bloc/preference_capture_bloc.dart';
import 'package:kinly/features/preferences/domain/preference_scenarios.dart';
import 'package:kinly/features/preferences/ui/preference_onboarding_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockPreferenceReportsRepository extends Mock
    implements PreferenceReportsRepository {}

void main() {
  late _MockPreferenceReportsRepository repository;

  setUp(() {
    repository = _MockPreferenceReportsRepository();
  });

  List<PreferenceScenarioDefinition> buildScenarios() {
    return const [
      PreferenceScenarioDefinition(
        id: 'scenario_one',
        domain: 'test',
        question: _scenarioOneQuestion,
        options: [
          _scenarioOneOption1,
          _scenarioOneOption2,
          _scenarioOneOption3,
        ],
      ),
      PreferenceScenarioDefinition(
        id: 'scenario_two',
        domain: 'test',
        question: _scenarioTwoQuestion,
        options: [
          _scenarioTwoOption1,
          _scenarioTwoOption2,
          _scenarioTwoOption3,
        ],
      ),
    ];
  }

  Widget buildApp(PreferenceCaptureBloc bloc) {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider<PreferenceCaptureBloc>.value(
        value: bloc,
        child: const PreferenceOnboardingScreen(),
      ),
    );
  }

  testWidgets('advances to the next scenario after selecting an option', (
    tester,
  ) async {
    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(buildApp(bloc));
    await tester.pumpAndSettle();

    expect(find.text('Question 1'), findsOneWidget);

    await tester.tap(find.text('Option 2'));
    await tester.pump();

    expect(find.text('Question 2'), findsOneWidget);
  });

  testWidgets('shows submit button only on the last scenario', (tester) async {
    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(buildApp(bloc));
    await tester.pumpAndSettle();

    final s = S.of(tester.element(find.byType(PreferenceOnboardingScreen)));
    expect(find.text(s.preferenceOnboardingSubmit), findsNothing);

    await tester.tap(find.text('Option 1'));
    await tester.pump();
    expect(find.text(s.preferenceOnboardingSubmit), findsNothing);

    await tester.tap(find.text('Option 3'));
    await tester.pump();
    expect(find.text(s.preferenceOnboardingSubmit), findsOneWidget);
  });
}

String _scenarioOneQuestion(S _) => 'Question 1';
String _scenarioOneOption1(S _) => 'Option 1';
String _scenarioOneOption2(S _) => 'Option 2';
String _scenarioOneOption3(S _) => 'Option 3';

String _scenarioTwoQuestion(S _) => 'Question 2';
String _scenarioTwoOption1(S _) => 'Option 1';
String _scenarioTwoOption2(S _) => 'Option 2';
String _scenarioTwoOption3(S _) => 'Option 3';
