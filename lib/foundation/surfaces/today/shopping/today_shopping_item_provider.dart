import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';

import 'bloc/shopping_item_bloc.dart';
import 'today_shopping_item_editor_screen.dart';

class TodayShoppingItemProvider extends StatelessWidget {
  const TodayShoppingItemProvider({
    super.key,
    required this.homeId,
    required this.shoppingListRepository,
    this.item,
  });

  final String homeId;
  final ShoppingListRepository shoppingListRepository;
  final ShoppingListItem? item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ShoppingItemBloc(
            homeId: homeId,
            item: item,
            shoppingListRepository: shoppingListRepository,
          ),
      child: TodayShoppingItemEditorScreen(homeId: homeId, item: item),
    );
  }
}
