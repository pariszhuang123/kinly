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

  ShoppingListState copyWith({
    String? message,
    int? messageTick,
    String? linkedExpenseId,
    int? linkedExpenseTick,
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
  ];
}
