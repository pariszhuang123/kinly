import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/contracts/flow/ports/chores_repository.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/features/flow/bloc/flow_list_bloc.dart';

class _MockChoresRepository extends Mock implements ChoresRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late _MockChoresRepository choresRepository;
  late _MockHomeRepository homeRepository;

  const homeId = 'home-123';
  const ownerUserId = 'user-owner';
  const memberUserId = 'user-member';

  final ownerMember = HomeMemberSummary(
    userId: ownerUserId,
    username: 'Owner',
    role: 'owner',
    validFrom: DateTime(2024, 1, 1),
  );

  final regularMember = HomeMemberSummary(
    userId: memberUserId,
    username: 'Member',
    role: 'member',
    validFrom: DateTime(2024, 1, 2),
  );

  ChoreListEntry createChoreEntry({
    required String id,
    required DateTime startDate,
  }) {
    return ChoreListEntry(
      id: id,
      homeId: homeId,
      name: 'Chore $id',
      startDate: startDate,
      assigneeUserId: memberUserId,
      assigneeFullName: 'Member',
    );
  }

  FlowListBloc buildBloc() {
    return FlowListBloc(
      homeId: homeId,
      choresRepository: choresRepository,
      homeRepository: homeRepository,
    );
  }

  setUp(() {
    choresRepository = _MockChoresRepository();
    homeRepository = _MockHomeRepository();

    when(
      () => homeRepository.listActiveMembers(
        any(),
        excludeSelf: any(named: 'excludeSelf'),
      ),
    ).thenAnswer((_) async => [ownerMember, regularMember]);

    when(() => choresRepository.listForHome(any())).thenAnswer((_) async => []);
  });

  group('FlowListBloc', () {
    test('initial state is FlowListStatus.initial', () {
      final bloc = buildBloc();
      expect(bloc.state.status, FlowListStatus.initial);
      expect(bloc.state.items, isEmpty);
      expect(bloc.state.isRefreshing, isFalse);
      expect(bloc.state.errorMessage, isNull);
      expect(bloc.state.ownerUserId, isNull);
      bloc.close();
    });

    group('FlowListRequested', () {
      blocTest<FlowListBloc, FlowListState>(
        'emits loading then success with items',
        build: () {
          final today = DateTime.now();
          final yesterday = today.subtract(const Duration(days: 1));
          when(() => choresRepository.listForHome(homeId)).thenAnswer(
            (_) async => [
              createChoreEntry(id: '1', startDate: yesterday),
              createChoreEntry(id: '2', startDate: today),
            ],
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const FlowListRequested()),
        expect:
            () => [
              isA<FlowListState>().having(
                (s) => s.status,
                'status',
                FlowListStatus.loading,
              ),
              isA<FlowListState>()
                  .having((s) => s.status, 'status', FlowListStatus.success)
                  .having((s) => s.items.length, 'items.length', 2)
                  .having((s) => s.ownerUserId, 'ownerUserId', ownerUserId)
                  .having((s) => s.isRefreshing, 'isRefreshing', false),
            ],
        verify: (_) {
          verify(
            () => homeRepository.listActiveMembers(homeId, excludeSelf: false),
          ).called(1);
          verify(() => choresRepository.listForHome(homeId)).called(1);
        },
      );

      blocTest<FlowListBloc, FlowListState>(
        'filters out future chores',
        build: () {
          final today = DateTime.now();
          final tomorrow = today.add(const Duration(days: 1));
          final yesterday = today.subtract(const Duration(days: 1));
          when(() => choresRepository.listForHome(homeId)).thenAnswer(
            (_) async => [
              createChoreEntry(id: '1', startDate: yesterday),
              createChoreEntry(id: '2', startDate: today),
              createChoreEntry(id: '3', startDate: tomorrow),
            ],
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const FlowListRequested()),
        expect:
            () => [
              isA<FlowListState>().having(
                (s) => s.status,
                'status',
                FlowListStatus.loading,
              ),
              isA<FlowListState>()
                  .having((s) => s.status, 'status', FlowListStatus.success)
                  .having((s) => s.items.length, 'items.length', 2)
                  .having(
                    (s) => s.items.every((i) => i.id != '3'),
                    'excludes future',
                    true,
                  ),
            ],
      );

      blocTest<FlowListBloc, FlowListState>(
        'emits failure on repository error',
        build: () {
          when(
            () => choresRepository.listForHome(homeId),
          ).thenThrow(Exception('Network error'));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const FlowListRequested()),
        expect:
            () => [
              isA<FlowListState>().having(
                (s) => s.status,
                'status',
                FlowListStatus.loading,
              ),
              isA<FlowListState>()
                  .having((s) => s.status, 'status', FlowListStatus.failure)
                  .having(
                    (s) => s.errorMessage,
                    'errorMessage',
                    contains('Network error'),
                  ),
            ],
      );

      blocTest<FlowListBloc, FlowListState>(
        'handles empty members list gracefully',
        build: () {
          when(
            () => homeRepository.listActiveMembers(
              any(),
              excludeSelf: any(named: 'excludeSelf'),
            ),
          ).thenAnswer((_) async => []);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const FlowListRequested()),
        expect:
            () => [
              isA<FlowListState>().having(
                (s) => s.status,
                'status',
                FlowListStatus.loading,
              ),
              isA<FlowListState>()
                  .having((s) => s.status, 'status', FlowListStatus.success)
                  .having((s) => s.ownerUserId, 'ownerUserId', isNull),
            ],
      );

      blocTest<FlowListBloc, FlowListState>(
        'finds owner when not first in list',
        build: () {
          when(
            () => homeRepository.listActiveMembers(
              any(),
              excludeSelf: any(named: 'excludeSelf'),
            ),
          ).thenAnswer((_) async => [regularMember, ownerMember]);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const FlowListRequested()),
        expect:
            () => [
              isA<FlowListState>(),
              isA<FlowListState>().having(
                (s) => s.ownerUserId,
                'ownerUserId',
                ownerUserId,
              ),
            ],
      );
    });

    group('FlowListRefreshed', () {
      blocTest<FlowListBloc, FlowListState>(
        'emits isRefreshing then success',
        build: () {
          when(() => choresRepository.listForHome(homeId)).thenAnswer(
            (_) async => [createChoreEntry(id: '1', startDate: DateTime.now())],
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const FlowListRefreshed()),
        expect:
            () => [
              isA<FlowListState>().having(
                (s) => s.isRefreshing,
                'isRefreshing',
                true,
              ),
              isA<FlowListState>()
                  .having((s) => s.status, 'status', FlowListStatus.success)
                  .having((s) => s.isRefreshing, 'isRefreshing', false),
            ],
      );

      blocTest<FlowListBloc, FlowListState>(
        'does not emit refreshing if already refreshing',
        build: buildBloc,
        seed: () => const FlowListState(isRefreshing: true),
        act: (bloc) => bloc.add(const FlowListRefreshed()),
        expect:
            () => [
              isA<FlowListState>()
                  .having((s) => s.status, 'status', FlowListStatus.success)
                  .having((s) => s.isRefreshing, 'isRefreshing', false),
            ],
      );

      blocTest<FlowListBloc, FlowListState>(
        'emits failure on refresh error',
        build: () {
          when(
            () => choresRepository.listForHome(homeId),
          ).thenThrow(Exception('Refresh failed'));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const FlowListRefreshed()),
        expect:
            () => [
              isA<FlowListState>().having(
                (s) => s.isRefreshing,
                'isRefreshing',
                true,
              ),
              isA<FlowListState>()
                  .having((s) => s.status, 'status', FlowListStatus.failure)
                  .having((s) => s.isRefreshing, 'isRefreshing', false)
                  .having(
                    (s) => s.errorMessage,
                    'errorMessage',
                    contains('Refresh failed'),
                  ),
            ],
      );
    });
  });

  group('FlowListState', () {
    test('isEmpty returns true when success with no items', () {
      const state = FlowListState(status: FlowListStatus.success, items: []);
      expect(state.isEmpty, isTrue);
    });

    test('isEmpty returns false when loading', () {
      const state = FlowListState(status: FlowListStatus.loading, items: []);
      expect(state.isEmpty, isFalse);
    });

    test('isEmpty returns false when has items', () {
      final state = FlowListState(
        status: FlowListStatus.success,
        items: [createChoreEntry(id: '1', startDate: DateTime.now())],
      );
      expect(state.isEmpty, isFalse);
    });

    test('copyWith clearError removes errorMessage', () {
      const state = FlowListState(errorMessage: 'Some error');
      final cleared = state.copyWith(clearError: true);
      expect(cleared.errorMessage, isNull);
    });
  });
}
