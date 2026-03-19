import 'package:flutter/material.dart';

import 'package:kinly/contracts/share/models.dart';

abstract class ShareNavigation {
  Future<bool?> openOwedDetail({
    required BuildContext context,
    required TodayShareOwed owed,
    String? currentUsername,
  });

  Future<bool?> openPaidToMeDetail({
    required BuildContext context,
    required TodaySharePaidToMe entry,
    required String homeId,
  });
}
