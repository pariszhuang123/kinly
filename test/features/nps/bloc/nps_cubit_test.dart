import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/core/supabase/enums/nps_submit_error_code.dart';
import 'package:kinly/features/nps/bloc/nps_cubit.dart';

class _MockMoodRepository extends Mock implements MoodRepository {}

void main() {
  late _MockMoodRepository moodRepository;

  const homeId = 'home-123';

  NpsCubit buildCubit() {
    return NpsCubit(
      homeId: homeId,
      moodRepository: moodRepository,
    );
  }

  setUp(() {
    moodRepository = _MockMoodRepository();
    when(
      () => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')),
    ).thenAnswer((_) async {});
  });

  group('NpsCubit', () {
    test('initial state has default values', () {
      final cubit = buildCubit();
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.submitSuccessTick, 0);
      expect(cubit.state.submitError, isNull);
      expect(cubit.state.lastSubmittedScore, isNull);
      cubit.close();
    });

    group('submitScore', () {
      blocTest<NpsCubit, NpsState>(
        'emits submitting then success on valid score',
        build: buildCubit,
        act: (cubit) => cubit.submitScore(8),
        expect: () => [
          isA<NpsState>()
              .having((s) => s.isSubmitting, 'isSubmitting', true)
              .having((s) => s.lastSubmittedScore, 'lastSubmittedScore', 8),
          isA<NpsState>()
              .having((s) => s.isSubmitting, 'isSubmitting', false)
              .having((s) => s.submitSuccessTick, 'submitSuccessTick', 1)
              .having((s) => s.submitError, 'submitError', isNull)
              .having((s) => s.lastSubmittedScore, 'lastSubmittedScore', 8),
        ],
        verify: (_) {
          verify(() => moodRepository.submitNps(homeId: homeId, score: 8)).called(1);
        },
      );

      blocTest<NpsCubit, NpsState>(
        'does not submit if score < 0',
        build: buildCubit,
        act: (cubit) => cubit.submitScore(-1),
        expect: () => [],
        verify: (_) {
          verifyNever(() => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')));
        },
      );

      blocTest<NpsCubit, NpsState>(
        'does not submit if score > 10',
        build: buildCubit,
        act: (cubit) => cubit.submitScore(11),
        expect: () => [],
        verify: (_) {
          verifyNever(() => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')));
        },
      );

      blocTest<NpsCubit, NpsState>(
        'accepts score 0 (minimum valid)',
        build: buildCubit,
        act: (cubit) => cubit.submitScore(0),
        expect: () => [
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>()
              .having((s) => s.isSubmitting, 'isSubmitting', false)
              .having((s) => s.lastSubmittedScore, 'lastSubmittedScore', 0),
        ],
      );

      blocTest<NpsCubit, NpsState>(
        'accepts score 10 (maximum valid)',
        build: buildCubit,
        act: (cubit) => cubit.submitScore(10),
        expect: () => [
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>().having((s) => s.lastSubmittedScore, 'lastSubmittedScore', 10),
        ],
      );

      blocTest<NpsCubit, NpsState>(
        'does not submit if already submitting',
        build: buildCubit,
        seed: () => const NpsState(isSubmitting: true),
        act: (cubit) => cubit.submitScore(5),
        expect: () => [],
        verify: (_) {
          verifyNever(() => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')));
        },
      );

      blocTest<NpsCubit, NpsState>(
        'emits error on invalidScore exception',
        build: () {
          when(
            () => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')),
          ).thenThrow(const NpsSubmitException(NpsSubmitErrorCode.invalidScore, 'Invalid'));
          return buildCubit();
        },
        act: (cubit) => cubit.submitScore(5),
        expect: () => [
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>()
              .having((s) => s.isSubmitting, 'isSubmitting', false)
              .having((s) => s.submitError, 'submitError', 'invalidScore'),
        ],
      );

      blocTest<NpsCubit, NpsState>(
        'emits error on notEligible exception',
        build: () {
          when(
            () => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')),
          ).thenThrow(const NpsSubmitException(NpsSubmitErrorCode.notEligible, 'Not eligible'));
          return buildCubit();
        },
        act: (cubit) => cubit.submitScore(5),
        expect: () => [
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>().having((s) => s.submitError, 'submitError', 'notEligible'),
        ],
      );

      blocTest<NpsCubit, NpsState>(
        'emits error on notRequired exception',
        build: () {
          when(
            () => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')),
          ).thenThrow(const NpsSubmitException(NpsSubmitErrorCode.notRequired, 'Not required'));
          return buildCubit();
        },
        act: (cubit) => cubit.submitScore(5),
        expect: () => [
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>().having((s) => s.submitError, 'submitError', 'notRequired'),
        ],
      );

      blocTest<NpsCubit, NpsState>(
        'emits forbidden error on forbidden exception',
        build: () {
          when(
            () => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')),
          ).thenThrow(const NpsSubmitException(NpsSubmitErrorCode.forbidden, 'Forbidden'));
          return buildCubit();
        },
        act: (cubit) => cubit.submitScore(5),
        expect: () => [
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>().having((s) => s.submitError, 'submitError', 'forbidden'),
        ],
      );

      blocTest<NpsCubit, NpsState>(
        'emits forbidden error on unauthorized exception',
        build: () {
          when(
            () => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')),
          ).thenThrow(const NpsSubmitException(NpsSubmitErrorCode.unauthorized, 'Unauthorized'));
          return buildCubit();
        },
        act: (cubit) => cubit.submitScore(5),
        expect: () => [
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>().having((s) => s.submitError, 'submitError', 'forbidden'),
        ],
      );

      blocTest<NpsCubit, NpsState>(
        'emits unknown error on unknown exception',
        build: () {
          when(
            () => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')),
          ).thenThrow(const NpsSubmitException(NpsSubmitErrorCode.unknown, 'Unknown'));
          return buildCubit();
        },
        act: (cubit) => cubit.submitScore(5),
        expect: () => [
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>().having((s) => s.submitError, 'submitError', 'unknown'),
        ],
      );

      blocTest<NpsCubit, NpsState>(
        'emits unknown error on generic exception',
        build: () {
          when(
            () => moodRepository.submitNps(homeId: any(named: 'homeId'), score: any(named: 'score')),
          ).thenThrow(Exception('Network failure'));
          return buildCubit();
        },
        act: (cubit) => cubit.submitScore(5),
        expect: () => [
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>().having((s) => s.submitError, 'submitError', 'unknown'),
        ],
      );

      blocTest<NpsCubit, NpsState>(
        'increments submitSuccessTick on each success',
        build: buildCubit,
        act: (cubit) async {
          await cubit.submitScore(5);
          await cubit.submitScore(7);
        },
        expect: () => [
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>().having((s) => s.submitSuccessTick, 'submitSuccessTick', 1),
          isA<NpsState>().having((s) => s.isSubmitting, 'isSubmitting', true),
          isA<NpsState>().having((s) => s.submitSuccessTick, 'submitSuccessTick', 2),
        ],
      );
    });
  });

  group('NpsState', () {
    test('copyWith preserves values when not overridden', () {
      const state = NpsState(
        isSubmitting: true,
        submitSuccessTick: 3,
        lastSubmittedScore: 8,
      );

      final copied = state.copyWith();

      expect(copied.isSubmitting, true);
      expect(copied.submitSuccessTick, 3);
      expect(copied.lastSubmittedScore, 8);
    });

    test('copyWith can override all values', () {
      const state = NpsState();

      final copied = state.copyWith(
        isSubmitting: true,
        submitSuccessTick: 5,
        submitError: 'error',
        lastSubmittedScore: 9,
      );

      expect(copied.isSubmitting, true);
      expect(copied.submitSuccessTick, 5);
      expect(copied.submitError, 'error');
      expect(copied.lastSubmittedScore, 9);
    });

    test('copyWith clears submitError when null passed', () {
      const state = NpsState(submitError: 'old error');

      final copied = state.copyWith(submitError: null);

      expect(copied.submitError, isNull);
    });

    test('props includes all fields', () {
      const state = NpsState(
        isSubmitting: true,
        submitSuccessTick: 2,
        submitError: 'err',
        lastSubmittedScore: 7,
      );

      expect(state.props, [true, 2, 'err', 7]);
    });
  });
}
