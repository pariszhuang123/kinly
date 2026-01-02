import 'package:flutter/material.dart';

import '../../../core/di/locator.dart';
import '../../../contracts/share/models.dart';
import '../../../contracts/share/ports/expenses_repository.dart';
import '../../../core/ui/navigation/share_navigation.dart';
import 'share_owed_detail_screen.dart';
import 'share_paid_to_me_detail_screen.dart';

class ShareNavigationImpl implements ShareNavigation {
  const ShareNavigationImpl();

  @override
  Future<bool?> openOwedDetail({
    required BuildContext context,
    required TodayShareOwed owed,
  }) {
    final repository = sl<ExpensesRepository>();
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder:
            (_) =>
                ShareOwedDetailScreen(
                  owed: owed,
                  expensesRepository: repository,
                ),
      ),
    );
  }

  @override
  Future<bool?> openPaidToMeDetail({
    required BuildContext context,
    required TodaySharePaidToMe entry,
    required String homeId,
  }) {
    final repository = sl<ExpensesRepository>();
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder:
            (_) => SharePaidToMeDetailScreen(
              entry: entry,
              homeId: homeId,
              expensesRepository: repository,
            ),
      ),
    );
  }
}
