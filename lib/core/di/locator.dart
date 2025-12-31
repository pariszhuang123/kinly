import 'package:get_it/get_it.dart';

import '../account/account.dart';
import '../app_version/app_version.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/expenses_repository.dart';
import '../../data/repositories/mood_repository.dart';
import '../onboarding/onboarding.dart';
import '../../data/repositories/profile_repository.dart';
import '../account/data/supabase/supabase_account_repository.dart';
import '../app_version/supabase_app_version_repository.dart';
import '../auth/supabase_auth_repository.dart';
import '../config/app_config.dart';
import '../expenses/supabase_expenses_repository.dart';
import '../logging/debug_logger.dart';
import '../logging/logger.dart';
import '../logging/sentry_logger.dart';
import '../mood/supabase_mood_repository.dart';
import '../network/connectivity_monitor.dart';
import '../notifications/device_token_provider.dart';
import '../notifications/notifications.dart';
import '../notifications/data/supabase/supabase_notifications_repository.dart';
import '../onboarding/data/supabase/supabase_onboarding_repository.dart';
import '../profile/profile_update_notifier.dart';
import '../profile/supabase_profile_repository.dart';
import '../purchases/revenuecat_service.dart';
import '../time/iana_timezone_resolver.dart';

final sl = GetIt.instance;

void setupDependencies() {
  final registrations = <void Function()>[
    () {
      _registerLazy<Logger>(() {
        const debugLogger = DebugLogger();
        return AppConfig.sentryDsn.isNotEmpty
            ? SentryLogger(fallback: debugLogger)
            : debugLogger;
      });
    },
    () => _registerLazy<IanaTimezoneResolver>(
      () => IanaTimezoneResolver(logger: sl<Logger>()),
    ),
    () => _registerLazy<AuthRepository>(
      () => SupabaseAuthRepository(logger: sl<Logger>()),
    ),
    () => _registerLazy<ProfileRepository>(() => SupabaseProfileRepository()),
    () => _registerLazy<ProfileUpdateNotifier>(() => ProfileUpdateNotifier()),
    () => _registerLazy<AccountRepository>(() => SupabaseAccountRepository()),
    () => _registerLazy<ConnectivityMonitor>(
      () => ConnectivityMonitor()..initialize(),
    ),
    () => _registerLazy<AppVersionRepository>(
      () => SupabaseAppVersionRepository(),
    ),
    () => _registerLazy<ExpensesRepository>(() => SupabaseExpensesRepository()),
    () => _registerLazy<MoodRepository>(() => SupabaseMoodRepository()),
    () => _registerLazy<NotificationSyncState>(() => NotificationSyncState()),
    () => _registerLazy<DeviceTokenProvider>(
      () => const FirebaseDeviceTokenProvider(),
    ),
    () => _registerLazy<NotificationsRepository>(
      () => SupabaseNotificationsRepository(
        syncState: sl<NotificationSyncState>(),
      ),
    ),
    () => _registerLazy<OnboardingRepository>(
      () => SupabaseOnboardingRepository(),
    ),
    () => _registerLazy<RevenueCatService>(() => DefaultRevenueCatService()),
  ];

  for (final register in registrations) {
    register();
  }
}

void _registerLazy<T extends Object>(T Function() builder) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(builder);
  }
}
