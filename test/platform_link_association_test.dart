import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('Platform link association config', () {
    test('Android manifest declares verified link scope for /kinly', () {
      final manifest =
          File('android/app/src/main/AndroidManifest.xml').readAsStringSync();

      expect(
        manifest,
        contains('android:autoVerify="true"'),
        reason: 'autoVerify must be enabled for verified app links',
      );
      expect(
        manifest,
        contains('android:scheme="https"'),
        reason: 'verified links must use https scheme',
      );
      expect(
        manifest,
        contains(r'android:host="${deeplinkHost}"'),
        reason: 'host is provided via manifestPlaceholder deeplinkHost',
      );
      expect(
        manifest,
        contains('android:pathPrefix="/kinly/join"'),
        reason: 'path scope must match canonical /kinly/join prefix (join flow)',
      );
    });

    test('iOS associated domains include prod and dev hosts', () {
      final entitlements =
          File('ios/Runner/Runner.entitlements').readAsStringSync();

      expect(
        entitlements,
        contains('applinks:go.makinglifeeasie.com'),
        reason: 'prod host must be declared for Universal Links',
      );
      expect(
        entitlements,
        contains('applinks:dev.go.makinglifeeasie.com'),
        reason: 'dev host must be declared for Universal Links',
      );
    });
  });
}
