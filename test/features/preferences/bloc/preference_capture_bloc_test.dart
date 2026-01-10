import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/forms/form_draft_storage.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/features/preferences/bloc/preference_capture_bloc.dart';
import 'package:kinly/features/preferences/domain/preference_scenarios.dart';
import 'package:kinly/generated/l10n.dart';
import '../../../helpers/test_storage.dart';

class _MockPreferenceReportsRepository extends Mock
    implements PreferenceReportsRepository {}

class _LogEntry {
  const _LogEntry({required this.level, required this.message, this.tag});

  final LogLevel level;
  final String message;
  final String? tag;
}

class _TestLogger extends Logger {
  final entries = <_LogEntry>[];

  @override
  void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    entries.add(_LogEntry(level: level, message: message, tag: tag));
  }
}

void main() {
  late _MockPreferenceReportsRepository repository;
  late _TestLogger logger;
  const homeId = 'home-test';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = TestStorage();
  });

  setUp(() async {
    repository = _MockPreferenceReportsRepository();
    logger = _TestLogger();
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

  test('restores hydrated draft and logs restore', () async {
    const userId = 'user-restore';
    final key = FormDraftStorage.personalPreferencesKey(userId: userId);
    await HydratedBloc.storage.write(key, {
      'schemaVersion': PreferenceCaptureState.schemaVersionV1,
      'currentStep': 1,
      'responses': {'scenario_one': 2},
      'isDirty': true,
      'lastEditedAt': '2026-01-10T00:00:00.000Z',
    });

    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
      userId: userId,
      homeId: homeId,
      logger: logger,
    );
    addTearDown(bloc.close);

    expect(bloc.state.currentIndex, 1);
    expect(bloc.state.responses, {'scenario_one': 2});
    expect(bloc.state.isDirty, isTrue);
    expect(
      logger.entries.any(
        (entry) => entry.message.contains('form_draft_restored'),
      ),
      isTrue,
    );
  });

  test('resets on schema mismatch and logs reset', () async {
    const userId = 'user-schema-mismatch';
    final key = FormDraftStorage.personalPreferencesKey(userId: userId);
    await HydratedBloc.storage.write(key, {
      'schemaVersion': 999,
      'currentStep': 1,
      'responses': {'scenario_one': 2},
      'isDirty': true,
      'lastEditedAt': '2026-01-10T00:00:00.000Z',
    });

    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
      userId: userId,
      homeId: homeId,
      logger: logger,
    );
    addTearDown(bloc.close);

    expect(bloc.state.currentIndex, 0);
    expect(bloc.state.responses, isEmpty);
    expect(bloc.state.isDirty, isFalse);
    expect(
      logger.entries.any(
        (entry) => entry.message.contains('form_draft_schema_reset'),
      ),
      isTrue,
    );
  });

  test('clears draft on successful submit and resets state', () async {
    const userId = 'user-submit';
    final key = FormDraftStorage.personalPreferencesKey(userId: userId);

    when(() => repository.submitResponses(any())).thenAnswer((_) async {});
    when(
      () => repository.getTemplateResolution(
        templateKey: any(named: 'templateKey'),
      ),
    ).thenAnswer(
      (_) async => const PreferenceTemplateResolution(
        templateKey: 'personal_preferences_v1',
        requestedLocale: 'en',
        resolvedLocale: 'en',
      ),
    );
    when(
      () => repository.generateReport(
        templateKey: any(named: 'templateKey'),
        locale: any(named: 'locale'),
        force: any(named: 'force'),
      ),
    ).thenAnswer(
      (_) async => const PreferenceReportGenerationResult(
        status: 'ok',
        unresolvedPreferenceIds: [],
      ),
    );
    when(
      () => repository.getReportForHome(
        homeId: any(named: 'homeId'),
        subjectUserId: any(named: 'subjectUserId'),
        templateKey: any(named: 'templateKey'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer((_) async => _buildReport(userId));

    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
      userId: userId,
      homeId: homeId,
      logger: logger,
    );
    addTearDown(bloc.close);

    bloc.add(
      const PreferenceCaptureOptionSelected(
        preferenceId: 'scenario_one',
        optionIndex: 1,
      ),
    );
    bloc.add(
      const PreferenceCaptureOptionSelected(
        preferenceId: 'scenario_two',
        optionIndex: 0,
      ),
    );
    bloc.add(const PreferenceCaptureSubmitted());

    final reflectingState = await bloc.stream.firstWhere(
      (state) => state.status == PreferenceCaptureStatus.reflecting,
    );

    expect(reflectingState.currentIndex, 0);
    expect(reflectingState.responses, isEmpty);
    expect(reflectingState.isDirty, isFalse);
    expect(reflectingState.generatedReport, isNotNull);
    bloc.add(const PreferenceCaptureReflectionCompleted());

    final successState = await bloc.stream.firstWhere(
      (state) => state.status == PreferenceCaptureStatus.success,
    );

    expect(successState.reflectionId, 1);
    expect(await HydratedBloc.storage.read(key), isNull);
    expect(
      logger.entries.any(
        (entry) => entry.message.contains('form_draft_cleared_on_submit'),
      ),
      isTrue,
    );
  });

  test('routes missing report to failure state with reset draft', () async {
    const userId = 'user-missing-report';
    final key = FormDraftStorage.personalPreferencesKey(userId: userId);

    when(() => repository.submitResponses(any())).thenAnswer((_) async {});
    when(
      () => repository.getTemplateResolution(
        templateKey: any(named: 'templateKey'),
      ),
    ).thenAnswer(
      (_) async => const PreferenceTemplateResolution(
        templateKey: 'personal_preferences_v1',
        requestedLocale: 'en',
        resolvedLocale: 'en',
      ),
    );
    when(
      () => repository.generateReport(
        templateKey: any(named: 'templateKey'),
        locale: any(named: 'locale'),
        force: any(named: 'force'),
      ),
    ).thenAnswer(
      (_) async => const PreferenceReportGenerationResult(
        status: 'ok',
        unresolvedPreferenceIds: [],
      ),
    );
    when(
      () => repository.getReportForHome(
        homeId: any(named: 'homeId'),
        subjectUserId: any(named: 'subjectUserId'),
        templateKey: any(named: 'templateKey'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer((_) async => null);

    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
      userId: userId,
      homeId: homeId,
      logger: logger,
    );
    addTearDown(bloc.close);

    bloc.add(
      const PreferenceCaptureOptionSelected(
        preferenceId: 'scenario_one',
        optionIndex: 1,
      ),
    );
    bloc.add(
      const PreferenceCaptureOptionSelected(
        preferenceId: 'scenario_two',
        optionIndex: 0,
      ),
    );
    bloc.add(const PreferenceCaptureSubmitted());

    final failureState = await bloc.stream.firstWhere(
      (state) => state.status == PreferenceCaptureStatus.failure,
    );

    expect(failureState.errorMessage, PreferenceCaptureBloc.missingReportErrorCode);
    expect(failureState.isDirty, isFalse);
    expect(await HydratedBloc.storage.read(key), isNull);
  });

  test('propagates non-missing failures and keeps error message', () async {
    const userId = 'user-failure';
    final key = FormDraftStorage.personalPreferencesKey(userId: userId);

    when(() => repository.submitResponses(any())).thenThrow(Exception('boom'));

    final bloc = PreferenceCaptureBloc(
      repository: repository,
      scenarios: buildScenarios(),
      userId: userId,
      homeId: homeId,
      logger: logger,
    );
    addTearDown(bloc.close);

    bloc.add(
      const PreferenceCaptureOptionSelected(
        preferenceId: 'scenario_one',
        optionIndex: 1,
      ),
    );
    bloc.add(
      const PreferenceCaptureOptionSelected(
        preferenceId: 'scenario_two',
        optionIndex: 0,
      ),
    );
    bloc.add(const PreferenceCaptureSubmitted());

    final failureState = await bloc.stream.firstWhere(
      (state) => state.status == PreferenceCaptureStatus.failure,
    );

    expect(failureState.errorMessage, contains('boom'));
    expect(await HydratedBloc.storage.read(key), isNotNull);
  });
}

PreferenceReport _buildReport(String subjectUserId) {
  return PreferenceReport(
    id: 'report-id',
    subjectUserId: subjectUserId,
    templateKey: 'personal_preferences_v1',
    locale: 'en',
    publishedAt: DateTime.utc(2026, 1, 10),
    content: const PreferenceReportContent(
      summary: PreferenceReportSummary(
        title: 'Title',
        subtitle: 'Subtitle',
      ),
      sections: [
        PreferenceReportSection(
          sectionKey: 'section',
          title: 'Section title',
          text: 'Section body',
        ),
      ],
    ),
    lastEditedAt: null,
    lastEditedBy: subjectUserId,
  );
}

String _scenarioOneQuestion(S _) => 'Question 1';
String _scenarioOneOption1(S _) => 'Option 1';
String _scenarioOneOption2(S _) => 'Option 2';
String _scenarioOneOption3(S _) => 'Option 3';

String _scenarioTwoQuestion(S _) => 'Question 2';
String _scenarioTwoOption1(S _) => 'Option 1';
String _scenarioTwoOption2(S _) => 'Option 2';
String _scenarioTwoOption3(S _) => 'Option 3';
