part of 'shopping_list_bloc.dart';

abstract class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();

  @override
  List<Object?> get props => [];
}

class LoadShoppingListEvent extends ShoppingListEvent {
  const LoadShoppingListEvent({this.keepCurrent = false});

  final bool keepCurrent;

  @override
  List<Object?> get props => [keepCurrent];
}

class ToggleShoppingItemEvent extends ShoppingListEvent {
  const ToggleShoppingItemEvent({
    required this.itemId,
    required this.isCompleted,
  });

  final String itemId;
  final bool isCompleted;

  @override
  List<Object?> get props => [itemId, isCompleted];
}

class ToggleAllShoppingItemsEvent extends ShoppingListEvent {
  const ToggleAllShoppingItemsEvent({required this.isCompleted});

  final bool isCompleted;

  @override
  List<Object?> get props => [isCompleted];
}

class ArchiveMyCompletedShoppingItemsEvent extends ShoppingListEvent {
  const ArchiveMyCompletedShoppingItemsEvent({required this.triggerShareSpend});

  final bool triggerShareSpend;

  @override
  List<Object?> get props => [triggerShareSpend];
}
