import 'package:kinly/core/config/app_config.dart';
import 'package:test/test.dart';

void main() {
  group('AppConfig.validate', () {
    test('throws when required dart-defines are missing', () {
      expect(
        () => AppConfig.validate(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            allOf(
              contains('SUPABASE_URL'),
              contains('SUPABASE_ANON_KEY'),
              contains('DEEPLINK_HOST'),
              contains('REVENUECAT_IOS_KEY'),
              contains('REVENUECAT_ANDROID_KEY'),
            ),
          ),
        ),
      );
    });
  });

  group('resolveKinlyPublicAppLink', () {
    test('falls back to go.makinglifeeasie.com when invite host is empty', () {
      expect(resolveKinlyPublicAppLink(), 'https://go.makinglifeeasie.com/kinly');
    });
  });
}
