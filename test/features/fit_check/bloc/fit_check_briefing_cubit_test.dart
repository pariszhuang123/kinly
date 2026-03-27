import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_briefing_cubit.dart';

class _MockFitCheckRepository extends Mock implements FitCheckRepository {}

void main() {
  late _MockFitCheckRepository repository;

  const submissionId = 'submission-1';
  const locale = 'en';

  final briefing = FitCheckOwnerBriefing.fromJson({
    'submission_id': submissionId,
    'draft_id': 'draft-1',
    'candidate': {
      'display_name': 'Alex',
      'submitted_at': '2026-03-21T09:00:00Z',
      'answers': {
        'fit_cleanliness': 2,
      },
    },
    'briefing': {
      'context_text': 'Most issues repeat daily.',
      'alignment_preview_text': 'Mostly aligned on rhythms.',
      'alignments': [
        {'scenario_id': 'fit_rhythm'},
      ],
      'watchouts': [
        {
          'scenario_id': 'fit_cleanliness',
          'distance': 2,
          'direction': 'candidate_higher',
          'watchout_text': 'Cleanliness may create tension.',
          'question_texts': ['What does clean enough look like?'],
          'is_primary_focus': true,
        },
      ],
      'limitation_text': 'Use this to guide the conversation.',
    },
  });

  setUp(() {
    repository = _MockFitCheckRepository();
    when(
      () => repository.getOwnerBriefing(
        submissionId: submissionId,
        locale: locale,
      ),
    ).thenAnswer((_) async => briefing);
  });

  FitCheckBriefingCubit buildCubit() {
    return FitCheckBriefingCubit(
      repository: repository,
      submissionId: submissionId,
      locale: locale,
    );
  }

  blocTest<FitCheckBriefingCubit, FitCheckBriefingState>(
    'emits loading then ready on success',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<FitCheckBriefingState>().having(
        (state) => state.status,
        'status',
        FitCheckBriefingStatus.loading,
      ),
      isA<FitCheckBriefingState>()
          .having(
            (state) => state.status,
            'status',
            FitCheckBriefingStatus.ready,
          )
          .having((state) => state.briefing, 'briefing', briefing),
    ],
  );

  blocTest<FitCheckBriefingCubit, FitCheckBriefingState>(
    'emits failure on repository error',
    build: () {
      when(
        () => repository.getOwnerBriefing(
          submissionId: submissionId,
          locale: locale,
        ),
      ).thenThrow(StateError('Missing fit check owner briefing response.'));
      return buildCubit();
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<FitCheckBriefingState>().having(
        (state) => state.status,
        'status',
        FitCheckBriefingStatus.loading,
      ),
      isA<FitCheckBriefingState>()
          .having(
            (state) => state.status,
            'status',
            FitCheckBriefingStatus.failure,
          )
          .having(
            (state) => state.errorMessage,
            'errorMessage',
            'Missing fit check owner briefing response.',
          ),
    ],
  );
}
