import 'package:get_it/get_it.dart';

import '../account/account.dart';
import '../app_version/app_version.dart';
import '../auth/auth.dart';
import '../onboarding/onboarding.dart';
import '../account/data/supabase/supabase_account_repository.dart';
import '../app_version/supabase_app_version_repository.dart';
import '../auth/supabase_auth_repository.dart';
import '../config/app_config.dart';
import '../logging/debug_logger.dart';
import '../logging/logger.dart';
import '../logging/sentry_logger.dart';
import '../network/connectivity_monitor.dart';
import '../notifications/device_token_provider.dart';
import '../notifications/notifications.dart';
import '../notifications/data/supabase/supabase_notifications_repository.dart';
import '../onboarding/data/supabase/supabase_onboarding_repository.dart';
import 'package:kinly/features/profile_settings/domain/ports/profile_repository.dart';
import 'package:kinly/features/profile_settings/data/supabase/supabase_profile_repository.dart';
import '../profile/profile_update_notifier.dart';
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
