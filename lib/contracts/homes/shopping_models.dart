import 'package:equatable/equatable.dart';

import '../time/timezone.dart';

enum ShoppingItemScopeType {
  house('house'),
  unit('unit');

  const ShoppingItemScopeType(this.wireValue);

  final String wireValue;

  static ShoppingItemScopeType fromWire(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'unit':
        return ShoppingItemScopeType.unit;
      case 'house':
      default:
        return ShoppingItemScopeType.house;
    }
  }
}

class ShoppingListPurchaseMemoryReminder extends Equatable {
  const ShoppingListPurchaseMemoryReminder({
    required this.lastPurchasedAt,
    required this.lastPurchasedByDisplayName,
    required this.daysSinceLastPurchase,
    required this.warningWindowDays,
  });

  final DateTime lastPurchasedAt;
  final String? lastPurchasedByDisplayName;
  final int daysSinceLastPurchase;
  final int warningWindowDays;

  factory ShoppingListPurchaseMemoryReminder.fromJson(
    Map<String, dynamic> json,
  ) {
    return ShoppingListPurchaseMemoryReminder(
      lastPurchasedAt:
          parseTimestampToLocal(
            json['last_purchased_at'] ?? json['lastPurchasedAt'],
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      lastPurchasedByDisplayName:
          json['last_purchased_by_display_name'] as String? ??
          json['lastPurchasedByDisplayName'] as String?,
      daysSinceLastPurchase:
          (json['days_since_last_purchase'] as num?)?.toInt() ??
          (json['daysSinceLastPurchase'] as num?)?.toInt() ??
          0,
      warningWindowDays:
          (json['warning_window_days'] as num?)?.toInt() ??
          (json['warningWindowDays'] as num?)?.toInt() ??
          0,
    );
  }

  @override
  List<Object?> get props => [
    lastPurchasedAt,
    lastPurchasedByDisplayName,
    daysSinceLastPurchase,
    warningWindowDays,
  ];
}

class ShoppingListAddItemResult extends Equatable {
  const ShoppingListAddItemResult({
    required this.item,
    required this.purchaseMemory,
  });

  final ShoppingListItem item;
  final ShoppingListPurchaseMemoryReminder? purchaseMemory;

  factory ShoppingListAddItemResult.fromJson(Map<String, dynamic> json) {
    final itemPayload =
        (json['item'] as Map?)?.cast<String, dynamic>() ?? json;
    final purchaseMemoryPayload =
        (json['purchase_memory'] as Map?)?.cast<String, dynamic>() ??
        (json['purchaseMemory'] as Map?)?.cast<String, dynamic>();
    return ShoppingListAddItemResult(
      item: ShoppingListItem.fromJson(itemPayload),
      purchaseMemory:
          purchaseMemoryPayload == null
              ? null
              : ShoppingListPurchaseMemoryReminder.fromJson(
                purchaseMemoryPayload,
              ),
    );
  }

  @override
  List<Object?> get props => [item, purchaseMemory];
}

class ShoppingListItem extends Equatable {
  const ShoppingListItem({
    required this.id,
    required this.homeId,
    required this.name,
    this.quantity,
    this.details,
    this.referencePhotoPath,
    required this.isCompleted,
    this.completedByUserId,
    this.completedByAvatarId,
    this.completedAt,
    required this.scopeType,
    this.unitId,
    this.unitName,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String homeId;
  final String name;
  final String? quantity;
  final String? details;
  final String? referencePhotoPath;
  final bool isCompleted;
  final String? completedByUserId;
  final String? completedByAvatarId;
  final DateTime? completedAt;
  final ShoppingItemScopeType scopeType;
  final String? unitId;
  final String? unitName;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'] as String? ?? '',
      homeId: json['home_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as String?,
      details: json['details'] as String?,
      referencePhotoPath: json['reference_photo_path'] as String?,
      isCompleted: (json['is_completed'] as bool?) ?? false,
      completedByUserId: json['completed_by_user_id'] as String?,
      completedByAvatarId: json['completed_by_avatar_id'] as String?,
      completedAt: parseTimestampToLocal(json['completed_at']),
      scopeType: ShoppingItemScopeType.fromWire(
        json['scope_type'] as String? ?? json['scopeType'] as String?,
      ),
      unitId: json['unit_id'] as String? ?? json['unitId'] as String?,
      unitName: json['unit_name'] as String? ?? json['unitName'] as String?,
      archivedAt: parseTimestampToLocal(json['archived_at']),
      createdAt:
          parseTimestampToLocal(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      updatedAt:
          parseTimestampToLocal(json['updated_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    homeId,
    name,
    quantity,
    details,
    referencePhotoPath,
    isCompleted,
    completedByUserId,
    completedByAvatarId,
    completedAt,
    scopeType,
    unitId,
    unitName,
    archivedAt,
    createdAt,
    updatedAt,
  ];
}

class ShoppingListSnapshot extends Equatable {
  const ShoppingListSnapshot({
    required this.listId,
    required this.itemsUnarchivedCount,
    required this.itemsUncompletedCount,
    required this.items,
  });

  final String? listId;
  final int itemsUnarchivedCount;
  final int itemsUncompletedCount;
  final List<ShoppingListItem> items;

  factory ShoppingListSnapshot.fromJson(Map<String, dynamic> json) {
    final list =
        (json['list'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final rows = (json['items'] as List?) ?? const <dynamic>[];
    return ShoppingListSnapshot(
      listId: list['id'] as String?,
      itemsUnarchivedCount: (list['items_unarchived_count'] as num?)?.toInt() ?? 0,
      itemsUncompletedCount:
          (list['items_uncompleted_count'] as num?)?.toInt() ?? 0,
      items: rows
          .whereType<Map>()
          .map((row) => ShoppingListItem.fromJson(row.cast<String, dynamic>()))
          .toList(growable: false),
    );
  }

  @override
  List<Object?> get props => [
    listId,
    itemsUnarchivedCount,
    itemsUncompletedCount,
    items,
  ];
}

class ShoppingExpenseDraftSeed extends Equatable {
  const ShoppingExpenseDraftSeed({
    required this.defaultDescription,
    required this.defaultNotes,
    required this.itemIds,
    required this.itemCount,
  });

  final String defaultDescription;
  final String defaultNotes;
  final List<String> itemIds;
  final int itemCount;

  factory ShoppingExpenseDraftSeed.fromJson(Map<String, dynamic> json) {
    final rawIds = (json['item_ids'] as List?) ?? const <dynamic>[];
    return ShoppingExpenseDraftSeed(
      defaultDescription: json['default_description'] as String? ?? '',
      defaultNotes: json['default_notes'] as String? ?? '',
      itemIds: rawIds.map((id) => id.toString()).toList(growable: false),
      itemCount: (json['item_count'] as num?)?.toInt() ?? rawIds.length,
    );
  }

  @override
  List<Object?> get props => [defaultDescription, defaultNotes, itemIds, itemCount];
}
