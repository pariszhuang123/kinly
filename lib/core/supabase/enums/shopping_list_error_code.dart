/// Error codes returned by shopping_list_* RPCs.
enum ShoppingListErrorCode {
  invalidName,
  invalidReferencePhotoPath,
  photoDeleteNotAllowed,
  notHomeMember,
  itemNotFound,
  itemAlreadyCompletedByOther,
  invalidExpense,
  paywallShoppingItemPhotosCap,
  unauthorized,
  forbidden,
  unknown,
}
