import 'dart:io';

class PlatformInfo {
  const PlatformInfo._();

  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
}
