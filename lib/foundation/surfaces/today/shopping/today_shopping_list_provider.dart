import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';

import '../domain/models.dart';
import '../routes/today_shopping_route_args.dart';
import 'bloc/shopping_list_bloc.dart';
import 'today_shopping_list_screen.dart';

class TodayShoppingListProvider extends StatelessWidget {
  const TodayShoppingListProvider({
    super.key,
    required this.homeId,
    required this.shoppingListRepository,
    this.mode = TodayShoppingListMode.purchase,
    this.actor,
  });

  final String homeId;
  final ShoppingListRepository shoppingListRepository;
  final TodayShoppingListMode mode;
  final TodayUserProfile? actor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ShoppingListBloc(
            homeId: homeId,
            currentUserId: actor?.userId,
            shoppingListRepository: shoppingListRepository,
          )..add(const LoadShoppingListEvent()),
      child: TodayShoppingListScreen(homeId: homeId, actor: actor, mode: mode),
    );
  }
}
