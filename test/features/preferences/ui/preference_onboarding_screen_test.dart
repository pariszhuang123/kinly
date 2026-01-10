import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/preferences/bloc/preference_capture_bloc.dart';
import 'package:kinly/features/preferences/domain/preference_scenarios.dart';
import 'package:kinly/features/preferences/ui/preference_onboarding_screen.dart';
import 'package:kinly/generated/l10n.dart';
import '../../../helpers/test_storage.dart';

class _FakePreferenceReportsRepository implements PreferenceReportsRepository {
  _FakePreferenceReportsRepository({
    this.shouldReturnNullReport = false,
    this.shouldThrow = false,
  }) : report = const PreferenceReport(
         id: 'id',
         subjectUserId: 'user-1',
         templateKey: 'personal_preferences_v1',
         locale: 'en',
         publishedAt: null,
         content: PreferenceReportContent(
           summary: PreferenceReportSummary(title: 'title', subtitle: 'sub'),
           sections: [
             PreferenceReportSection(
               sectionKey: 'section',
               title: 'Section',
               text: 'Body',
             ),
           ],
         ),
         lastEditedAt: null,
         lastEditedBy: 'user-1',
       );

  final PreferenceReport report;
  final bool shouldReturnNullReport;
  final bool shouldThrow;

  @override
  Future<void> editSectionText({
    String templateKey = 'personal_preferences_v1',
    required String locale,
    required String sectionKey,
    required String text,
    String? changeSummary,
  }) async {}

  @override
  Future<PreferenceReportGenerationResult> generateReport({
    String templateKey = 'personal_preferences_v1',
    required String locale,
    bool force = false,
  }) async {
    if (shouldThrow) throw Exception('boom');
    return const PreferenceReportGenerationResult(
      status: 'ok',
      unresolvedPreferenceIds: [],
    );
  }

  @override
  Future<PreferenceReport?> getReportForHome({
    required String homeId,
    required String subjectUserId,
    String templateKey = 'personal_preferences_v1',
    required String locale,
  }) async {
    if (shouldThrow) throw Exception('boom');
    return shouldReturnNullReport ? null : report;
  }

  @override
  Future<List<PreferenceReportListItem>> listReportsForHome({
    required String homeId,
    String templateKey = 'personal_preferences_v1',
    required String locale,
  }) async {
    return const [];
  }

  @override
  Future<PreferenceTemplateResolution> getTemplateResolution({
    String templateKey = 'personal_preferences_v1',
  }) async {
    return const PreferenceTemplateResolution(
      templateKey: 'personal_preferences_v1',
      requestedLocale: 'en',
      resolvedLocale: 'en',
    );
  }

  @override
  Future<void> submitResponses(Map<String, int> responsesById) async {
    if (shouldThrow) throw Exception('boom');
  }

  @override
  Future<void> acknowledgeReport({required String reportId}) async {}
}

void main() {
  late _FakePreferenceReportsRepository repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = TestStorage();
  });

  setUp(() async {
    repository = _FakePreferenceReportsRepository();
    await HydratedBloc.storage.clear();
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
      home: BlocProvider.value(
        value: bloc,
        child: const PreferenceOnboardingScreen(),
      ),
    );
  }

  Widget buildRouterApp(PreferenceCaptureBloc bloc) {
    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          name: AppRouteNames.preferenceOnboarding,
          builder:
              (_, __) => BlocProvider.value(
                value: bloc,
                child: const PreferenceOnboardingScreen(),
              ),
        ),
        GoRoute(
          path: '/report',
          name: AppRouteNames.preferenceReport,
          builder: (_, __) => const Scaffold(body: Text('Report Screen')),
        ),
        GoRoute(
          path: '/today',
          name: AppRouteNames.today,
          builder: (_, __) => const Scaffold(body: Text('Today Screen')),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  testWidgets('advances to the next scenario after selecting an option', (
    tester,
  ) async {
    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
      userId: 'user-1',
      homeId: 'home-1',
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(buildApp(bloc));
    await tester.pump();

    expect(find.text('Question 1'), findsOneWidget);

    await tester.tap(find.text('Option 2'));
    await tester.pump();

    expect(find.text('Question 2'), findsOneWidget);
  });

  testWidgets('shows submit button only on the last scenario', (tester) async {
    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
      userId: 'user-1',
      homeId: 'home-1',
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(buildApp(bloc));
    await tester.pump();

    final s = S.of(tester.element(find.byType(PreferenceOnboardingScreen)));
    expect(find.text(s.preferenceOnboardingSubmit), findsNothing);

    await tester.tap(find.text('Option 1'));
    await tester.pump();
    expect(find.text(s.preferenceOnboardingSubmit), findsNothing);

    await tester.tap(find.text('Option 3'));
    await tester.pump();
    expect(find.text(s.preferenceOnboardingSubmit), findsOneWidget);
  });

  testWidgets('navigates to report after reflection completes', (tester) async {
    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
      userId: 'user-1',
      homeId: 'home-1',
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(buildRouterApp(bloc));
    await tester.pump();

    await tester.tap(find.text('Option 1'));
    await tester.pump();
    await tester.tap(find.text('Option 1'));
    await tester.pump();
    await tester.tap(find.text(S.current.preferenceOnboardingSubmit));

    // allow submission + reflection overlay (~1200ms)
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text('Report Screen'), findsOneWidget);
  });

  testWidgets('navigates to today and shows snackbar on missing report', (
    tester,
  ) async {
    repository = _FakePreferenceReportsRepository(shouldReturnNullReport: true);
    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
      userId: 'user-1',
      homeId: 'home-1',
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(buildRouterApp(bloc));
    await tester.pump();

    await tester.tap(find.text('Option 1'));
    await tester.pump();
    await tester.tap(find.text('Option 1'));
    await tester.pump();
    await tester.tap(find.text(S.current.preferenceOnboardingSubmit));

    await tester.pumpAndSettle();

    expect(find.text('Today Screen'), findsOneWidget);
    expect(
      find.text(S.current.preferenceReportGenerationMissing),
      findsOneWidget,
    );
  });

  testWidgets('navigates to today on generic failure', (tester) async {
    repository = _FakePreferenceReportsRepository(shouldThrow: true);
    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
      userId: 'user-1',
      homeId: 'home-1',
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(buildRouterApp(bloc));
    await tester.pump();

    await tester.tap(find.text('Option 1'));
    await tester.pump();
    await tester.tap(find.text('Option 1'));
    await tester.pump();
    await tester.tap(find.text(S.current.preferenceOnboardingSubmit));

    await tester.pumpAndSettle();

    expect(find.text('Today Screen'), findsOneWidget);
    expect(
      find.text(S.current.preferenceReportGenerationFailed),
      findsOneWidget,
    );
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
