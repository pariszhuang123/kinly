import 'package:get_it/get_it.dart';
import 'package:kinly/features/paywall/data/supabase/supabase_paywall_repository.dart';
import 'package:kinly/core/ui/paywall/ports/paywall_launcher.dart';
import 'package:kinly/features/paywall/paywall.dart';
import 'package:kinly/features/paywall/ui/paywall_launcher.dart';

void installPaywallDependencies(GetIt sl) {
  if (!sl.isRegistered<PaywallRepository>()) {
    sl.registerLazySingleton<PaywallRepository>(
      () => SupabasePaywallRepository(),
    );
  }
  if (!sl.isRegistered<PaywallLauncher>()) {
    sl.registerLazySingleton<PaywallLauncher>(
      () => const PaywallLauncherImpl(),
    );
  }
}
