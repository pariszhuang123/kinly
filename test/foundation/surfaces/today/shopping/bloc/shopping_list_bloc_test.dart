import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/foundation/surfaces/today/shopping/bloc/shopping_list_bloc.dart';

class _MockShoppingListRepository extends Mock implements ShoppingListRepository {}

void main() {
  late _MockShoppingListRepository shoppingListRepository;

  const homeId = 'home-1';
  const currentUserId = 'user-me';

  ShoppingListItem item({
    required String id,
    required bool isCompleted,
    required DateTime updatedAt,
    String? name,
    String? quantity,
    String? details,
    String? completedByUserId,
    String? photoPath,
    DateTime? archivedAt,
  }) {
    return ShoppingListItem(
      id: id,
      homeId: homeId,
      name: name ?? 'item-$id',
      quantity: quantity,
      details: details,
      referencePhotoPath: photoPath,
      isCompleted: isCompleted,
      completedByUserId: completedByUserId,
      completedByAvatarId: null,
      completedAt: isCompleted ? updatedAt : null,
      archivedAt: archivedAt,
      createdAt: updatedAt.subtract(const Duration(hours: 1)),
      updatedAt: updatedAt,
    );
  }

  ShoppingListBloc buildBloc({String? userId = currentUserId}) {
    return ShoppingListBloc(
      homeId: homeId,
      currentUserId: userId,
      shoppingListRepository: shoppingListRepository,
    );
  }

  setUpAll(() {
    registerFallbackValue(DateTime(2026, 2, 1));
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    shoppingListRepository = _MockShoppingListRepository();

    when(
      () => shoppingListRepository.getForHome(homeId: any(named: 'homeId')),
    ).thenAnswer(
      (_) async => const ShoppingListSnapshot(
        listId: 'list-1',
        itemsUnarchivedCount: 0,
        itemsUncompletedCount: 0,
        items: [],
      ),
    );
    when(
      () => shoppingListRepository.toPublicPhotoUrl(any()),
    ).thenAnswer((invocation) {
      final path = invocation.positionalArguments.first as String?;
      if (path == null || path.isEmpty) return null;
      return 'https://cdn.example/$path';
    });
    when(
      () => shoppingListRepository.updateItem(
        itemId: any(named: 'itemId'),
        name: any(named: 'name'),
        quantity: any(named: 'quantity'),
        details: any(named: 'details'),
        isCompleted: any(named: 'isCompleted'),
        referencePhotoPath: any(named: 'referencePhotoPath'),
        replacePhoto: any(named: 'replacePhoto'),
      ),
    ).thenAnswer(
      (_) async => item(
        id: 'updated',
        isCompleted: true,
        completedByUserId: currentUserId,
        updatedAt: DateTime(2026, 2, 1, 11),
      ),
    );
    when(
      () => shoppingListRepository.archiveItemsForUser(
        homeId: any(named: 'homeId'),
        itemIds: any(named: 'itemIds'),
      ),
    ).thenAnswer((_) async => 1);
    when(
      () => shoppingListRepository.prepareExpenseForUser(
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async => null);
    when(
      () => shoppingListRepository.linkItemsToExpenseForUser(
        homeId: any(named: 'homeId'),
        expenseId: any(named: 'expenseId'),
        itemIds: any(named: 'itemIds'),
      ),
    ).thenAnswer((_) async => 1);
    when(
      () => shoppingListRepository.isItemCompletedByOtherError(any()),
    ).thenReturn(false);
  });

  group('ShoppingListBloc', () {
    test('initial state is loading', () {
      final bloc = buildBloc();
      expect(bloc.state, const ShoppingListState.loading());
      bloc.close();
    });

    blocTest<ShoppingListBloc, ShoppingListState>(
      'loads, filters archived, preserves RPC order, and computes myCompletedCount',
      build: () {
        final now = DateTime(2026, 2, 1, 12);
        when(
          () => shoppingListRepository.getForHome(homeId: homeId),
        ).thenAnswer(
          (_) async => ShoppingListSnapshot(
            listId: 'list-1',
            itemsUnarchivedCount: 4,
            itemsUncompletedCount: 2,
            items: [
              item(
                id: 'pending-old',
                isCompleted: false,
                updatedAt: now.subtract(const Duration(hours: 2)),
                photoPath: 'households/a.jpg',
              ),
              item(
                id: 'pending-new',
                isCompleted: false,
                updatedAt: now.subtract(const Duration(hours: 1)),
              ),
              item(
                id: 'done-mine',
                isCompleted: true,
                completedByUserId: currentUserId,
                updatedAt: now.subtract(const Duration(minutes: 20)),
                photoPath: 'households/b.jpg',
              ),
              item(
                id: 'done-other',
                isCompleted: true,
                completedByUserId: 'user-other',
                updatedAt: now.subtract(const Duration(minutes: 10)),
              ),
              item(
                id: 'archived',
                isCompleted: false,
                updatedAt: now,
                archivedAt: now,
              ),
            ],
          ),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadShoppingListEvent()),
      expect: () => [
        const ShoppingListState.loading(),
        isA<ShoppingListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having(
              (s) => s.pendingItems.map((i) => i.id).toList(),
              'pending order',
              ['pending-old', 'pending-new'],
            )
            .having(
              (s) => s.completedItems.map((i) => i.id).toList(),
              'completed order',
              ['done-mine', 'done-other'],
            )
            .having((s) => s.myCompletedCount, 'myCompletedCount', 1)
            .having(
              (s) => s.photoUrlsByItemId['done-mine'],
              'photo url',
              'https://cdn.example/households/b.jpg',
            ),
      ],
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'shows a message when archiving with no current user',
      build: () => buildBloc(userId: null),
      seed: () => ShoppingListState.loaded(
        pendingItems: const [],
        completedItems: [
          item(
            id: 'mine',
            isCompleted: true,
            completedByUserId: currentUserId,
            updatedAt: DateTime(2026, 2, 1),
          ),
        ],
        photoUrlsByItemId: const {},
        myCompletedCount: 1,
      ),
      act: (bloc) =>
          bloc.add(const ArchiveMyCompletedShoppingItemsEvent(triggerShareSpend: false)),
      expect: () => [
        isA<ShoppingListState>()
            .having((s) => s.message, 'message', 'No completed items to clear')
            .having((s) => s.messageTick, 'messageTick', 1),
      ],
      verify: (_) {
        verifyNever(
          () => shoppingListRepository.archiveItemsForUser(
            homeId: any(named: 'homeId'),
            itemIds: any(named: 'itemIds'),
          ),
        );
      },
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'archives only my completed items when share handoff is disabled',
      build: () => buildBloc(),
      seed: () => ShoppingListState.loaded(
        pendingItems: const [],
        completedItems: [
          item(
            id: 'mine-1',
            isCompleted: true,
            completedByUserId: currentUserId,
            updatedAt: DateTime(2026, 2, 1, 10),
          ),
          item(
            id: 'other-1',
            isCompleted: true,
            completedByUserId: 'user-other',
            updatedAt: DateTime(2026, 2, 1, 11),
          ),
        ],
        photoUrlsByItemId: const {},
        myCompletedCount: 1,
      ),
      act: (bloc) =>
          bloc.add(const ArchiveMyCompletedShoppingItemsEvent(triggerShareSpend: false)),
      expect: () => [
        isA<ShoppingListState>()
            .having((s) => s.archivedTick, 'archivedTick', 1),
      ],
      verify: (_) {
        verify(
          () => shoppingListRepository.archiveItemsForUser(
            homeId: homeId,
            itemIds: ['mine-1'],
          ),
        ).called(1);
      },
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'emits pending quick bill create when share handoff is enabled',
      build: () {
        when(
          () => shoppingListRepository.prepareExpenseForUser(homeId: homeId),
        ).thenAnswer(
          (_) async => const ShoppingExpenseDraftSeed(
            defaultDescription: '',
            defaultNotes: '',
            itemIds: ['mine-1', 'mine-2'],
            itemCount: 2,
          ),
        );
        when(
          () => shoppingListRepository.getForHome(homeId: homeId),
        ).thenAnswer(
          (_) async => const ShoppingListSnapshot(
            listId: 'list-1',
            itemsUnarchivedCount: 0,
            itemsUncompletedCount: 0,
            items: [],
          ),
        );
        return buildBloc();
      },
      seed: () => ShoppingListState.loaded(
        pendingItems: const [],
        completedItems: [
          item(
            id: 'mine-1',
            isCompleted: true,
            completedByUserId: currentUserId,
            updatedAt: DateTime(2026, 2, 1, 10),
          ),
        ],
        photoUrlsByItemId: const {},
        myCompletedCount: 1,
      ),
      act: (bloc) =>
          bloc.add(const ArchiveMyCompletedShoppingItemsEvent(triggerShareSpend: true)),
      expect: () => [
        isA<ShoppingListState>()
            .having(
              (s) => s.pendingBillCreate?.description,
              'pendingBillCreate.description',
              'Shopping spend',
            )
            .having(
              (s) => s.pendingBillCreate?.notes,
              'pendingBillCreate.notes',
              '- item-mine-1',
            )
            .having(
              (s) => s.pendingBillCreate?.itemIds,
              'pendingBillCreate.itemIds',
              ['mine-1', 'mine-2'],
            )
            .having((s) => s.pendingBillCreateTick, 'pendingBillCreateTick', 1)
            .having((s) => s.archivedTick, 'archivedTick', 0),
        isA<ShoppingListState>()
            .having(
              (s) => s.pendingBillCreate?.description,
              'pendingBillCreate.description',
              'Shopping spend',
            )
            .having((s) => s.pendingBillCreateTick, 'pendingBillCreateTick', 1)
            .having((s) => s.archivedTick, 'archivedTick', 0),
      ],
      verify: (_) {
        verifyNever(
          () => shoppingListRepository.linkItemsToExpenseForUser(
            homeId: any(named: 'homeId'),
            expenseId: any(named: 'expenseId'),
            itemIds: any(named: 'itemIds'),
          ),
        );
      },
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'formats pending quick bill notes with quantity per item and skips empty quantity brackets',
      build: () {
        when(
          () => shoppingListRepository.prepareExpenseForUser(homeId: homeId),
        ).thenAnswer(
          (_) async => const ShoppingExpenseDraftSeed(
            defaultDescription: 'Grocery spend',
            defaultNotes: 'Auto-generated from shopping',
            itemIds: ['mine-1', 'mine-2'],
            itemCount: 2,
          ),
        );
        when(
          () => shoppingListRepository.getForHome(homeId: homeId),
        ).thenAnswer(
          (_) async => const ShoppingListSnapshot(
            listId: 'list-1',
            itemsUnarchivedCount: 0,
            itemsUncompletedCount: 0,
            items: [],
          ),
        );
        return buildBloc();
      },
      seed: () => ShoppingListState.loaded(
        pendingItems: const [],
        completedItems: [
          item(
            id: 'mine-1',
            name: 'Milk',
            quantity: '2 cartons',
            isCompleted: true,
            completedByUserId: currentUserId,
            updatedAt: DateTime(2026, 2, 1, 10),
          ),
          item(
            id: 'mine-2',
            name: 'Eggs',
            quantity: '  ',
            isCompleted: true,
            completedByUserId: currentUserId,
            updatedAt: DateTime(2026, 2, 1, 9),
          ),
        ],
        photoUrlsByItemId: const {},
        myCompletedCount: 2,
      ),
      act: (bloc) =>
          bloc.add(const ArchiveMyCompletedShoppingItemsEvent(triggerShareSpend: true)),
      expect: () => [
        isA<ShoppingListState>()
            .having(
              (s) => s.pendingBillCreate?.description,
              'pendingBillCreate.description',
              'Grocery spend',
            )
            .having(
              (s) => s.pendingBillCreate?.notes,
              'pendingBillCreate.notes',
              '- Milk (2 cartons)\n- Eggs',
            ),
        isA<ShoppingListState>()
            .having(
              (s) => s.pendingBillCreate?.notes,
              'pendingBillCreate.notes',
              '- Milk (2 cartons)\n- Eggs',
            ),
      ],
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'clears pending quick bill create when consumed',
      build: () => buildBloc(),
      seed: () => ShoppingListState.loaded(
        pendingItems: const [],
        completedItems: const [],
        photoUrlsByItemId: const {},
        myCompletedCount: 0,
        pendingBillCreate: const PendingShoppingBillCreate(
          description: 'Shopping spend',
          notes: '- Milk',
          itemIds: ['item-1'],
        ),
        pendingBillCreateTick: 1,
      ),
      act: (bloc) => bloc.add(const ConsumePendingBillCreateEvent()),
      expect: () => [
        isA<ShoppingListState>()
            .having((s) => s.pendingBillCreate, 'pendingBillCreate', isNull)
            .having((s) => s.pendingBillCreateTick, 'pendingBillCreateTick', 1),
      ],
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'toggle all marks every pending item as completed and reloads',
      build: () {
        when(
          () => shoppingListRepository.getForHome(homeId: homeId),
        ).thenAnswer(
          (_) async => ShoppingListSnapshot(
            listId: 'list-1',
            itemsUnarchivedCount: 2,
            itemsUncompletedCount: 0,
            items: [
              item(
                id: 'a',
                isCompleted: true,
                completedByUserId: currentUserId,
                updatedAt: DateTime(2026, 2, 1, 11),
              ),
              item(
                id: 'b',
                isCompleted: true,
                completedByUserId: currentUserId,
                updatedAt: DateTime(2026, 2, 1, 11),
              ),
            ],
          ),
        );
        return buildBloc();
      },
      seed: () => ShoppingListState.loaded(
        pendingItems: [
          item(id: 'a', isCompleted: false, updatedAt: DateTime(2026, 2, 1, 10)),
          item(id: 'b', isCompleted: false, updatedAt: DateTime(2026, 2, 1, 10)),
        ],
        completedItems: const [],
        photoUrlsByItemId: const {},
        myCompletedCount: 0,
      ),
      act: (bloc) =>
          bloc.add(const ToggleAllShoppingItemsEvent(isCompleted: true)),
      expect: () => [
        isA<ShoppingListState>()
            .having((s) => s.pendingItems, 'pendingItems', isEmpty)
            .having((s) => s.completedItems.length, 'completedItems.length', 2),
      ],
      verify: (_) {
        verify(
          () => shoppingListRepository.updateItem(
            itemId: 'a',
            isCompleted: true,
          ),
        ).called(1);
        verify(
          () => shoppingListRepository.updateItem(
            itemId: 'b',
            isCompleted: true,
          ),
        ).called(1);
      },
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'toggle all uncompletes every completed item and reloads',
      build: () {
        when(
          () => shoppingListRepository.getForHome(homeId: homeId),
        ).thenAnswer(
          (_) async => ShoppingListSnapshot(
            listId: 'list-1',
            itemsUnarchivedCount: 2,
            itemsUncompletedCount: 2,
            items: [
              item(id: 'a', isCompleted: false, updatedAt: DateTime(2026, 2, 1, 11)),
              item(id: 'b', isCompleted: false, updatedAt: DateTime(2026, 2, 1, 11)),
            ],
          ),
        );
        return buildBloc();
      },
      seed: () => ShoppingListState.loaded(
        pendingItems: const [],
        completedItems: [
          item(
            id: 'a',
            isCompleted: true,
            completedByUserId: currentUserId,
            updatedAt: DateTime(2026, 2, 1, 10),
          ),
          item(
            id: 'b',
            isCompleted: true,
            completedByUserId: currentUserId,
            updatedAt: DateTime(2026, 2, 1, 10),
          ),
        ],
        photoUrlsByItemId: const {},
        myCompletedCount: 2,
      ),
      act: (bloc) =>
          bloc.add(const ToggleAllShoppingItemsEvent(isCompleted: false)),
      expect: () => [
        isA<ShoppingListState>()
            .having((s) => s.pendingItems.length, 'pendingItems.length', 2)
            .having((s) => s.completedItems, 'completedItems', isEmpty),
      ],
      verify: (_) {
        verify(
          () => shoppingListRepository.updateItem(
            itemId: 'a',
            isCompleted: false,
          ),
        ).called(1);
        verify(
          () => shoppingListRepository.updateItem(
            itemId: 'b',
            isCompleted: false,
          ),
        ).called(1);
      },
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'toggle all emits sentinel message when item completed by other',
      build: () {
        final error = Exception('completed by other');
        when(
          () => shoppingListRepository.updateItem(
            itemId: any(named: 'itemId'),
            isCompleted: any(named: 'isCompleted'),
          ),
        ).thenThrow(error);
        when(
          () => shoppingListRepository.isItemCompletedByOtherError(error),
        ).thenReturn(true);
        return buildBloc();
      },
      seed: () => ShoppingListState.loaded(
        pendingItems: [
          item(id: 'a', isCompleted: false, updatedAt: DateTime(2026, 2, 1, 10)),
        ],
        completedItems: const [],
        photoUrlsByItemId: const {},
        myCompletedCount: 0,
      ),
      act: (bloc) =>
          bloc.add(const ToggleAllShoppingItemsEvent(isCompleted: true)),
      expect: () => [
        isA<ShoppingListState>()
            .having((s) => s.isLoading, 'isLoading', false),
        isA<ShoppingListState>()
            .having((s) => s.message, 'message', shoppingErrorItemCompletedByOther)
            .having((s) => s.messageTick, 'messageTick', 1),
      ],
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'toggle emits sentinel message and reloads list when item completed by other',
      build: () {
        final error = Exception('completed by other');
        when(
          () => shoppingListRepository.updateItem(
            itemId: any(named: 'itemId'),
            isCompleted: any(named: 'isCompleted'),
          ),
        ).thenThrow(error);
        when(
          () => shoppingListRepository.isItemCompletedByOtherError(error),
        ).thenReturn(true);
        return buildBloc();
      },
      seed: () => ShoppingListState.loaded(
        pendingItems: [
          item(
            id: 'item-1',
            isCompleted: false,
            updatedAt: DateTime(2026, 2, 1, 10),
          ),
        ],
        completedItems: const [],
        photoUrlsByItemId: const {},
        myCompletedCount: 0,
      ),
      act: (bloc) => bloc.add(
        const ToggleShoppingItemEvent(itemId: 'item-1', isCompleted: true),
      ),
      expect: () => [
        isA<ShoppingListState>()
            .having((s) => s.isLoading, 'isLoading', false),
        isA<ShoppingListState>()
            .having((s) => s.message, 'message', shoppingErrorItemCompletedByOther)
            .having((s) => s.messageTick, 'messageTick', 1),
      ],
      verify: (_) {
        verify(
          () => shoppingListRepository.getForHome(homeId: homeId),
        ).called(1);
      },
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'toggle emits generic message for non-completed-by-other errors',
      build: () {
        when(
          () => shoppingListRepository.updateItem(
            itemId: any(named: 'itemId'),
            isCompleted: any(named: 'isCompleted'),
          ),
        ).thenThrow(Exception('network error'));
        return buildBloc();
      },
      seed: () => ShoppingListState.loaded(
        pendingItems: [
          item(
            id: 'item-1',
            isCompleted: false,
            updatedAt: DateTime(2026, 2, 1, 10),
          ),
        ],
        completedItems: const [],
        photoUrlsByItemId: const {},
        myCompletedCount: 0,
      ),
      act: (bloc) => bloc.add(
        const ToggleShoppingItemEvent(itemId: 'item-1', isCompleted: true),
      ),
      expect: () => [
        isA<ShoppingListState>()
            .having((s) => s.messageTick, 'messageTick', 1)
            .having((s) => s.message, 'message', contains('network error')),
      ],
    );
  });
}
