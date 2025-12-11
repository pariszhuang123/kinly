import 'package:get_it/get_it.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/app_version_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/chores_repository.dart';
import '../../data/repositories/expenses_repository.dart';
import '../../data/repositories/home_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../account/supabase_account_repository.dart';
import '../auth/supabase_auth_repository.dart';
import '../chores/supabase_chores_repository.dart';
import '../expenses/supabase_expenses_repository.dart';
import '../homes/supabase_home_repository.dart';
import '../profile/supabase_profile_repository.dart';
import '../app_version/supabase_app_version_repository.dart';
import '../network/connectivity_monitor.dart';
import '../config/app_config.dart';
import '../logging/logger.dart';
import '../logging/debug_logger.dart';
import '../logging/sentry_logger.dart';
import '../../data/repositories/mood_repository.dart';
import '../mood/supabase_mood_repository.dart';
import '../profile/profile_update_notifier.dart';
import '../../data/repositories/notifications_repository.dart';
import '../notifications/supabase_notifications_repository.dart';
import '../notifications/notification_sync_state.dart';
import '../../data/repositories/onboarding_repository.dart';
import '../onboarding/supabase_onboarding_repository.dart';
import '../telemetry/telemetry.dart';
import '../telemetry/logger_telemetry.dart';
import '../../data/repositories/paywall_repository.dart';
import '../paywall/supabase_paywall_repository.dart';
import '../purchases/revenuecat_service.dart';

final sl = GetIt.instance;

void setupDependencies() {
  if (!sl.isRegistered<Logger>()) {
    const debugLogger = DebugLogger();
    sl.registerLazySingleton<Logger>(
      () =>
          AppConfig.sentryDsn.isNotEmpty
              ? SentryLogger(fallback: debugLogger)
              : debugLogger,
    );
  }
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(() => SupabaseAuthRepository());
  }
  if (!sl.isRegistered<HomeRepository>()) {
    // Prefer real Supabase repo; fall back to fake if Supabase is unavailable.
    sl.registerLazySingleton<HomeRepository>(() => SupabaseHomeRepository());
  }
  if (!sl.isRegistered<ChoresRepository>()) {
    sl.registerLazySingleton<ChoresRepository>(
      () => SupabaseChoresRepository(),
    );
  }
  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(
      () => SupabaseProfileRepository(),
    );
  }
  if (!sl.isRegistered<ProfileUpdateNotifier>()) {
    sl.registerLazySingleton<ProfileUpdateNotifier>(
      () => ProfileUpdateNotifier(),
    );
  }
  if (!sl.isRegistered<AccountRepository>()) {
    sl.registerLazySingleton<AccountRepository>(
      () => SupabaseAccountRepository(),
    );
  }
  if (!sl.isRegistered<ConnectivityMonitor>()) {
    sl.registerLazySingleton<ConnectivityMonitor>(
      () => ConnectivityMonitor()..initialize(),
    );
  }
  if (!sl.isRegistered<AppVersionRepository>()) {
    sl.registerLazySingleton<AppVersionRepository>(
      () => SupabaseAppVersionRepository(),
    );
  }
  if (!sl.isRegistered<ExpensesRepository>()) {
    sl.registerLazySingleton<ExpensesRepository>(
      () => SupabaseExpensesRepository(),
    );
  }
  if (!sl.isRegistered<MoodRepository>()) {
    sl.registerLazySingleton<MoodRepository>(() => SupabaseMoodRepository());
  }
  if (!sl.isRegistered<NotificationSyncState>()) {
    sl.registerLazySingleton<NotificationSyncState>(
      () => NotificationSyncState(),
    );
  }
  if (!sl.isRegistered<NotificationsRepository>()) {
    sl.registerLazySingleton<NotificationsRepository>(
      () => SupabaseNotificationsRepository(
        syncState: sl<NotificationSyncState>(),
      ),
    );
  }
  if (!sl.isRegistered<OnboardingRepository>()) {
    sl.registerLazySingleton<OnboardingRepository>(
      () => SupabaseOnboardingRepository(),
    );
  }
  if (!sl.isRegistered<Telemetry>()) {
    sl.registerLazySingleton<Telemetry>(() => LoggerTelemetry(sl<Logger>()));
  }
  if (!sl.isRegistered<PaywallRepository>()) {
    sl.registerLazySingleton<PaywallRepository>(
      () => SupabasePaywallRepository(),
    );
  }
  if (!sl.isRegistered<RevenueCatService>()) {
    sl.registerLazySingleton<RevenueCatService>(
      () => DefaultRevenueCatService(),
    );
  }
}
