import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/foundation/surfaces/today/shopping/bloc/shopping_list_bloc.dart';
import 'package:kinly/foundation/surfaces/explore/explore_surface.dart';

class ExploreRouteContext {
  const ExploreRouteContext({required this.homeId, required this.userId});

  final String homeId;
  final String userId;
}

typedef ExploreRouteContextResolver = ExploreRouteContext Function();

List<GoRoute> buildExploreRoutes({
  required ExploreRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.explore,
      name: AppRouteNames.explore,
      builder: (_, __) {
        final route = resolveContext();
        return BlocProvider(
          create:
              (_) => ShoppingListBloc(
                homeId: route.homeId,
                currentUserId: route.userId,
                shoppingListRepository: sl<ShoppingListRepository>(),
                expensesRepository: sl<ExpensesRepository>(),
              )..add(const LoadShoppingListEvent()),
          child: ExploreScreen(homeId: route.homeId),
        );
      },
    ),
  ];
}
