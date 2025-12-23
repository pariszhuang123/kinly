import 'package:firebase_messaging/firebase_messaging.dart';

/// Abstraction for fetching device notification tokens.
abstract class DeviceTokenProvider {
  Future<String?> getToken();
}

/// Default provider backed by Firebase Messaging.
class FirebaseDeviceTokenProvider implements DeviceTokenProvider {
  const FirebaseDeviceTokenProvider();

  @override
  Future<String?> getToken() => FirebaseMessaging.instance.getToken();
}
