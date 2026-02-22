import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/core/forms/form_draft_storage.dart';
import 'package:kinly/features/house_norms/bloc/house_norm_capture_bloc.dart';
import 'package:kinly/generated/l10n.dart';
import '../../../helpers/test_storage.dart';

class _FakeHouseNormsRepository implements HouseNormsRepository {
  _FakeHouseNormsRepository({required this.document, this.shouldThrow = false});

  final HouseNormDocument document;
  final bool shouldThrow;

  @override
  Future<HouseNormDocument?> getForHome({
    required String homeId,
    required String locale,
  }) async {
    return document;
  }

  @override
  Future<HouseNormDocument> generateForHome({
    required String homeId,
    String templateKey = 'house_norms_v1',
    required String locale,
    required Map<String, int> inputs,
    bool force = false,
  }) async {
    if (shouldThrow) {
      throw Exception('generate failed');
    }
    return document;
  }

  @override
  Future<HouseNormDocument> editSectionText({
    required String homeId,
    required String locale,
    required String sectionKey,
    required String text,
    String? changeSummary,
  }) async {
    return document;
  }

  @override
  Future<HouseNormDocument> publishForHome({
    required String homeId,
    required String locale,
  }) async {
    return document;
  }

  @override
  Future<void> recordView({required String homeId}) async {}
}

void main() {
  const homeId = 'home-1';
  const locale = 'en';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = TestStorage();
  });

  setUp(() async {
    await HydratedBloc.storage.clear();
  });

  HouseNormCaptureBloc buildBloc({bool shouldThrow = false}) {
    return HouseNormCaptureBloc(
      repository: _FakeHouseNormsRepository(
        document: _buildHouseNormDocument(),
        shouldThrow: shouldThrow,
      ),
      scenarios: _buildScenarios(),
      homeId: homeId,
      locale: locale,
    );
  }

  test('restores hydrated draft state', () async {
    final key = FormDraftStorage.houseNormsKey(homeId: homeId);
    await HydratedBloc.storage.write(key, {
      'schemaVersion': HouseNormCaptureState.schemaVersionV1,
      'currentStep': 1,
      'responses': {'scenario_one': 2},
      'isDirty': true,
      'lastEditedAt': '2026-01-10T00:00:00.000Z',
    });

    final bloc = buildBloc();
    addTearDown(bloc.close);

    expect(bloc.state.currentIndex, 1);
    expect(bloc.state.responses, {'scenario_one': 2});
    expect(bloc.state.isDirty, isTrue);
  });

  test('submits, clears draft, and transitions to success', () async {
    final key = FormDraftStorage.houseNormsKey(homeId: homeId);
    final bloc = buildBloc();
    addTearDown(bloc.close);

    bloc.add(
      const HouseNormCaptureOptionSelected(
        scenarioId: 'scenario_one',
        optionIndex: 0,
      ),
    );
    bloc.add(
      const HouseNormCaptureOptionSelected(
        scenarioId: 'scenario_two',
        optionIndex: 1,
      ),
    );
    bloc.add(const HouseNormCaptureSubmitted());

    final reflectingState = await bloc.stream.firstWhere(
      (state) => state.status == HouseNormCaptureStatus.reflecting,
    );
    expect(reflectingState.generatedDocument, isNotNull);
    expect(await HydratedBloc.storage.read(key), isNull);

    bloc.add(const HouseNormCaptureReflectionCompleted());
    final success = await bloc.stream.firstWhere(
      (state) => state.status == HouseNormCaptureStatus.success,
    );
    expect(success.reflectionId, 1);
  });

  test('emits failure when generate throws', () async {
    final key = FormDraftStorage.houseNormsKey(homeId: homeId);
    final bloc = buildBloc(shouldThrow: true);
    addTearDown(bloc.close);

    bloc.add(
      const HouseNormCaptureOptionSelected(
        scenarioId: 'scenario_one',
        optionIndex: 0,
      ),
    );
    bloc.add(
      const HouseNormCaptureOptionSelected(
        scenarioId: 'scenario_two',
        optionIndex: 1,
      ),
    );
    bloc.add(const HouseNormCaptureSubmitted());

    final failure = await bloc.stream.firstWhere(
      (state) => state.status == HouseNormCaptureStatus.failure,
    );
    expect(failure.errorMessage, contains('generate failed'));
    expect(await HydratedBloc.storage.read(key), isNotNull);
  });
}

List<HouseNormScenarioDefinition> _buildScenarios() {
  return const [
    HouseNormScenarioDefinition(
      id: 'scenario_one',
      domain: 'context',
      question: _scenarioOneQuestion,
      options: [_scenarioOneOption1, _scenarioOneOption2, _scenarioOneOption3],
    ),
    HouseNormScenarioDefinition(
      id: 'scenario_two',
      domain: 'rhythm',
      question: _scenarioTwoQuestion,
      options: [_scenarioTwoOption1, _scenarioTwoOption2, _scenarioTwoOption3],
    ),
  ];
}

HouseNormDocument _buildHouseNormDocument() {
  return HouseNormDocument(
    homeId: 'home-1',
    templateKey: 'house_norms_v1',
    status: 'out_of_date',
    inputs: const {'scenario_one': 0, 'scenario_two': 1},
    draftContent: const HouseNormContent(
      summary: HouseNormSummary(
        title: 'House norms',
        subtitle: 'Shared defaults',
        framing: 'A shared starting point.',
      ),
      context: 'Context',
      sections: [
        HouseNormSection(
          sectionKey: 'norms_rhythm_quiet',
          title: 'Rhythm',
          text: 'We usually wind down.',
        ),
      ],
    ),
    draftUpdatedAt: DateTime.utc(2026, 1, 1),
    publishedContent: null,
    publishedAt: null,
    publishedVersion: null,
    isPublished: false,
    hasUnpublishedChanges: true,
    lastEditedAt: null,
    lastEditedBy: null,
    homePublicId: null,
    publicUrl: null,
    showPublishButton: true,
    showRepublishButton: false,
    showPublicUrl: false,
    memberViewedAt: null,
    showMemberReviewCard: false,
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
