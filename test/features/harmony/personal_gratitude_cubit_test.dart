import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/personal_wall_models.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/features/harmony/bloc/personal_gratitude_cubit.dart';

class _MockMoodRepository extends Mock implements MoodRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockLogger extends Mock implements Logger {}

void main() {
  late _MockMoodRepository moodRepo;
  late _MockHomeRepository homeRepo;
  late _MockLogger logger;

  const homeId = 'home-123';

  setUp(() {
    moodRepo = _MockMoodRepository();
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

  PersonalGratitudeCubit buildCubit() {
    return PersonalGratitudeCubit(
      moodRepository: moodRepo,
      homeRepository: homeRepo,
      homeId: homeId,
      logger: logger,
    );
  }

  PersonalGratitudeItem buildItem({
    String id = 'item-1',
    String authorUserId = 'user-1',
  }) {
    return PersonalGratitudeItem(
      id: id,
      createdAt: DateTime.now().toUtc(),
      homeId: homeId,
      mood: MoodScale.sunny,
      message: 'Thank you!',
      sourceKind: 'mention',
      sourcePostId: 'post-1',
      sourceEntryId: 'entry-1',
      authorUserId: authorUserId,
      authorUsername: 'alice',
      authorAvatarPath: null,
    );
  }

  PersonalGratitudePage buildPage({
    List<PersonalGratitudeItem>? items,
    DateTime? cursorCreatedAt,
    String? cursorId,
  }) {
    final now = DateTime.now().toUtc();
    return PersonalGratitudePage(
      items: items ?? [buildItem()],
      cursorCreatedAt: cursorCreatedAt ?? now,
      cursorId: cursorId ?? 'item-1',
    );
  }

  void setupDefaultMocks({int totalReceived = 5}) {
    when(() => moodRepo.getPersonalStatus()).thenAnswer(
      (_) async => PersonalGratitudeStatus(
        hasUnread: true,
        lastReadAt: DateTime.now().toUtc(),
      ),
    );
    when(() => moodRepo.getPersonalStats()).thenAnswer(
      (_) async => PersonalGratitudeStats(
        totalReceived: totalReceived,
        uniqueIndividuals: 3,
        uniqueHomes: 2,
      ),
    );
    when(
      () => moodRepo.listPersonalWall(
        limit: any(named: 'limit'),
        beforeAt: any(named: 'beforeAt'),
        beforeId: any(named: 'beforeId'),
      ),
    ).thenAnswer((_) async => buildPage());
    when(() => moodRepo.markPersonalWallRead()).thenAnswer((_) async {});
  }

  group('PersonalGratitudeCubit', () {
    test('initial state is correct', () {
      setupDefaultMocks();
      final cubit = buildCubit();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.isLoadingMore, isFalse);
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.hasMore, isFalse);
      expect(cubit.state.hasLoaded, isFalse);
      expect(cubit.state.error, isNull);
      expect(cubit.state.status, isNull);
      expect(cubit.state.stats, isNull);

      cubit.close();
    });

    group('loadInitial', () {
      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'fetches items, status, stats and marks as read',
        build: () {
          setupDefaultMocks();
          return buildCubit();
        },
        act: (cubit) => cubit.loadInitial(),
        expect:
            () => [
              isA<PersonalGratitudeState>()
                  .having((s) => s.isLoading, 'isLoading', true)
                  .having((s) => s.error, 'error', isNull),
              isA<PersonalGratitudeState>()
                  .having((s) => s.isLoading, 'isLoading', false)
                  .having((s) => s.items.length, 'items.length', 1)
                  .having((s) => s.hasLoaded, 'hasLoaded', true)
                  .having((s) => s.status, 'status', isNotNull)
                  .having((s) => s.stats, 'stats', isNotNull)
                  .having((s) => s.hasMore, 'hasMore', true),
            ],
        verify: (_) {
          verify(() => moodRepo.getPersonalStatus()).called(1);
          verify(() => moodRepo.getPersonalStats()).called(1);
          verify(() => moodRepo.listPersonalWall(limit: 20)).called(1);
          verify(() => moodRepo.markPersonalWallRead()).called(1);
        },
      );

      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'does not load if already loading',
        build: () {
          setupDefaultMocks();
          return buildCubit();
        },
        seed:
            () => const PersonalGratitudeState.initial().copyWith(
              isLoading: true,
            ),
        act: (cubit) => cubit.loadInitial(),
        expect: () => [],
        verify: (_) {
          verifyNever(() => moodRepo.getPersonalStatus());
        },
      );

      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'emits error on failure',
        build: () {
          when(() => moodRepo.getPersonalStatus()).thenThrow(
            Exception('Network error'),
          );
          return buildCubit();
        },
        act: (cubit) => cubit.loadInitial(),
        expect:
            () => [
              isA<PersonalGratitudeState>().having(
                (s) => s.isLoading,
                'isLoading',
                true,
              ),
              isA<PersonalGratitudeState>()
                  .having((s) => s.isLoading, 'isLoading', false)
                  .having((s) => s.error, 'error', contains('Network error')),
            ],
      );

      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'sets hasMore to false when all items loaded',
        build: () {
          setupDefaultMocks(totalReceived: 1);
          return buildCubit();
        },
        act: (cubit) => cubit.loadInitial(),
        expect:
            () => [
              isA<PersonalGratitudeState>(),
              isA<PersonalGratitudeState>().having(
                (s) => s.hasMore,
                'hasMore',
                false,
              ),
            ],
      );

      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'sets hasMore to false when items list is empty',
        build: () {
          when(() => moodRepo.getPersonalStatus()).thenAnswer(
            (_) async => const PersonalGratitudeStatus(
              hasUnread: false,
              lastReadAt: null,
            ),
          );
          when(() => moodRepo.getPersonalStats()).thenAnswer(
            (_) async => const PersonalGratitudeStats(
              totalReceived: 0,
              uniqueIndividuals: 0,
              uniqueHomes: 0,
            ),
          );
          when(
            () => moodRepo.listPersonalWall(
              limit: any(named: 'limit'),
              beforeAt: any(named: 'beforeAt'),
              beforeId: any(named: 'beforeId'),
            ),
          ).thenAnswer(
            (_) async => const PersonalGratitudePage(
              items: [],
              cursorCreatedAt: null,
              cursorId: null,
            ),
          );
          when(() => moodRepo.markPersonalWallRead()).thenAnswer((_) async {});
          return buildCubit();
        },
        act: (cubit) => cubit.loadInitial(),
        expect:
            () => [
              isA<PersonalGratitudeState>(),
              isA<PersonalGratitudeState>()
                  .having((s) => s.hasMore, 'hasMore', false)
                  .having((s) => s.items, 'items', isEmpty),
            ],
      );
    });

    group('loadMore', () {
      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'appends items to existing list',
        build: () {
          when(
            () => moodRepo.listPersonalWall(
              limit: any(named: 'limit'),
              beforeAt: any(named: 'beforeAt'),
              beforeId: any(named: 'beforeId'),
            ),
          ).thenAnswer(
            (_) async => buildPage(
              items: [buildItem(id: 'item-2', authorUserId: 'user-2')],
              cursorId: 'item-2',
            ),
          );
          return buildCubit();
        },
        seed: () {
          final now = DateTime.now().toUtc();
          return PersonalGratitudeState(
            isLoading: false,
            isLoadingMore: false,
            hasMore: true,
            hasLoaded: true,
            items: [buildItem()],
            cursorAt: now,
            cursorId: 'item-1',
          );
        },
        act: (cubit) => cubit.loadMore(),
        expect:
            () => [
              isA<PersonalGratitudeState>().having(
                (s) => s.isLoadingMore,
                'isLoadingMore',
                true,
              ),
              isA<PersonalGratitudeState>()
                  .having((s) => s.isLoadingMore, 'isLoadingMore', false)
                  .having((s) => s.items.length, 'items.length', 2)
                  .having((s) => s.hasLoaded, 'hasLoaded', true),
            ],
      );

      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'does not load if already loading more',
        build: () {
          setupDefaultMocks();
          return buildCubit();
        },
        seed:
            () => const PersonalGratitudeState.initial().copyWith(
              isLoadingMore: true,
            ),
        act: (cubit) => cubit.loadMore(),
        expect: () => [],
      );

      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'does not load if no more items',
        build: () {
          setupDefaultMocks();
          return buildCubit();
        },
        seed:
            () => const PersonalGratitudeState.initial().copyWith(
              hasMore: false,
            ),
        act: (cubit) => cubit.loadMore(),
        expect: () => [],
      );

      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'emits error on failure',
        build: () {
          when(
            () => moodRepo.listPersonalWall(
              limit: any(named: 'limit'),
              beforeAt: any(named: 'beforeAt'),
              beforeId: any(named: 'beforeId'),
            ),
          ).thenThrow(Exception('Load more failed'));
          return buildCubit();
        },
        seed:
            () => const PersonalGratitudeState.initial().copyWith(hasMore: true),
        act: (cubit) => cubit.loadMore(),
        expect:
            () => [
              isA<PersonalGratitudeState>().having(
                (s) => s.isLoadingMore,
                'isLoadingMore',
                true,
              ),
              isA<PersonalGratitudeState>()
                  .having((s) => s.isLoadingMore, 'isLoadingMore', false)
                  .having(
                    (s) => s.error,
                    'error',
                    contains('Load more failed'),
                  ),
            ],
      );

      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'sets hasMore to false when no cursor returned',
        build: () {
          when(
            () => moodRepo.listPersonalWall(
              limit: any(named: 'limit'),
              beforeAt: any(named: 'beforeAt'),
              beforeId: any(named: 'beforeId'),
            ),
          ).thenAnswer(
            (_) async => PersonalGratitudePage(
              items: [buildItem(id: 'item-2')],
              cursorCreatedAt: DateTime.now().toUtc(),
              cursorId: null,
            ),
          );
          return buildCubit();
        },
        seed:
            () => PersonalGratitudeState(
              isLoading: false,
              isLoadingMore: false,
              hasMore: true,
              hasLoaded: true,
              items: [buildItem()],
              cursorAt: DateTime.now().toUtc(),
              cursorId: 'item-1',
            ),
        act: (cubit) => cubit.loadMore(),
        expect:
            () => [
              isA<PersonalGratitudeState>(),
              isA<PersonalGratitudeState>().having(
                (s) => s.hasMore,
                'hasMore',
                false,
              ),
            ],
      );

      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'sets hasMore to false when empty page returned',
        build: () {
          when(
            () => moodRepo.listPersonalWall(
              limit: any(named: 'limit'),
              beforeAt: any(named: 'beforeAt'),
              beforeId: any(named: 'beforeId'),
            ),
          ).thenAnswer(
            (_) async => const PersonalGratitudePage(
              items: [],
              cursorCreatedAt: null,
              cursorId: null,
            ),
          );
          return buildCubit();
        },
        seed:
            () => PersonalGratitudeState(
              isLoading: false,
              isLoadingMore: false,
              hasMore: true,
              hasLoaded: true,
              items: [buildItem()],
              cursorAt: DateTime.now().toUtc(),
              cursorId: 'item-1',
            ),
        act: (cubit) => cubit.loadMore(),
        expect:
            () => [
              isA<PersonalGratitudeState>(),
              isA<PersonalGratitudeState>().having(
                (s) => s.hasMore,
                'hasMore',
                false,
              ),
            ],
      );
    });

    group('logShareEvent', () {
      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
        'calls repository logShareEvent with correct parameters',
        build: () {
          setupDefaultMocks();
          return buildCubit();
        },
        act: (cubit) => cubit.logShareEvent(),
        verify: (_) {
          verify(
            () => homeRepo.logShareEvent(
              feature: 'gratitude_wall_personal',
              channel: 'system_share',
              homeId: homeId,
            ),
          ).called(1);
        },
      );

      blocTest<PersonalGratitudeCubit, PersonalGratitudeState>(
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
              'Failed to log personal gratitude wall share',
              error: any(named: 'error'),
              stackTrace: any(named: 'stackTrace'),
              tag: 'PersonalGratitude',
            ),
          ).called(1);
        },
      );
    });
  });

  group('PersonalGratitudeState', () {
    test('initial constructor has correct defaults', () {
      const state = PersonalGratitudeState.initial();

      expect(state.isLoading, false);
      expect(state.isLoadingMore, false);
      expect(state.hasMore, false);
      expect(state.hasLoaded, false);
      expect(state.items, isEmpty);
      expect(state.cursorAt, isNull);
      expect(state.cursorId, isNull);
      expect(state.status, isNull);
      expect(state.stats, isNull);
      expect(state.error, isNull);
    });

    test('copyWith preserves values when not overridden', () {
      final now = DateTime.now();
      final status = PersonalGratitudeStatus(hasUnread: true, lastReadAt: now);
      const stats = PersonalGratitudeStats(
        totalReceived: 10,
        uniqueIndividuals: 5,
        uniqueHomes: 2,
      );
      final state = PersonalGratitudeState(
        isLoading: true,
        isLoadingMore: true,
        hasMore: true,
        hasLoaded: true,
        items: [buildItem()],
        cursorAt: now,
        cursorId: 'cursor',
        status: status,
        stats: stats,
        error: 'error',
      );

      final copied = state.copyWith(error: 'error');

      expect(copied.isLoading, true);
      expect(copied.isLoadingMore, true);
      expect(copied.hasMore, true);
      expect(copied.hasLoaded, true);
      expect(copied.items.length, 1);
      expect(copied.cursorId, 'cursor');
      expect(copied.status, status);
      expect(copied.stats, stats);
      expect(copied.error, 'error');
    });

    test('copyWith clears error when not passed', () {
      final state = PersonalGratitudeState(
        isLoading: false,
        isLoadingMore: false,
        hasMore: false,
        hasLoaded: true,
        items: const [],
        error: 'Some error',
      );
      final copied = state.copyWith();

      expect(copied.error, isNull);
    });

    test('copyWith can clear error by passing null', () {
      final state = PersonalGratitudeState(
        isLoading: false,
        isLoadingMore: false,
        hasMore: false,
        hasLoaded: true,
        items: const [],
        error: 'Some error',
      );
      final cleared = state.copyWith(error: null);

      expect(cleared.error, isNull);
    });

    test('props includes all fields for equality', () {
      const state1 = PersonalGratitudeState.initial();
      const state2 = PersonalGratitudeState.initial();

      expect(state1.props, state2.props);
    });
  });
}
