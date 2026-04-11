import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/contracts/homes/shopping_photo_capture.dart';
import 'package:kinly/core/media/expectation_photo_service.dart';
import 'package:kinly/core/media/supabase_media_repository.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/supabase/storage_path_resolver.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseShoppingListRepository implements ShoppingListRepository {
  SupabaseShoppingListRepository({SupabaseClient? client, Logger? logger})
    : _client = client ?? Supabase.instance.client,
      _logger = logger ?? const DebugLogger(),
      _photoService = ExpectationPhotoService(
        mediaRepository: SupabaseMediaRepository(),
      );

  final SupabaseClient _client;
  final Logger _logger;
  final ExpectationPhotoService _photoService;

  @override
  Future<ShoppingListSnapshot> getForHome({
    required String homeId,
    ShoppingItemScopeType? scopeType,
    String? unitId,
  }) async {
    try {
      final response = await _client.rpc(
        'shopping_list_get_for_home_v2',
        params: {
          'p_home_id': homeId,
          if (scopeType != null) 'p_scope_type': scopeType.wireValue,
          if (_hasText(unitId)) 'p_unit_id': unitId!.trim(),
        },
      );
      final payload = _coerceMap(response);
      if (payload == null) {
        throw const ShoppingListException(
          ShoppingListErrorCode.unknown,
          'Malformed shopping list payload.',
        );
      }
      return ShoppingListSnapshot.fromJson(payload);
    } catch (error) {
      throw SupabaseErrorMapper.mapShoppingList(error);
    }
  }

  @override
  Future<ShoppingListAddItemResult> addItem({
    required String homeId,
    required String name,
    String? quantity,
    String? details,
    String? referencePhotoPath,
    ShoppingItemScopeType scopeType = ShoppingItemScopeType.house,
    String? unitId,
  }) async {
    try {
      final response = await _client.rpc(
        'shopping_list_add_item_v2',
        params: {
          'p_home_id': homeId,
          'p_name': name,
          if (_hasText(quantity)) 'p_quantity': quantity!.trim(),
          if (_hasText(details)) 'p_details': details!.trim(),
          if (_hasText(referencePhotoPath))
            'p_reference_photo_path': referencePhotoPath!.trim(),
          'p_scope_type': scopeType.wireValue,
          if (_hasText(unitId)) 'p_unit_id': unitId!.trim(),
        },
      );
      final payload = _coerceMap(response);
      if (payload == null) {
        throw const ShoppingListException(
          ShoppingListErrorCode.unknown,
          'Malformed add-item payload.',
        );
      }
      return ShoppingListAddItemResult.fromJson(payload);
    } catch (error) {
      throw SupabaseErrorMapper.mapShoppingList(error);
    }
  }

  @override
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
  }) async {
    try {
      final response = await _client.rpc(
        'shopping_list_update_item_v2',
        params: {
          'p_item_id': itemId,
          if (_hasText(name)) 'p_name': name!.trim(),
          if (_hasText(quantity)) 'p_quantity': quantity!.trim(),
          if (_hasText(details)) 'p_details': details!.trim(),
          if (isCompleted != null) 'p_is_completed': isCompleted,
          if (_hasText(referencePhotoPath))
            'p_reference_photo_path': referencePhotoPath!.trim(),
          if (scopeType != null) 'p_scope_type': scopeType.wireValue,
          if (_hasText(unitId)) 'p_unit_id': unitId!.trim(),
          'p_replace_photo': replacePhoto,
        },
      );
      final payload = _extractItemPayload(response);
      if (payload == null) {
        throw const ShoppingListException(
          ShoppingListErrorCode.unknown,
          'Malformed update-item payload.',
        );
      }
      return ShoppingListItem.fromJson(payload);
    } catch (error) {
      throw SupabaseErrorMapper.mapShoppingList(error);
    }
  }

  @override
  Future<ShoppingExpenseDraftSeed?> prepareExpenseForUser({
    required String homeId,
  }) async {
    try {
      final response = await _client.rpc(
        'shopping_list_prepare_expense_for_user',
        params: {'p_home_id': homeId},
      );
      if (response == null) return null;
      if (response is List) {
        if (response.isEmpty) return null;
        final first = response.first;
        if (first is! Map) return null;
        return ShoppingExpenseDraftSeed.fromJson(first.cast<String, dynamic>());
      }
      final payload = _coerceMap(response);
      if (payload == null || payload.isEmpty) return null;
      return ShoppingExpenseDraftSeed.fromJson(payload);
    } catch (error) {
      throw SupabaseErrorMapper.mapShoppingList(error);
    }
  }

  @override
  Future<int> linkItemsToExpenseForUser({
    required String homeId,
    required String expenseId,
    required List<String> itemIds,
  }) async {
    try {
      final response = await _client.rpc(
        'shopping_list_link_items_to_expense_for_user',
        params: {
          'p_home_id': homeId,
          'p_expense_id': expenseId,
          'p_item_ids': itemIds,
        },
      );
      final payload = _coerceMap(response);
      return (payload?['updated_count'] as num?)?.toInt() ??
          (payload?['updated'] as num?)?.toInt() ??
          0;
    } catch (error) {
      throw SupabaseErrorMapper.mapShoppingList(error);
    }
  }

  @override
  Future<int> archiveItemsForUser({
    required String homeId,
    required List<String> itemIds,
  }) async {
    try {
      final response = await _client.rpc(
        'shopping_list_archive_items_for_user',
        params: {'p_home_id': homeId, 'p_item_ids': itemIds},
      );
      final payload = _coerceMap(response);
      return (payload?['updated_count'] as num?)?.toInt() ??
          (payload?['updated'] as num?)?.toInt() ??
          0;
    } catch (error) {
      throw SupabaseErrorMapper.mapShoppingList(error);
    }
  }

  @override
  Future<ShoppingListItem> archiveItem({required String itemId}) async {
    try {
      final response = await _client.rpc(
        'shopping_list_archive_item',
        params: {'p_item_id': itemId},
      );
      final payload = _extractItemPayload(response);
      if (payload == null) {
        throw const ShoppingListException(
          ShoppingListErrorCode.unknown,
          'Malformed archive-item payload.',
        );
      }
      return ShoppingListItem.fromJson(payload);
    } catch (error) {
      throw SupabaseErrorMapper.mapShoppingList(error);
    }
  }

  @override
  Future<String?> captureAndUploadPhoto({required String homeId}) async {
    _logger.info(
      'Repository photo upload started. homeId=$homeId',
      tag: 'ShoppingPhoto',
    );
    try {
      final upload = await _photoService.captureAndUpload(
        homeId: homeId,
        rootSegment: 'shopping',
        featureSegment: 'item',
      );
      _logger.info(
        'Repository photo upload succeeded. homeId=$homeId '
        'storagePath=${upload.storagePath}',
        tag: 'ShoppingPhoto',
      );
      return _withHouseholdsPrefix(upload.storagePath);
    } on CameraPermissionException catch (error) {
      _logger.warn(
        'Repository photo upload permission denied. homeId=$homeId '
        'permanentlyDenied=${error.permanentlyDenied}',
        tag: 'ShoppingPhoto',
        error: error,
      );
      throw ShoppingPhotoCaptureException(
        kind: ShoppingPhotoCaptureErrorKind.permission,
        message: 'permission',
        permanentlyDenied: error.permanentlyDenied,
      );
    } on CameraCaptureCancelled {
      _logger.info(
        'Repository photo upload cancelled by user. homeId=$homeId',
        tag: 'ShoppingPhoto',
      );
      return null;
    } catch (error) {
      _logger.error(
        'Repository photo upload failed. homeId=$homeId',
        tag: 'ShoppingPhoto',
        error: error,
      );
      throw ShoppingPhotoCaptureException(
        kind: ShoppingPhotoCaptureErrorKind.upload,
        message: error.toString(),
      );
    }
  }

  @override
  Future<String?> recoverPendingPhotoUpload({required String homeId}) async {
    _logger.info(
      'Repository pending photo recovery started. homeId=$homeId',
      tag: 'ShoppingPhoto',
    );
    try {
      final upload = await _photoService.recoverLostAndUploadIfPending(
        homeId: homeId,
        rootSegment: 'shopping',
        featureSegment: 'item',
      );
      if (upload == null) {
        _logger.info(
          'Repository pending photo recovery found nothing. homeId=$homeId',
          tag: 'ShoppingPhoto',
        );
        return null;
      }
      _logger.info(
        'Repository pending photo recovery succeeded. homeId=$homeId '
        'storagePath=${upload.storagePath}',
        tag: 'ShoppingPhoto',
      );
      return _withHouseholdsPrefix(upload.storagePath);
    } catch (error) {
      _logger.error(
        'Repository pending photo recovery failed. homeId=$homeId',
        tag: 'ShoppingPhoto',
        error: error,
      );
      throw ShoppingPhotoCaptureException(
        kind: ShoppingPhotoCaptureErrorKind.upload,
        message: error.toString(),
      );
    }
  }

  @override
  String? toPublicPhotoUrl(String? storagePath) {
    return storagePathToPublicUrl(_client, storagePath);
  }

  @override
  bool isPhotoLimitError(Object error) {
    return error is ShoppingListException &&
        error.code == ShoppingListErrorCode.paywallShoppingItemPhotosCap;
  }

  @override
  bool isItemCompletedByOtherError(Object error) {
    return error is ShoppingListException &&
        error.code == ShoppingListErrorCode.itemAlreadyCompletedByOther;
  }

  Map<String, dynamic>? _coerceMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return null;
  }

  Map<String, dynamic>? _extractItemPayload(dynamic value) {
    final map = _coerceMap(value);
    if (map == null) return null;
    final item = map['item'];
    if (item is Map<String, dynamic>) return item;
    if (item is Map) return item.cast<String, dynamic>();
    return map;
  }

  static bool _hasText(String? value) => (value ?? '').trim().isNotEmpty;

  static String _withHouseholdsPrefix(String path) {
    final trimmed = path.trim();
    if (trimmed.startsWith('households/')) return trimmed;
    return 'households/$trimmed';
  }
}
