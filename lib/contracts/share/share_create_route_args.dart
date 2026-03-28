enum ShareCreatePresentationMode {
  standard,
  shoppingQuickCreate,
}

class ShareShoppingExpenseLinkRequest {
  const ShareShoppingExpenseLinkRequest({
    required this.homeId,
    required this.itemIds,
  });

  final String homeId;
  final List<String> itemIds;
}

class ShareCreateRouteArgs {
  const ShareCreateRouteArgs({
    this.initialDescription,
    this.initialNotes,
    this.preselectEqualSplit = false,
    this.presentationMode = ShareCreatePresentationMode.standard,
    this.shoppingExpenseLinkRequest,
  });

  final String? initialDescription;
  final String? initialNotes;
  final bool preselectEqualSplit;
  final ShareCreatePresentationMode presentationMode;
  final ShareShoppingExpenseLinkRequest? shoppingExpenseLinkRequest;
}
