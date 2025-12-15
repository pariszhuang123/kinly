import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/features/harmony/bloc/harmony_cubit.dart';
import 'package:kinly/core/mood/enums/mood_scale.dart';
import 'package:kinly/core/mood/models.dart';
import 'package:kinly/data/repositories/mood_repository.dart';

class _MockMoodRepository extends Mock implements MoodRepository {}

void main() {
  late _MockMoodRepository repo;

  setUpAll(() {
    registerFallbackValue(MoodScale.sunny);
  });

  setUp(() {
    repo = _MockMoodRepository();
  });

  test('addToWall defaults false until both mood and comment are eligible', () {
    final cubit = HarmonyCubit(homeId: 'home', moodRepository: repo);

    expect(cubit.state.addToWall, isFalse);

    cubit.selectMood(MoodScale.sunny);
    expect(cubit.state.addToWall, isFalse, reason: 'No comment yet');

    cubit.commentChanged(' Nice week ');
    expect(cubit.state.addToWall, isTrue,
        reason: 'Sunny + comment should pre-check');
  });

  test('manual untick stays off even after further edits', () {
    final cubit = HarmonyCubit(homeId: 'home', moodRepository: repo);
    cubit.selectMood(MoodScale.sunny);
    cubit.commentChanged('Great vibe');
    expect(cubit.state.addToWall, isTrue);

    cubit.toggleAddToWall(false);
    expect(cubit.state.addToWall, isFalse);

    cubit.commentChanged('Even better');
    expect(cubit.state.addToWall, isFalse,
        reason: 'User choice respected while eligible');
  });

  test('reselecting same mood keeps state unchanged', () {
    final cubit = HarmonyCubit(homeId: 'home', moodRepository: repo);
    cubit.selectMood(MoodScale.sunny);
    cubit.commentChanged('Great vibe');
    final initial = cubit.state;

    cubit.selectMood(MoodScale.sunny);

    expect(cubit.state, same(initial));
  });

  blocTest<HarmonyCubit, HarmonyState>(
    'submit posts to wall only when comment + positive mood',
    build: () {
      when(
        () => repo.submit(
          homeId: any(named: 'homeId'),
          mood: any(named: 'mood'),
          comment: any(named: 'comment'),
          addToWall: any(named: 'addToWall'),
        ),
      ).thenAnswer(
        (_) async => const MoodSubmitResult(
          entryId: 'e1',
          gratitudePostId: 'g1',
        ),
      );
      return HarmonyCubit(homeId: 'home', moodRepository: repo);
    },
    act: (cubit) {
      cubit.selectMood(MoodScale.sunny);
      cubit.commentChanged('Sharing sunshine');
      return cubit.submit();
    },
    verify: (cubit) {
      verify(
        () => repo.submit(
          homeId: 'home',
          mood: MoodScale.sunny,
          comment: 'Sharing sunshine',
          addToWall: true,
        ),
      ).called(1);
      expect(cubit.state.submitSuccessTick, 1);
    },
  );

  blocTest<HarmonyCubit, HarmonyState>(
    'submit does not post to wall when no comment',
    build: () {
      when(
        () => repo.submit(
          homeId: any(named: 'homeId'),
          mood: any(named: 'mood'),
          comment: any(named: 'comment'),
          addToWall: any(named: 'addToWall'),
        ),
      ).thenAnswer(
        (_) async => const MoodSubmitResult(entryId: 'e2'),
      );
      return HarmonyCubit(homeId: 'home', moodRepository: repo);
    },
    act: (cubit) {
      cubit.selectMood(MoodScale.sunny);
      // No comment set
      return cubit.submit();
    },
    verify: (_) {
      verify(
        () => repo.submit(
          homeId: 'home',
          mood: MoodScale.sunny,
          comment: '',
          addToWall: false,
        ),
      ).called(1);
    },
  );
}
