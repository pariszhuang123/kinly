import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';

import '../domain/models.dart';
import 'bloc/shopping_list_bloc.dart';
import 'today_shopping_list_screen.dart';

class TodayShoppingListProvider extends StatelessWidget {
  const TodayShoppingListProvider({
    super.key,
    required this.homeId,
    required this.shoppingListRepository,
    required this.expensesRepository,
    this.actor,
  });

  final String homeId;
  final ShoppingListRepository shoppingListRepository;
  final ExpensesRepository expensesRepository;
  final TodayUserProfile? actor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ShoppingListBloc(
            homeId: homeId,
            currentUserId: actor?.userId,
            shoppingListRepository: shoppingListRepository,
            expensesRepository: expensesRepository,
          )..add(const LoadShoppingListEvent()),
      child: TodayShoppingListScreen(homeId: homeId, actor: actor),
    );
  }
}
