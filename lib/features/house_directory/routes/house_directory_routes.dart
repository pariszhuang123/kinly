import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/house_directory/data/supabase/supabase_house_directory_repository.dart';
import 'package:kinly/features/house_directory/ui/house_directory_details_screen.dart';
import 'package:kinly/features/house_directory/ui/house_directory_provider.dart';
import 'package:kinly/features/house_directory/ui/house_directory_screen.dart';

class HouseDirectoryRouteContext {
  const HouseDirectoryRouteContext({
    required this.homeId,
    required this.isOwner,
  });

  final String homeId;
  final bool isOwner;
}

typedef HouseDirectoryRouteContextResolver =
    HouseDirectoryRouteContext? Function();

List<GoRoute> buildHouseDirectoryRoutes({
  required HouseDirectoryRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.houseDirectory,
      name: AppRouteNames.houseDirectory,
      builder: (_, state) => _buildRoute(
        state: state,
        routeName: 'houseDirectory',
        resolveContext: resolveContext,
        childBuilder: (context) => HouseDirectoryScreen(homeId: context.homeId),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.houseDirectoryDetails,
      name: AppRouteNames.houseDirectoryDetails,
      builder: (_, state) => _buildRoute(
        state: state,
        routeName: 'houseDirectoryDetails',
        resolveContext: resolveContext,
        childBuilder:
            (context) => HouseDirectoryDetailsScreen(homeId: context.homeId),
      ),
    ),
  ];
}

Widget _buildRoute({
  required GoRouterState state,
  required String routeName,
  required HouseDirectoryRouteContextResolver resolveContext,
  required Widget Function(HouseDirectoryRouteContext context) childBuilder,
}) {
  final context = resolveContext();
  if (context == null) {
    return routeFallback(
      routeName,
      state: state,
      reason: 'active membership missing while route restores',
    );
  }
  final repository =
      sl.isRegistered<HouseDirectoryRepository>()
          ? sl<HouseDirectoryRepository>()
          : SupabaseHouseDirectoryRepository();
  return HouseDirectoryProvider(
    repository: repository,
    homeId: context.homeId,
    isOwner: context.isOwner,
    child: childBuilder(context),
  );
}
