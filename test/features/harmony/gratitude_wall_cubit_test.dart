import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/harmony/bloc/gratitude_wall_cubit.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/features/harmony/harmony.dart';
import 'package:kinly/features/home/home.dart';

class _MockMoodRepository extends Mock implements MoodRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late _MockMoodRepository repo;
  late _MockHomeRepository homeRepo;

  setUp(() {
    repo = _MockMoodRepository();
    homeRepo = _MockHomeRepository();
    when(
      () => homeRepo.logShareEvent(
        feature: any(named: 'feature'),
        channel: any(named: 'channel'),
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async {});
  });

  GratitudeWallPage buildPage() {
    final now = DateTime.now().toUtc();
    return GratitudeWallPage(
      posts: [
        GratitudeWallPost(
          id: 'p1',
          authorUserId: 'u1',
          mood: MoodScale.sunny,
          message: 'Great week!',
          createdAt: now,
        ),
      ],
      cursorCreatedAt: now,
      cursorId: 'p1',
    );
  }

  blocTest<GratitudeWallCubit, GratitudeWallState>(
    'loadInitial fetches posts and marks as read',
    build: () {
      when(
        () => repo.listWall(
          homeId: any(named: 'homeId'),
          limit: any(named: 'limit'),
          cursorCreatedAt: any(named: 'cursorCreatedAt'),
          cursorId: any(named: 'cursorId'),
        ),
      ).thenAnswer((_) async => buildPage());
      when(() => repo.getWallStats(any())).thenAnswer(
        (_) async => const GratitudeWallStats(
          totalPosts: 3,
          unreadCount: 2,
          lastReadAt: null,
        ),
      );
      when(() => repo.markWallRead(any())).thenAnswer((_) async {});
      return GratitudeWallCubit(
        homeId: 'home',
        moodRepository: repo,
        homeRepository: homeRepo,
      );
    },
    act: (cubit) => cubit.loadInitial(),
    expect:
        () => [
          const GratitudeWallState.initial().copyWith(
            isLoading: true,
            error: null,
          ),
          isA<GratitudeWallState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.posts.length, 'posts length', 1)
              .having((s) => s.totalPosts, 'totalPosts', 3)
              .having((s) => s.hasLoaded, 'hasLoaded', true),
        ],
    verify: (_) {
      verify(
        () => repo.listWall(homeId: 'home', limit: any(named: 'limit')),
      ).called(1);
      verify(() => repo.getWallStats('home')).called(1);
      verify(() => repo.markWallRead('home')).called(1);
    },
  );
}
