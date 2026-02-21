import 'package:kinly/contracts/share/models.dart';
import 'share_paid_to_me_detail_models.dart';

class ShareOwedDetailRouteArgs {
  const ShareOwedDetailRouteArgs({required this.owed});

  final TodayShareOwed owed;
}

class SharePaidToMeDetailRouteArgs {
  const SharePaidToMeDetailRouteArgs({
    required this.entry,
    required this.homeId,
  });

  final TodaySharePaidToMe entry;
  final String homeId;
}

class ShareOwedItemDetailRouteArgs {
  const ShareOwedItemDetailRouteArgs({required this.item});

  final TodayShareOwedItem item;
}

class SharePaidItemDetailRouteArgs {
  const SharePaidItemDetailRouteArgs({required this.item});

  final TodaySharePaidItem item;
}

class SharePhotoRouteArgs {
  const SharePhotoRouteArgs({
    required this.photoUrl,
    required this.title,
    required this.heroTag,
  });

  final String photoUrl;
  final String title;
  final Object heroTag;
}
