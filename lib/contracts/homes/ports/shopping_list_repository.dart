import '../shopping_models.dart';

abstract class ShoppingListRepository {
  Future<ShoppingListSnapshot> getForHome({
    required String homeId,
    ShoppingItemScopeType? scopeType,
    String? unitId,
  });

  Future<ShoppingListAddItemResult> addItem({
    required String homeId,
    required String name,
    String? quantity,
    String? details,
    String? referencePhotoPath,
    ShoppingItemScopeType scopeType = ShoppingItemScopeType.house,
    String? unitId,
  });

  Future<ShoppingListItem> updateItem({
    required String itemId,
    String? name,
    String? quantity,
    String? details,
    bool? isCompleted,
    String? referencePhotoPath,
    bool replacePhoto = false,
    ShoppingItemScopeType? scopeType,
    String? unitId,
  });

  Future<ShoppingExpenseDraftSeed?> prepareExpenseForUser({
    required String homeId,
  });

  Future<int> linkItemsToExpenseForUser({
    required String homeId,
    required String expenseId,
    required List<String> itemIds,
  });

  Future<int> archiveItemsForUser({
    required String homeId,
    required List<String> itemIds,
  });

  Future<ShoppingListItem> archiveItem({required String itemId});

  Future<String?> captureAndUploadPhoto({required String homeId});

  Future<String?> recoverPendingPhotoUpload({required String homeId});

  String? toPublicPhotoUrl(String? storagePath);

  bool isPhotoLimitError(Object error);

  bool isItemCompletedByOtherError(Object error);
}
