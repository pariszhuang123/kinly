import 'package:purchases_flutter/purchases_flutter.dart';

import '../logging/logger.dart';

const _logTagRevenueCatUser = 'RevenueCatUser';

Future<void> syncRevenueCatUser(Logger logger, {String? userId}) async {
  try {
    final currentId = await Purchases.appUserID;
    final isAnonymous = currentId.startsWith(r'$RCAnonymousID');

    if (userId == null || userId.isEmpty) {
      // Avoid logging out when already anonymous to prevent noisy errors.
      if (!isAnonymous) {
        await Purchases.logOut();
        logger.info('RevenueCat logged out', tag: _logTagRevenueCatUser);
      }
      return;
    }

    if (currentId == userId) {
      logger.info(
        'RevenueCat already logged in as $userId',
        tag: _logTagRevenueCatUser,
      );
      return;
    }

    final result = await Purchases.logIn(userId);
    logger.info(
      'RevenueCat logged in: ${result.customerInfo.originalAppUserId}',
      tag: _logTagRevenueCatUser,
    );
  } catch (error, stackTrace) {
    logger.warn(
      'RevenueCat user sync failed: $error',
      tag: _logTagRevenueCatUser,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
