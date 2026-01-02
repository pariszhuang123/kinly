import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/app/di/compose.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/flow/domain/ports/chores_repository.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/features/home/domain/ports/home_repository.dart';
import 'package:kinly/features/paywall/domain/ports/paywall_repository.dart';
import 'package:kinly/features/share/domain/ports/expenses_repository.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/contracts/auth/ports/auth_repository.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/contracts/account/ports/account_repository.dart';
import 'package:kinly/contracts/app_version/ports/app_version_repository.dart';
import 'package:kinly/core/network/connectivity_monitor.dart';
import 'package:kinly/contracts/onboarding/ports/onboarding_repository.dart';
import 'package:kinly/core/notifications/notifications.dart';
import 'package:kinly/core/notifications/device_token_provider.dart';
import 'package:kinly/core/notifications/profile_update_notifier.dart';
import 'package:kinly/core/purchases/revenuecat_service.dart';
import 'package:kinly/core/time/iana_timezone_resolver.dart';
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
      expect(sl.isRegistered<ExpensesRepository>(), isTrue);
      expect(sl.isRegistered<MoodRepository>(), isTrue);
      expect(sl.isRegistered<ProfileRepository>(), isTrue);
      expect(sl.isRegistered<AuthRepository>(), isTrue);
      expect(sl.isRegistered<AccountRepository>(), isTrue);
      expect(sl.isRegistered<AppVersionRepository>(), isTrue);
      expect(sl.isRegistered<OnboardingRepository>(), isTrue);
      expect(sl.isRegistered<NotificationsRepository>(), isTrue);
      expect(sl.isRegistered<NotificationSyncState>(), isTrue);
      expect(sl.isRegistered<DeviceTokenProvider>(), isTrue);
      expect(sl.isRegistered<ProfileUpdateNotifier>(), isTrue);
      expect(sl.isRegistered<IanaTimezoneResolver>(), isTrue);
      expect(sl.isRegistered<ConnectivityMonitor>(), isTrue);
      expect(sl.isRegistered<RevenueCatService>(), isTrue);
      expect(sl.isRegistered<Logger>(), isTrue);

      // Access to ensure instances resolve without throwing.
      expect(() => sl<HomeRepository>(), returnsNormally);
      expect(() => sl<ChoresRepository>(), returnsNormally);
      expect(() => sl<PaywallRepository>(), returnsNormally);
      expect(() => sl<ExpensesRepository>(), returnsNormally);
      expect(() => sl<MoodRepository>(), returnsNormally);
      expect(() => sl<ProfileRepository>(), returnsNormally);
      expect(() => sl<AuthRepository>(), returnsNormally);
      expect(() => sl<AccountRepository>(), returnsNormally);
      expect(() => sl<AppVersionRepository>(), returnsNormally);
      expect(() => sl<OnboardingRepository>(), returnsNormally);
      expect(() => sl<NotificationsRepository>(), returnsNormally);
      expect(() => sl<NotificationSyncState>(), returnsNormally);
      expect(() => sl<DeviceTokenProvider>(), returnsNormally);
      expect(() => sl<ProfileUpdateNotifier>(), returnsNormally);
      expect(() => sl<IanaTimezoneResolver>(), returnsNormally);
      expect(() => sl<ConnectivityMonitor>(), returnsNormally);
      expect(() => sl<RevenueCatService>(), returnsNormally);
      expect(() => sl<Logger>(), returnsNormally);

      // Second call should be a no-op and still resolve.
      composeDependencies();
      expect(() => sl<HomeRepository>(), returnsNormally);
    },
  );
}

