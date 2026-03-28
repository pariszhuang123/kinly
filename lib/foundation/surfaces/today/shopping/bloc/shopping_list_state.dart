part of 'shopping_list_bloc.dart';

class ShoppingListState extends Equatable {
  const ShoppingListState._({
    required this.isLoading,
    required this.pendingItems,
    required this.completedItems,
    required this.photoUrlsByItemId,
    required this.myCompletedCount,
    this.errorMessage,
    this.message,
    this.messageTick = 0,
    this.linkedExpenseId,
    this.linkedExpenseTick = 0,
    this.pendingBillCreate,
    this.pendingBillCreateTick = 0,
    this.archivedTick = 0,
  });

  const ShoppingListState.loading()
    : this._(
        isLoading: true,
        pendingItems: const [],
        completedItems: const [],
        photoUrlsByItemId: const {},
        myCompletedCount: 0,
      );

  const ShoppingListState.loaded({
    required List<ShoppingListItem> pendingItems,
    required List<ShoppingListItem> completedItems,
    required Map<String, String> photoUrlsByItemId,
    required int myCompletedCount,
    String? message,
    int messageTick = 0,
    String? linkedExpenseId,
    int linkedExpenseTick = 0,
    PendingShoppingBillCreate? pendingBillCreate,
    int pendingBillCreateTick = 0,
    int archivedTick = 0,
  }) : this._(
         isLoading: false,
         pendingItems: pendingItems,
         completedItems: completedItems,
         photoUrlsByItemId: photoUrlsByItemId,
         myCompletedCount: myCompletedCount,
         message: message,
         messageTick: messageTick,
         linkedExpenseId: linkedExpenseId,
         linkedExpenseTick: linkedExpenseTick,
         pendingBillCreate: pendingBillCreate,
         pendingBillCreateTick: pendingBillCreateTick,
         archivedTick: archivedTick,
         );

  const ShoppingListState.failure({required String errorMessage})
    : this._(
        isLoading: false,
        pendingItems: const [],
        completedItems: const [],
        photoUrlsByItemId: const {},
        myCompletedCount: 0,
        errorMessage: errorMessage,
      );

  final bool isLoading;
  final List<ShoppingListItem> pendingItems;
  final List<ShoppingListItem> completedItems;
  final Map<String, String> photoUrlsByItemId;
  final int myCompletedCount;
  final String? errorMessage;
  final String? message;
  final int messageTick;
  final String? linkedExpenseId;
  final int linkedExpenseTick;
  final PendingShoppingBillCreate? pendingBillCreate;
  final int pendingBillCreateTick;
  final int archivedTick;

  ShoppingListState copyWith({
    String? message,
    int? messageTick,
    String? linkedExpenseId,
    int? linkedExpenseTick,
    PendingShoppingBillCreate? pendingBillCreate,
    bool clearPendingBillCreate = false,
    int? pendingBillCreateTick,
    int? archivedTick,
  }) {
    return ShoppingListState._(
      isLoading: isLoading,
      pendingItems: pendingItems,
      completedItems: completedItems,
      photoUrlsByItemId: photoUrlsByItemId,
      myCompletedCount: myCompletedCount,
      errorMessage: errorMessage,
      message: message ?? this.message,
      messageTick: messageTick ?? this.messageTick,
      linkedExpenseId: linkedExpenseId ?? this.linkedExpenseId,
      linkedExpenseTick: linkedExpenseTick ?? this.linkedExpenseTick,
      pendingBillCreate:
          clearPendingBillCreate
              ? null
              : pendingBillCreate ?? this.pendingBillCreate,
      pendingBillCreateTick:
          pendingBillCreateTick ?? this.pendingBillCreateTick,
      archivedTick: archivedTick ?? this.archivedTick,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    pendingItems,
    completedItems,
    photoUrlsByItemId,
    myCompletedCount,
    errorMessage,
    message,
    messageTick,
    linkedExpenseId,
    linkedExpenseTick,
    pendingBillCreate,
    pendingBillCreateTick,
    archivedTick,
  ];
}

class PendingShoppingBillCreate extends Equatable {
  const PendingShoppingBillCreate({
    required this.description,
    required this.notes,
    required this.itemIds,
  });

  final String description;
  final String? notes;
  final List<String> itemIds;

  @override
  List<Object?> get props => [description, notes, itemIds];
}
