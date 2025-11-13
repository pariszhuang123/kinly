import 'package:get_it/get_it.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/home_repository.dart';
import '../auth/fake_auth_repository.dart';
import '../auth/supabase_auth_repository.dart';
import '../homes/fake_home_repository.dart';
import '../homes/supabase_home_repository.dart';

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
}
