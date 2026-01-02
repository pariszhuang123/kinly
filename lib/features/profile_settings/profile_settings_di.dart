import 'package:get_it/get_it.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/features/profile_settings/data/supabase/supabase_profile_repository.dart';

void installProfileSettingsDependencies(GetIt sl) {
  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(
      () => SupabaseProfileRepository(),
    );
  }
}
