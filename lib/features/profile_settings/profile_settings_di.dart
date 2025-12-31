import 'package:get_it/get_it.dart';
import 'package:kinly/features/profile_settings/profile_settings.dart';
import 'package:kinly/features/profile_settings/data/supabase/supabase_profile_repository.dart';

void installProfileSettingsDependencies(GetIt sl) {
  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(
      () => SupabaseProfileRepository(),
    );
  }
}
