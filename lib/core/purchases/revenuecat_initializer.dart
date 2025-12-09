import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';

import '../config/app_config.dart';
import '../logging/logger.dart';

const _logTag = 'RevenueCatInit';

Future<void> initRevenueCat(Logger logger, {String? appUserId}) async {
  final apiKey = Platform.isIOS
      ? AppConfig.revenuecatIosKey
      : Platform.isAndroid
          ? AppConfig.revenuecatAndroidKey
          : null;
  if (apiKey == null || apiKey.isEmpty) {
    throw StateError('Missing RevenueCat API key for platform');
  }

  await Purchases.configure(
    PurchasesConfiguration(apiKey)..appUserID = appUserId,
  );
  logger.info('RevenueCat configured', tag: _logTag);
}
