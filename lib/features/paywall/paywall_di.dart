import 'package:get_it/get_it.dart';
import 'package:kinly/features/paywall/data/supabase/supabase_paywall_repository.dart';
import 'package:kinly/features/paywall/paywall.dart';

void installPaywallDependencies(GetIt sl) {
  if (!sl.isRegistered<PaywallRepository>()) {
    sl.registerLazySingleton<PaywallRepository>(
      () => SupabasePaywallRepository(),
    );
  }
}
