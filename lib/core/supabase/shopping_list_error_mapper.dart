import 'package:supabase_flutter/supabase_flutter.dart';

import 'enums/shopping_list_error_code.dart';

class ShoppingListException implements Exception {
  final ShoppingListErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  const ShoppingListException(this.code, this.message, {this.details});

  @override
  String toString() => 'ShoppingListException($code): $message';
}

ShoppingListException mapShoppingListError(
  Object error, {
  required String Function(PostgrestException error) parseCode,
  required String Function(PostgrestException error) parseMessage,
  required Map<String, dynamic>? Function(PostgrestException error) parseDetails,
}) {
  if (error is AuthException) {
    return ShoppingListException(
      ShoppingListErrorCode.unauthorized,
      error.message,
    );
  }
  if (error is PostgrestException) {
    final code = parseCode(error);
    return ShoppingListException(
      _shoppingListCodeMap[code] ?? ShoppingListErrorCode.unknown,
      parseMessage(error),
      details: parseDetails(error),
    );
  }
  return ShoppingListException(ShoppingListErrorCode.unknown, error.toString());
}

const _shoppingListCodeMap = <String, ShoppingListErrorCode>{
  'INVALID_NAME': ShoppingListErrorCode.invalidName,
  'INVALID_SCOPE_TYPE': ShoppingListErrorCode.invalidScopeType,
  'INVALID_UNIT_SCOPE': ShoppingListErrorCode.invalidUnitScope,
  'INVALID_REFERENCE_PHOTO_PATH': ShoppingListErrorCode.invalidReferencePhotoPath,
  'PHOTO_DELETE_NOT_ALLOWED': ShoppingListErrorCode.photoDeleteNotAllowed,
  'NOT_HOME_MEMBER': ShoppingListErrorCode.notHomeMember,
  'ITEM_NOT_FOUND': ShoppingListErrorCode.itemNotFound,
  'ITEM_ALREADY_COMPLETED_BY_OTHER':
      ShoppingListErrorCode.itemAlreadyCompletedByOther,
  'INVALID_EXPENSE': ShoppingListErrorCode.invalidExpense,
  'PAYWALL_LIMIT_SHOPPING_ITEM_PHOTOS':
      ShoppingListErrorCode.paywallShoppingItemPhotosCap,
  'FORBIDDEN': ShoppingListErrorCode.forbidden,
  'UNAUTHORIZED': ShoppingListErrorCode.unauthorized,
};
