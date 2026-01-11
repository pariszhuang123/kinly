import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/features/harmony/bloc/gratitude_wall_cubit.dart';
import 'package:kinly/features/harmony/harmony.dart';
import 'package:kinly/features/home/home.dart';

class _MockMoodRepository extends Mock implements MoodRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockLogger extends Mock implements Logger {}

void main() {
  late _MockMoodRepository repo;
  late _MockHomeRepository homeRepo;
  late _MockLogger logger;

  const homeId = 'home-123';

  setUp(() {
    repo = _MockMoodRepository();
    homeRepo = _MockHomeRepository();
    logger = _MockLogger();

    when(
      () => homeRepo.logShareEvent(
        feature: any(named: 'feature'),
        channel: any(named: 'channel'),
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => logger.warn(
        any(),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
        tag: any(named: 'tag'),
      ),
    ).thenReturn(null);
  });

  GratitudeWallCubit buildCubit() {
    return GratitudeWallCubit(
      homeId: homeId,
      moodRepository: repo,
      homeRepository: homeRepo,
      logger: logger,
    );
  }

  GratitudeWallPage buildPage({
    List<GratitudeWallPost>? posts,
    DateTime? cursorCreatedAt,
    String? cursorId,
  }) {
    final now = DateTime.now().toUtc();
    return GratitudeWallPage(
      posts: posts ??
          [
            GratitudeWallPost(
              id: 'p1',
              authorUserId: 'u1',
              mood: MoodScale.sunny,
              message: 'Great week!',
              createdAt: now,
            ),
          ],
      cursorCreatedAt: cursorCreatedAt ?? now,
      cursorId: cursorId ?? 'p1',
    );
  }

  void setupDefaultMocks() {
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
  }

  group('GratitudeWallCubit', () {
    test('initial state is correct', () {
      setupDefaultMocks();
      final cubit = buildCubit();
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.isLoadingMore, isFalse);
      expect(cubit.state.posts, isEmpty);
      expect(cubit.state.hasMore, isTrue);
      expect(cubit.state.hasLoaded, isFalse);
      expect(cubit.state.error, isNull);
      cubit.close();
    });

    group('loadInitial', () {
      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'fetches posts and marks as read',
        build: () {
          setupDefaultMocks();
          return buildCubit();
        },
        act: (cubit) => cubit.loadInitial(),
        expect: () => [
          isA<GratitudeWallState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.error, 'error', isNull),
          isA<GratitudeWallState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.posts.length, 'posts length', 1)
              .having((s) => s.totalPosts, 'totalPosts', 3)
              .having((s) => s.hasLoaded, 'hasLoaded', true)
              .having((s) => s.hasMore, 'hasMore', true),
        ],
        verify: (_) {
          verify(() => repo.listWall(homeId: homeId, limit: any(named: 'limit'))).called(1);
          verify(() => repo.getWallStats(homeId)).called(1);
          verify(() => repo.markWallRead(homeId)).called(1);
        },
      );

      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'does not load if already loading',
        build: () {
          setupDefaultMocks();
          return buildCubit();
        },
        seed: () => const GratitudeWallState.initial().copyWith(isLoading: true),
        act: (cubit) => cubit.loadInitial(),
        expect: () => [],
        verify: (_) {
          verifyNever(() => repo.listWall(
                homeId: any(named: 'homeId'),
                limit: any(named: 'limit'),
                cursorCreatedAt: any(named: 'cursorCreatedAt'),
                cursorId: any(named: 'cursorId'),
              ));
        },
      );

      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'emits error on failure',
        build: () {
          when(
            () => repo.listWall(
              homeId: any(named: 'homeId'),
              limit: any(named: 'limit'),
              cursorCreatedAt: any(named: 'cursorCreatedAt'),
              cursorId: any(named: 'cursorId'),
            ),
          ).thenThrow(Exception('Network error'));
          when(() => repo.getWallStats(any())).thenAnswer(
            (_) async => const GratitudeWallStats(
              totalPosts: 0,
              unreadCount: 0,
              lastReadAt: null,
            ),
          );
          return buildCubit();
        },
        act: (cubit) => cubit.loadInitial(),
        expect: () => [
          isA<GratitudeWallState>().having((s) => s.isLoading, 'isLoading', true),
          isA<GratitudeWallState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.error, 'error', contains('Network error')),
        ],
      );

      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'sets hasMore to false when all posts loaded',
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
              totalPosts: 1,
              unreadCount: 0,
              lastReadAt: null,
            ),
          );
          when(() => repo.markWallRead(any())).thenAnswer((_) async {});
          return buildCubit();
        },
        act: (cubit) => cubit.loadInitial(),
        expect: () => [
          isA<GratitudeWallState>(),
          isA<GratitudeWallState>().having((s) => s.hasMore, 'hasMore', false),
        ],
      );
    });

    group('loadMore', () {
      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'appends posts to existing list',
        build: () {
          final now = DateTime.now().toUtc();
          when(
            () => repo.listWall(
              homeId: any(named: 'homeId'),
              limit: any(named: 'limit'),
              cursorCreatedAt: any(named: 'cursorCreatedAt'),
              cursorId: any(named: 'cursorId'),
            ),
          ).thenAnswer(
            (_) async => GratitudeWallPage(
              posts: [
                GratitudeWallPost(
                  id: 'p2',
                  authorUserId: 'u2',
                  mood: MoodScale.cloudy,
                  message: 'Okay week',
                  createdAt: now,
                ),
              ],
              cursorCreatedAt: now,
              cursorId: 'p2',
            ),
          );
          return buildCubit();
        },
        seed: () {
          final now = DateTime.now().toUtc();
          return GratitudeWallState(
            posts: [
              GratitudeWallPost(
                id: 'p1',
                authorUserId: 'u1',
                mood: MoodScale.sunny,
                message: 'Great!',
                createdAt: now,
              ),
            ],
            isLoading: false,
            isLoadingMore: false,
            hasMore: true,
            hasLoaded: true,
            totalPosts: 5,
            cursorCreatedAt: now,
            cursorId: 'p1',
          );
        },
        act: (cubit) => cubit.loadMore(),
        expect: () => [
          isA<GratitudeWallState>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
          isA<GratitudeWallState>()
              .having((s) => s.isLoadingMore, 'isLoadingMore', false)
              .having((s) => s.posts.length, 'posts.length', 2)
              .having((s) => s.hasLoaded, 'hasLoaded', true),
        ],
      );

      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'does not load if already loading more',
        build: () {
          setupDefaultMocks();
          return buildCubit();
        },
        seed: () => const GratitudeWallState.initial().copyWith(isLoadingMore: true),
        act: (cubit) => cubit.loadMore(),
        expect: () => [],
      );

      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'does not load if no more items',
        build: () {
          setupDefaultMocks();
          return buildCubit();
        },
        seed: () => const GratitudeWallState.initial().copyWith(hasMore: false),
        act: (cubit) => cubit.loadMore(),
        expect: () => [],
      );

      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'emits error on failure',
        build: () {
          when(
            () => repo.listWall(
              homeId: any(named: 'homeId'),
              limit: any(named: 'limit'),
              cursorCreatedAt: any(named: 'cursorCreatedAt'),
              cursorId: any(named: 'cursorId'),
            ),
          ).thenThrow(Exception('Load more failed'));
          return buildCubit();
        },
        seed: () => const GratitudeWallState.initial().copyWith(hasMore: true),
        act: (cubit) => cubit.loadMore(),
        expect: () => [
          isA<GratitudeWallState>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
          isA<GratitudeWallState>()
              .having((s) => s.isLoadingMore, 'isLoadingMore', false)
              .having((s) => s.error, 'error', contains('Load more failed')),
        ],
      );

      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'sets hasMore to false when all posts loaded',
        build: () {
          final now = DateTime.now().toUtc();
          when(
            () => repo.listWall(
              homeId: any(named: 'homeId'),
              limit: any(named: 'limit'),
              cursorCreatedAt: any(named: 'cursorCreatedAt'),
              cursorId: any(named: 'cursorId'),
            ),
          ).thenAnswer(
            (_) async => GratitudeWallPage(
              posts: [
                GratitudeWallPost(
                  id: 'p2',
                  authorUserId: 'u2',
                  mood: MoodScale.cloudy,
                  message: 'Second',
                  createdAt: now,
                ),
              ],
              cursorCreatedAt: now,
              cursorId: 'p2',
            ),
          );
          return buildCubit();
        },
        seed: () {
          final now = DateTime.now().toUtc();
          return GratitudeWallState(
            posts: [
              GratitudeWallPost(
                id: 'p1',
                authorUserId: 'u1',
                mood: MoodScale.sunny,
                message: 'First',
                createdAt: now,
              ),
            ],
            isLoading: false,
            isLoadingMore: false,
            hasMore: true,
            hasLoaded: true,
            totalPosts: 2,
            cursorCreatedAt: now,
            cursorId: 'p1',
          );
        },
        act: (cubit) => cubit.loadMore(),
        expect: () => [
          isA<GratitudeWallState>(),
          isA<GratitudeWallState>().having((s) => s.hasMore, 'hasMore', false),
        ],
      );
    });

    group('logShareEvent', () {
      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'calls repository logShareEvent',
        build: () {
          setupDefaultMocks();
          return buildCubit();
        },
        act: (cubit) => cubit.logShareEvent(),
        verify: (_) {
          verify(
            () => homeRepo.logShareEvent(
              feature: 'gratitude_wall_house',
              channel: 'system_share',
              homeId: homeId,
            ),
          ).called(1);
        },
      );

      blocTest<GratitudeWallCubit, GratitudeWallState>(
        'logs warning on error but does not throw',
        build: () {
          when(
            () => homeRepo.logShareEvent(
              feature: any(named: 'feature'),
              channel: any(named: 'channel'),
              homeId: any(named: 'homeId'),
            ),
          ).thenThrow(Exception('Share log failed'));
          return buildCubit();
        },
        act: (cubit) => cubit.logShareEvent(),
        verify: (_) {
          verify(
            () => logger.warn(
              'Failed to log gratitude wall share',
              error: any(named: 'error'),
              stackTrace: any(named: 'stackTrace'),
              tag: 'GratitudeWall',
            ),
          ).called(1);
        },
      );
    });
  });

  group('GratitudeWallState', () {
    test('copyWith preserves values when not overridden', () {
      final now = DateTime.now();
      final state = GratitudeWallState(
        posts: const [],
        isLoading: true,
        isLoadingMore: true,
        hasMore: false,
        hasLoaded: true,
        totalPosts: 10,
        cursorCreatedAt: now,
        cursorId: 'cursor',
        error: 'error',
      );

      final copied = state.copyWith();

      expect(copied.isLoading, true);
      expect(copied.isLoadingMore, true);
      expect(copied.hasMore, false);
      expect(copied.hasLoaded, true);
      expect(copied.totalPosts, 10);
      expect(copied.error, 'error');
    });

    test('copyWith clearError removes error', () {
      const state = GratitudeWallState.initial();
      final withError = state.copyWith(error: 'Some error');
      final cleared = withError.copyWith(clearError: true);

      expect(cleared.error, isNull);
    });
  });
}
