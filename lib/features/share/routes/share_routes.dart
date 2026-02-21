import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/share/ui/share_created_list/share_created_list_provider.dart';
import 'package:kinly/features/share/ui/share_create/share_create_provider.dart';
import 'package:kinly/features/share/ui/share_detail_route_args.dart';
import 'package:kinly/features/share/ui/share_edit_provider.dart';
import 'package:kinly/features/share/ui/share_edit_route_args.dart';
import 'package:kinly/features/share/ui/share_owed_detail_screen.dart';
import 'package:kinly/features/share/ui/share_owed_item_detail_screen.dart';
import 'package:kinly/features/share/ui/share_paid_item_detail_screen.dart';
import 'package:kinly/features/share/ui/share_paid_to_me_detail_screen.dart';
import 'package:kinly/features/share/ui/share_photo_viewer_screen.dart';

class ShareRouteContext {
  const ShareRouteContext({required this.homeId});

  final String homeId;
}

typedef ShareRouteContextResolver = ShareRouteContext Function();

List<GoRoute> buildShareRoutes({
  required ShareRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.shareCreatedList,
      name: AppRouteNames.shareCreatedList,
      builder: (_, state) {
        final membership = resolveContext();
        final draftsOnly = state.extra is bool ? state.extra as bool : false;
        return ShareCreatedListProvider(
          homeId: membership.homeId,
          expensesRepository: sl<ExpensesRepository>(),
          draftsOnly: draftsOnly,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.shareCreate,
      name: AppRouteNames.shareCreate,
      builder: (_, __) {
        final membership = resolveContext();
        return ShareCreateProvider(
          homeId: membership.homeId,
          expensesRepository: sl<ExpensesRepository>(),
          homeRepository: sl<HomeRepository>(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.shareDraftEdit,
      name: AppRouteNames.shareDraftEdit,
      builder: (_, state) {
        final membership = resolveContext();
        final expenseId = state.pathParameters['expenseId']!;
        final args = state.extra as ShareEditRouteArgs?;
        return ShareEditProvider(
          homeId: membership.homeId,
          expenseId: expenseId,
          expensesRepository: sl<ExpensesRepository>(),
          homeRepository: sl<HomeRepository>(),
          allowDelete: args?.allowDelete ?? false,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.shareOwedDetail,
      name: AppRouteNames.shareOwedDetail,
      builder: (_, state) {
        final args = state.extra as ShareOwedDetailRouteArgs?;
        if (args == null) {
          return routeFallback('shareOwedDetail');
        }
        return ShareOwedDetailScreen(
          owed: args.owed,
          expensesRepository: sl<ExpensesRepository>(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.sharePaidToMeDetail,
      name: AppRouteNames.sharePaidToMeDetail,
      builder: (_, state) {
        final args = state.extra as SharePaidToMeDetailRouteArgs?;
        if (args == null) {
          return routeFallback('sharePaidToMeDetail');
        }
        return SharePaidToMeDetailScreen(
          entry: args.entry,
          homeId: args.homeId,
          expensesRepository: sl<ExpensesRepository>(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.shareOwedItemDetail,
      name: AppRouteNames.shareOwedItemDetail,
      builder: (_, state) {
        final args = state.extra as ShareOwedItemDetailRouteArgs?;
        if (args == null) {
          return routeFallback('shareOwedItemDetail');
        }
        return ShareOwedItemDetailScreen(item: args.item);
      },
    ),
    GoRoute(
      path: AppRoutePaths.sharePaidItemDetail,
      name: AppRouteNames.sharePaidItemDetail,
      builder: (_, state) {
        final args = state.extra as SharePaidItemDetailRouteArgs?;
        if (args == null) {
          return routeFallback('sharePaidItemDetail');
        }
        return SharePaidItemDetailScreen(item: args.item);
      },
    ),
    GoRoute(
      path: AppRoutePaths.sharePhoto,
      name: AppRouteNames.sharePhoto,
      builder: (_, state) {
        final args = state.extra as SharePhotoRouteArgs?;
        if (args == null) {
          return routeFallback('sharePhoto');
        }
        return SharePhotoViewerScreen(
          photoUrl: args.photoUrl,
          title: args.title,
          heroTag: args.heroTag,
        );
      },
    ),
  ];
}
