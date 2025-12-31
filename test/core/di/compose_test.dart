import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/di/compose.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/flow/domain/ports/chores_repository.dart';
import 'package:kinly/features/home/domain/ports/home_repository.dart';
import 'package:kinly/features/paywall/domain/ports/paywall_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    // Minimal Supabase init so feature installers can construct repositories.
    await Supabase.initialize(
      url: 'http://localhost',
      anonKey: 'test-anon-key',
    );
  });

  setUp(() async {
    await sl.reset();
  });

  tearDown(() async {
    await sl.reset();
  });

  test(
    'composeDependencies registers feature repositories and is idempotent',
    () {
      composeDependencies();

      expect(sl.isRegistered<HomeRepository>(), isTrue);
      expect(sl.isRegistered<ChoresRepository>(), isTrue);
      expect(sl.isRegistered<PaywallRepository>(), isTrue);

      // Access to ensure instances resolve without throwing.
      expect(() => sl<HomeRepository>(), returnsNormally);
      expect(() => sl<ChoresRepository>(), returnsNormally);
      expect(() => sl<PaywallRepository>(), returnsNormally);

      // Second call should be a no-op and still resolve.
      composeDependencies();
      expect(() => sl<HomeRepository>(), returnsNormally);
    },
  );
}
