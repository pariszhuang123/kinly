import 'package:get_it/get_it.dart';
import 'package:kinly/contracts/preferences/ports/house_vibe_repository.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/features/preferences/data/supabase/supabase_house_vibe_repository.dart';
import 'package:kinly/features/preferences/data/supabase/supabase_preference_reports_repository.dart';

void installPreferenceDependencies(GetIt sl) {
  if (!sl.isRegistered<PreferenceReportsRepository>()) {
    sl.registerLazySingleton<PreferenceReportsRepository>(
      () => SupabasePreferenceReportsRepository(),
    );
  }
  if (!sl.isRegistered<HouseVibeRepository>()) {
    sl.registerLazySingleton<HouseVibeRepository>(
      () => SupabaseHouseVibeRepository(),
    );
  }
}
