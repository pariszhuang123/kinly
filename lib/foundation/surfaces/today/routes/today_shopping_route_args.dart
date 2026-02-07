import 'package:kinly/contracts/homes/shopping_models.dart';

import '../domain/models.dart';

class TodayShoppingRouteArgs {
  const TodayShoppingRouteArgs({
    required this.homeId,
    this.actor,
    this.item,
  });

  final String homeId;
  final TodayUserProfile? actor;
  final ShoppingListItem? item;
}
