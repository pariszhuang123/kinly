import 'package:equatable/equatable.dart';

import '../time/timezone.dart';

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
