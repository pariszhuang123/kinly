import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/features/harmony/bloc/harmony_cubit.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/features/harmony/harmony.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';

class _MockMoodRepository extends Mock implements MoodRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late _MockMoodRepository repo;
  late _MockHomeRepository homeRepo;
  final memberOne = HomeMemberSummary(
    userId: 'u1',
    username: 'One',
    role: 'member',
    validFrom: DateTime.fromMillisecondsSinceEpoch(0),
    avatarUrl: null,
  );
  final memberTwo = HomeMemberSummary(
    userId: 'u2',
    username: 'Two',
    role: 'member',
    validFrom: DateTime.fromMillisecondsSinceEpoch(0),
    avatarUrl: null,
  );

  setUpAll(() {
    registerFallbackValue(MoodScale.sunny);
  });

  setUp(() {
    repo = _MockMoodRepository();
    homeRepo = _MockHomeRepository();
    when(
      () => homeRepo.listActiveMembers(
        any(),
        excludeSelf: any(named: 'excludeSelf'),
      ),
    ).thenAnswer((_) async => [memberOne, memberTwo]);
  });

  test('addToWall defaults false until both mood and comment are eligible', () {
    final cubit = HarmonyCubit(
      homeId: 'home',
      moodRepository: repo,
      homeRepository: homeRepo,
    );

    expect(cubit.state.addToWall, isFalse);

    cubit.selectMood(MoodScale.sunny);
    expect(cubit.state.addToWall, isFalse, reason: 'No comment yet');

    cubit.commentChanged(' Nice week ');
    expect(
      cubit.state.addToWall,
      isTrue,
      reason: 'Sunny + comment should pre-check',
    );
  });

  test('manual untick stays off even after further edits', () {
    final cubit = HarmonyCubit(
      homeId: 'home',
      moodRepository: repo,
      homeRepository: homeRepo,
    );
    cubit.selectMood(MoodScale.sunny);
    cubit.commentChanged('Great vibe');
    expect(cubit.state.addToWall, isTrue);

    cubit.toggleAddToWall(false);
    expect(cubit.state.addToWall, isFalse);

    cubit.commentChanged('Even better');
    expect(
      cubit.state.addToWall,
      isFalse,
      reason: 'User choice respected while eligible',
    );
  });

  test('reselecting same mood keeps state unchanged', () {
    final cubit = HarmonyCubit(
      homeId: 'home',
      moodRepository: repo,
      homeRepository: homeRepo,
    );
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
          mentions: any(named: 'mentions'),
        ),
      ).thenAnswer(
        (_) async => const MoodSubmitResult(entryId: 'e1', publicPostId: 'g1'),
      );
      return HarmonyCubit(
        homeId: 'home',
        moodRepository: repo,
        homeRepository: homeRepo,
      );
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
          mentions: const <String>[],
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
          mentions: any(named: 'mentions'),
        ),
      ).thenAnswer((_) async => const MoodSubmitResult(entryId: 'e2'));
      return HarmonyCubit(
        homeId: 'home',
        moodRepository: repo,
        homeRepository: homeRepo,
      );
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
          mentions: const <String>[],
        ),
      ).called(1);
    },
  );

  blocTest<HarmonyCubit, HarmonyState>(
    'mentions clear when switching to non-positive mood',
    build: () {
      return HarmonyCubit(
        homeId: 'home',
        moodRepository: repo,
        homeRepository: homeRepo,
      );
    },
    act: (cubit) async {
      cubit.selectMood(MoodScale.sunny);
      await cubit.loadMembers();
      cubit.toggleMention('u1');
      cubit.selectMood(MoodScale.rainy);
    },
    verify: (cubit) {
      expect(cubit.state.selectedMentions, isEmpty);
    },
  );

  blocTest<HarmonyCubit, HarmonyState>(
    'mentions capped at 5',
    build: () {
      return HarmonyCubit(
        homeId: 'home',
        moodRepository: repo,
        homeRepository: homeRepo,
      );
    },
    act: (cubit) async {
      cubit.selectMood(MoodScale.sunny);
      await cubit.loadMembers();
      for (var i = 0; i < 6; i++) {
        cubit.toggleMention('u$i');
      }
    },
    verify: (cubit) {
      expect(cubit.state.selectedMentions.length, 5);
    },
  );
}
