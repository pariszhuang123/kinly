import 'package:kinly/contracts/homes/shopping_models.dart';

import '../domain/models.dart';

enum TodayShoppingListMode {
  purchase,
  manage,
}

class TodayShoppingRouteArgs {
  const TodayShoppingRouteArgs({
    required this.homeId,
    this.listMode = TodayShoppingListMode.purchase,
    this.actor,
    this.item,
  });

  final String homeId;
  final TodayShoppingListMode listMode;
  final TodayUserProfile? actor;
  final ShoppingListItem? item;
}
