import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/ui/media/kinly_photo_viewer_screen.dart';
import 'package:kinly/features/house_directory/data/supabase/supabase_house_directory_repository.dart';
import 'package:kinly/features/house_directory/ui/house_directory_details_screen.dart';
import 'package:kinly/features/house_directory/ui/house_directory_note_screen.dart';
import 'package:kinly/features/house_directory/ui/house_directory_provider.dart';
import 'package:kinly/features/house_directory/ui/house_directory_route_args.dart';
import 'package:kinly/features/house_directory/ui/house_directory_screen.dart';
import 'package:kinly/features/house_directory/ui/house_directory_service_screen.dart';
import 'package:kinly/features/house_directory/ui/house_directory_wifi_screen.dart';

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
        childBuilder:
            (context, _) => HouseDirectoryScreen(homeId: context.homeId),
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
            (context, _) => HouseDirectoryDetailsScreen(
              homeId: context.homeId,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.houseDirectoryWifi,
      name: AppRouteNames.houseDirectoryWifi,
      builder: (_, state) => _buildRoute(
        state: state,
        routeName: 'houseDirectoryWifi',
        resolveContext: resolveContext,
        childBuilder: (context, _) {
          final args = state.extra as HouseDirectoryWifiRouteArgs?;
          return HouseDirectoryWifiScreen(
            homeId: context.homeId,
            wifi: args?.wifi,
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutePaths.houseDirectoryService,
      name: AppRouteNames.houseDirectoryService,
      builder: (_, state) => _buildRoute(
        state: state,
        routeName: 'houseDirectoryService',
        resolveContext: resolveContext,
        childBuilder: (context, _) {
          final args = state.extra as HouseDirectoryServiceRouteArgs?;
          return HouseDirectoryServiceScreen(
            homeId: context.homeId,
            isOwner: context.isOwner,
            serviceId: args?.serviceId,
            reminderId: args?.reminderId,
            startInEditMode: args?.startInEditMode ?? false,
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutePaths.houseDirectoryNote,
      name: AppRouteNames.houseDirectoryNote,
      builder: (_, state) => _buildRoute(
        state: state,
        routeName: 'houseDirectoryNote',
        resolveContext: resolveContext,
        childBuilder: (context, repository) {
          final args = state.extra as HouseDirectoryNoteRouteArgs?;
          return HouseDirectoryNoteScreen(
            homeId: context.homeId,
            repository: repository,
            isOwner: context.isOwner,
            noteId: args?.noteId,
            initialNoteType:
                args?.initialNoteType ?? HouseDirectoryNoteType.general,
            startInEditMode: args?.startInEditMode ?? false,
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutePaths.houseDirectoryPhoto,
      name: AppRouteNames.houseDirectoryPhoto,
      builder: (_, state) {
        final args = state.extra as HouseDirectoryPhotoRouteArgs?;
        if (args == null) {
          return routeFallback('houseDirectoryPhoto');
        }
        return KinlyPhotoViewerScreen(
          photoUrl: args.photoUrl,
          heroTag: args.heroTag,
          title: args.title,
        );
      },
    ),
  ];
}

Widget _buildRoute({
  required GoRouterState state,
  required String routeName,
  required HouseDirectoryRouteContextResolver resolveContext,
  required Widget Function(
    HouseDirectoryRouteContext context,
    HouseDirectoryRepository repository,
  )
  childBuilder,
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
    child: childBuilder(context, repository),
  );
}
