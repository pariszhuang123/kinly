import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../logging/logger.dart';

typedef RequestIosNotificationPermission =
    Future<AuthorizationStatus> Function();
typedef RequestAndroidNotificationPermission =
    Future<PermissionStatus> Function();
typedef ReadApnsToken = Future<String?> Function();
typedef ReadFcmToken = Future<String?> Function();
typedef PlatformPredicate = bool Function();

/// Handles startup notification permission requests for supported platforms.
class StartupNotificationPermissionRequester {
  StartupNotificationPermissionRequester({
    required Logger logger,
    String tag = 'Bootstrap',
    PlatformPredicate? isIOS,
    PlatformPredicate? isAndroid,
    RequestIosNotificationPermission? requestIosPermission,
    RequestAndroidNotificationPermission? requestAndroidPermission,
    ReadApnsToken? readApnsToken,
    ReadFcmToken? readFcmToken,
  }) : _logger = logger,
       _tag = tag,
       _isIOS = isIOS ?? (() => Platform.isIOS),
       _isAndroid = isAndroid ?? (() => Platform.isAndroid),
       _requestIosPermission =
           requestIosPermission ?? _defaultRequestIosPermission,
       _requestAndroidPermission =
           requestAndroidPermission ?? _defaultRequestAndroidPermission,
       _readApnsToken = readApnsToken ?? _defaultReadApnsToken,
       _readFcmToken = readFcmToken ?? _defaultReadFcmToken;

  final Logger _logger;
  final String _tag;
  final PlatformPredicate _isIOS;
  final PlatformPredicate _isAndroid;
  final RequestIosNotificationPermission _requestIosPermission;
  final RequestAndroidNotificationPermission _requestAndroidPermission;
  final ReadApnsToken _readApnsToken;
  final ReadFcmToken _readFcmToken;

  Future<bool> requestIfSupported() async {
    if (_isIOS()) {
      final status = await _requestIosPermission();
      _logger.info(
        'iOS notification permission status: ${status.name}',
        tag: _tag,
      );
      final apnsToken = await _readApnsToken();
      _logger.info('APNs token after request: ${apnsToken ?? 'null'}', tag: _tag);
      if (apnsToken != null && apnsToken.isNotEmpty) {
        final fcmToken = await _readFcmToken();
        _logger.info('FCM token after request: ${fcmToken ?? 'null'}', tag: _tag);
      }
      return true;
    }

    if (_isAndroid()) {
      final status = await _requestAndroidPermission();
      _logger.info(
        'Android notification permission status: ${status.name}',
        tag: _tag,
      );
      if (status.isGranted) {
        final fcmToken = await _readFcmToken();
        _logger.info(
          'FCM token after Android permission request: ${fcmToken ?? 'null'}',
          tag: _tag,
        );
      }
      return true;
    }

    return false;
  }

  static Future<AuthorizationStatus> _defaultRequestIosPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      provisional: false,
    );
    return settings.authorizationStatus;
  }

  static Future<PermissionStatus> _defaultRequestAndroidPermission() async {
    return Permission.notification.request();
  }

  static Future<String?> _defaultReadApnsToken() async {
    return FirebaseMessaging.instance.getAPNSToken();
  }

  static Future<String?> _defaultReadFcmToken() async {
    return FirebaseMessaging.instance.getToken();
  }
}
