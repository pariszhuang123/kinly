import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../contracts/share/models.dart';
import '../../../app/router/app_route_names.dart';
import '../../../core/ui/navigation/share_navigation.dart';
import 'share_detail_route_args.dart';

class ShareNavigationImpl implements ShareNavigation {
  const ShareNavigationImpl();

  @override
  Future<bool?> openOwedDetail({
    required BuildContext context,
    required TodayShareOwed owed,
    String? currentUsername,
  }) {
    return context.pushNamed<bool>(
      AppRouteNames.shareOwedDetail,
      extra: ShareOwedDetailRouteArgs(
        owed: owed,
        currentUsername: currentUsername,
      ),
    );
  }

  @override
  Future<bool?> openPaidToMeDetail({
    required BuildContext context,
    required TodaySharePaidToMe entry,
    required String homeId,
  }) {
    return context.pushNamed<bool>(
      AppRouteNames.sharePaidToMeDetail,
      extra: SharePaidToMeDetailRouteArgs(entry: entry, homeId: homeId),
    );
  }
}
