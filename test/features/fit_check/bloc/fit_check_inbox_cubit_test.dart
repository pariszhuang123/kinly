import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_inbox_cubit.dart';

class _MockFitCheckRepository extends Mock implements FitCheckRepository {}

void main() {
  late _MockFitCheckRepository repository;

  const draftId = 'draft-1';
  const locale = 'en';

  final review = FitCheckOwnerReview.fromJson({
    'draft_id': draftId,
    'home_id': 'home-1',
    'owner_summary': {
      'labels': ['Quiet nights'],
    },
    'submissions': [
      {
        'submission_id': 'submission-1',
        'display_name': 'Alex',
        'review_label': 'Alex · Mar 21',
        'submitted_at': '2026-03-21T09:00:00Z',
        'preview': {
          'summary_label': 'A few things to discuss',
        },
      },
    ],
  });

  setUp(() {
    repository = _MockFitCheckRepository();
    when(
      () => repository.getOwnerReview(draftId: draftId, locale: locale),
    ).thenAnswer((_) async => review);
    when(
      () => repository.getPrefillPayload(draftId: draftId),
    ).thenAnswer(
      (_) async => FitCheckPrefillPayload.fromJson({
        'draft_id': draftId,
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
  });

  FitCheckInboxCubit buildCubit() {
    return FitCheckInboxCubit(
      repository: repository,
      draftId: draftId,
      locale: locale,
    );
  }

  blocTest<FitCheckInboxCubit, FitCheckInboxState>(
    'emits loading then ready on success',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<FitCheckInboxState>().having(
        (state) => state.status,
        'status',
        FitCheckInboxStatus.loading,
      ),
      isA<FitCheckInboxState>()
          .having(
            (state) => state.status,
            'status',
            FitCheckInboxStatus.ready,
          )
          .having((state) => state.review, 'review', review),
    ],
  );

  blocTest<FitCheckInboxCubit, FitCheckInboxState>(
    'emits failure on repository error',
    build: () {
      when(
        () => repository.getOwnerReview(draftId: draftId, locale: locale),
      ).thenThrow(Exception('No access'));
      return buildCubit();
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<FitCheckInboxState>().having(
        (state) => state.status,
        'status',
        FitCheckInboxStatus.loading,
      ),
      isA<FitCheckInboxState>()
          .having(
            (state) => state.status,
            'status',
            FitCheckInboxStatus.failure,
          )
          .having(
            (state) => state.errorMessage,
            'errorMessage',
            'No access',
          ),
    ],
  );

  test('getPrefillPayload requests the active draft id', () async {
    final cubit = buildCubit();

    final payload = await cubit.getPrefillPayload();

    expect(payload.draftId, draftId);
    verify(() => repository.getPrefillPayload(draftId: draftId)).called(1);
    await cubit.close();
  });
}
