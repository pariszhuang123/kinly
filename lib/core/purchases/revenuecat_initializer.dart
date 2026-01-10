import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart' as rc;

import '../config/app_config.dart';
import '../logging/logger.dart';

const _logTag = 'RevenueCatInit';

Future<void> initRevenueCat(Logger logger, {String? appUserId}) async {
  final apiKey =
      Platform.isIOS
          ? AppConfig.revenuecatIosKey
          : Platform.isAndroid
          ? AppConfig.revenuecatAndroidKey
          : null;
  if (apiKey == null || apiKey.isEmpty) {
    throw StateError('Missing RevenueCat API key for platform');
  }

  await rc.Purchases.setLogLevel(rc.LogLevel.debug);
  await rc.Purchases.configure(
    rc.PurchasesConfiguration(apiKey)..appUserID = appUserId,
  );
  final rcUserId = await rc.Purchases.appUserID;
  logger.info('RevenueCat configured rcUserId=$rcUserId', tag: _logTag);
}
