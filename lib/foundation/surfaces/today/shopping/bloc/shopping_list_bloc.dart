import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
part 'shopping_list_event.dart';
part 'shopping_list_state.dart';

const shoppingErrorItemCompletedByOther = 'ITEM_ALREADY_COMPLETED_BY_OTHER';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppingListBloc({
    required String homeId,
    required String? currentUserId,
    required ShoppingListRepository shoppingListRepository,
    required ExpensesRepository expensesRepository,
  }) : _homeId = homeId,
       _currentUserId = currentUserId,
       _shoppingListRepository = shoppingListRepository,
       _expensesRepository = expensesRepository,
       super(const ShoppingListState.loading()) {
    on<LoadShoppingListEvent>(_onLoadShoppingList);
    on<ToggleShoppingItemEvent>(_onToggleShoppingItem);
    on<ArchiveMyCompletedShoppingItemsEvent>(_onArchiveMyCompletedShoppingItems);
  }

  final String _homeId;
  final String? _currentUserId;
  final ShoppingListRepository _shoppingListRepository;
  final ExpensesRepository _expensesRepository;

  static bool _hasText(String? value) => (value ?? '').trim().isNotEmpty;

  Future<void> _onLoadShoppingList(
    LoadShoppingListEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    await _load(emit, keepCurrent: event.keepCurrent);
  }

  Future<void> _onToggleShoppingItem(
    ToggleShoppingItemEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    try {
      await _shoppingListRepository.updateItem(
        itemId: event.itemId,
        isCompleted: event.isCompleted,
      );
      await _load(emit, keepCurrent: true);
    } catch (error) {
      if (_shoppingListRepository.isItemCompletedByOtherError(error)) {
        await _load(emit, keepCurrent: true);
        emit(
          state.copyWith(
            message: shoppingErrorItemCompletedByOther,
            messageTick: state.messageTick + 1,
          ),
        );
        return;
      }
      emit(state.copyWith(message: error.toString(), messageTick: state.messageTick + 1));
    }
  }

  Future<void> _onArchiveMyCompletedShoppingItems(
    ArchiveMyCompletedShoppingItemsEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    try {
      final currentUserId = _currentUserId;
      if (currentUserId == null || currentUserId.isEmpty) {
        emit(
          state.copyWith(
            message: 'No completed items to clear',
            messageTick: state.messageTick + 1,
          ),
        );
        return;
      }

      final mine = state.completedItems
          .where((item) => item.completedByUserId == currentUserId)
          .toList(growable: false);
      if (mine.isEmpty) {
        emit(
          state.copyWith(
            message: 'No completed items to clear',
            messageTick: state.messageTick + 1,
          ),
        );
        return;
      }

      if (event.triggerShareSpend) {
        final seed = await _shoppingListRepository.prepareExpenseForUser(
          homeId: _homeId,
        );
        if (seed == null || seed.itemIds.isEmpty) {
          emit(
            state.copyWith(
              message: 'No completed items to clear',
              messageTick: state.messageTick + 1,
            ),
          );
          return;
        }

        final draft = await _expensesRepository.create(
          homeId: _homeId,
          description: seed.defaultDescription.isEmpty
              ? 'Shopping spend'
              : seed.defaultDescription,
          notes: _buildShoppingExpenseNotes(seed: seed, items: mine),
          startDate: DateTime.now(),
        );
        await _shoppingListRepository.linkItemsToExpenseForUser(
          homeId: _homeId,
          expenseId: draft.id,
          itemIds: seed.itemIds,
        );
        emit(
          state.copyWith(
            linkedExpenseId: draft.id,
            linkedExpenseTick: state.linkedExpenseTick + 1,
          ),
        );
      } else {
        await _shoppingListRepository.archiveItemsForUser(
          homeId: _homeId,
          itemIds: mine.map((item) => item.id).toList(growable: false),
        );
      }

      await _load(emit, keepCurrent: true);
    } catch (error) {
      emit(state.copyWith(message: error.toString(), messageTick: state.messageTick + 1));
    }
  }

  Future<void> _load(Emitter<ShoppingListState> emit, {required bool keepCurrent}) async {
    if (!keepCurrent) {
      emit(const ShoppingListState.loading());
    }
    try {
      final snapshot = await _shoppingListRepository.getForHome(homeId: _homeId);
      final items = snapshot.items.where((item) => item.archivedAt == null).toList(
        growable: false,
      );
      final pending = items.where((item) => !item.isCompleted).toList(growable: false)
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      final completed = items.where((item) => item.isCompleted).toList(growable: false)
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      final photoUrlsByItemId = <String, String>{
        for (final item in items)
          item.id: _shoppingListRepository.toPublicPhotoUrl(item.referencePhotoPath) ?? '',
      };
      emit(
        ShoppingListState.loaded(
          pendingItems: pending,
          completedItems: completed,
          photoUrlsByItemId: photoUrlsByItemId,
          myCompletedCount: completed
              .where((item) => item.completedByUserId == _currentUserId)
              .length,
          linkedExpenseId: state.linkedExpenseId,
          linkedExpenseTick: state.linkedExpenseTick,
          message: state.message,
          messageTick: state.messageTick,
        ),
      );
    } catch (error) {
      emit(ShoppingListState.failure(errorMessage: error.toString()));
    }
  }

  String? _buildShoppingExpenseNotes({
    required ShoppingExpenseDraftSeed seed,
    required List<ShoppingListItem> items,
  }) {
    final byId = <String, ShoppingListItem>{for (final item in items) item.id: item};
    final itemLines = <String>[];
    for (final itemId in seed.itemIds) {
      final item = byId[itemId];
      if (item == null) continue;
      final name = item.name.trim();
      if (name.isEmpty) continue;
      final quantity = item.quantity?.trim() ?? '';
      itemLines.add(_hasText(quantity) ? '- $name ($quantity)' : '- $name');
    }

    final seededBulletLines = seed.defaultNotes
        .split('\n')
        .map((line) => line.trim())
        .where(_hasText)
        .where((line) => line.startsWith('-'))
        .toList(growable: false);
    final combined = <String>[...seededBulletLines, ...itemLines];
    if (combined.isEmpty) return null;
    return combined.join('\n');
  }
}
