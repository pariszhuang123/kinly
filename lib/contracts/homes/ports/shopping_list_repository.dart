import '../shopping_models.dart';

abstract class ShoppingListRepository {
  Future<ShoppingListSnapshot> getForHome({required String homeId});

  Future<ShoppingListItem> addItem({
    required String homeId,
    required String name,
    String? quantity,
    String? details,
    String? referencePhotoPath,
  });

  Future<ShoppingListItem> updateItem({
    required String itemId,
    String? name,
    String? quantity,
    String? details,
    bool? isCompleted,
    String? referencePhotoPath,
    bool replacePhoto = false,
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

  Future<String?> captureAndUploadPhoto({required String homeId});

  String? toPublicPhotoUrl(String? storagePath);

  bool isPhotoLimitError(Object error);
}
