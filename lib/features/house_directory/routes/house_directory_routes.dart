import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/house_directory/ui/house_directory_provider.dart';

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
      builder: (_, state) {
        final context = resolveContext();
        if (context == null || !sl.isRegistered<HouseDirectoryRepository>()) {
          return routeFallback(
            'houseDirectory',
            state: state,
            reason:
                'active membership or House Directory repository missing while route restores',
          );
        }
        return HouseDirectoryProvider(
          repository: sl<HouseDirectoryRepository>(),
          homeId: context.homeId,
          isOwner: context.isOwner,
        );
      },
    ),
  ];
}
