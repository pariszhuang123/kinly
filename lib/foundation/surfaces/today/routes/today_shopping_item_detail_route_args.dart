import 'package:kinly/contracts/homes/shopping_models.dart';

class TodayShoppingItemDetailRouteArgs {
  const TodayShoppingItemDetailRouteArgs({
    required this.item,
    required this.photoUrl,
    required this.onMarkComplete,
  });

  final ShoppingListItem item;
  final String photoUrl;
  final Future<void> Function() onMarkComplete;
}
