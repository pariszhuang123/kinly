import 'package:kinly/contracts/share/models.dart';

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
