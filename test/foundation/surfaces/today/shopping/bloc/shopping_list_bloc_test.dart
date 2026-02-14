import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/foundation/surfaces/today/shopping/bloc/shopping_list_bloc.dart';

class _MockShoppingListRepository extends Mock implements ShoppingListRepository {}

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  late _MockShoppingListRepository shoppingListRepository;
  late _MockExpensesRepository expensesRepository;

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
      expensesRepository: expensesRepository,
    );
  }

  setUpAll(() {
    registerFallbackValue(DateTime(2026, 2, 1));
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    shoppingListRepository = _MockShoppingListRepository();
    expensesRepository = _MockExpensesRepository();

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
    when(
      () => expensesRepository.create(
        homeId: any(named: 'homeId'),
        amountCents: any(named: 'amountCents'),
        description: any(named: 'description'),
        notes: any(named: 'notes'),
        splitType: any(named: 'splitType'),
        memberIds: any(named: 'memberIds'),
        customSplits: any(named: 'customSplits'),
        recurrenceEvery: any(named: 'recurrenceEvery'),
        recurrenceUnit: any(named: 'recurrenceUnit'),
        startDate: any(named: 'startDate'),
      ),
    ).thenAnswer(
      (_) async => Expense(
        id: 'expense-1',
        homeId: homeId,
        createdByUserId: currentUserId,
        status: ExpenseStatus.draft,
        splitType: null,
        amountCents: 0,
        description: 'Shopping spend',
        notes: null,
        createdAt: DateTime(2026, 2, 1, 10),
        updatedAt: DateTime(2026, 2, 1, 10),
        recurrenceEvery: null,
        recurrenceUnit: null,
        startDate: DateTime(2026, 2, 1),
      ),
    );
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
      'creates expense + links items when share handoff is enabled',
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
      verify: (_) {
        verify(
          () => expensesRepository.create(
            homeId: homeId,
            description: 'Shopping spend',
            notes: '- item-mine-1',
            startDate: any(named: 'startDate'),
          ),
        ).called(1);
        verify(
          () => shoppingListRepository.linkItemsToExpenseForUser(
            homeId: homeId,
            expenseId: 'expense-1',
            itemIds: ['mine-1', 'mine-2'],
          ),
        ).called(1);
      },
      expect: () => [
        isA<ShoppingListState>()
            .having((s) => s.linkedExpenseId, 'linkedExpenseId', 'expense-1')
            .having((s) => s.linkedExpenseTick, 'linkedExpenseTick', 1),
        isA<ShoppingListState>()
            .having((s) => s.linkedExpenseId, 'linkedExpenseId', 'expense-1')
            .having((s) => s.linkedExpenseTick, 'linkedExpenseTick', 1),
      ],
    );

    blocTest<ShoppingListBloc, ShoppingListState>(
      'formats share draft notes with quantity per item and skips empty quantity brackets',
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
      verify: (_) {
        verify(
          () => expensesRepository.create(
            homeId: homeId,
            description: 'Grocery spend',
            notes: '- Milk (2 cartons)\n- Eggs',
            startDate: any(named: 'startDate'),
          ),
        ).called(1);
      },
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
