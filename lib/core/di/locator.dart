import 'package:get_it/get_it.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/chores_repository.dart';
import '../../data/repositories/home_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../account/supabase_account_repository.dart';
import '../auth/supabase_auth_repository.dart';
import '../chores/supabase_chores_repository.dart';
import '../homes/supabase_home_repository.dart';
import '../profile/supabase_profile_repository.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // TODO: register repositories and services here.
  // sl.registerLazySingleton<AuthRepository>(() => SupabaseAuthRepository());
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
  if (!sl.isRegistered<AccountRepository>()) {
    sl.registerLazySingleton<AccountRepository>(
      () => SupabaseAccountRepository(),
    );
  }
}
