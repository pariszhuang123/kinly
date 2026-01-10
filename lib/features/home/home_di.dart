import 'package:get_it/get_it.dart';
import 'package:kinly/features/home/data/supabase/supabase_home_repository.dart';
import 'package:kinly/features/home/home.dart';

void installHomeDependencies(GetIt sl) {
  if (!sl.isRegistered<HomeRepository>()) {
    sl.registerLazySingleton<HomeRepository>(() => SupabaseHomeRepository());
  }
}
