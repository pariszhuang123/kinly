import 'package:get_it/get_it.dart';
import 'package:kinly/features/harmony/data/supabase/supabase_house_pulse_repository.dart';
import 'package:kinly/features/harmony/data/supabase/supabase_mood_repository.dart';
import 'package:kinly/features/harmony/harmony.dart';
import 'package:kinly/contracts/mood/ports/house_pulse_repository.dart';

void installHarmonyDependencies(GetIt sl) {
  if (!sl.isRegistered<MoodRepository>()) {
    sl.registerLazySingleton<MoodRepository>(() => SupabaseMoodRepository());
  }
  if (!sl.isRegistered<HousePulseRepository>()) {
    sl.registerLazySingleton<HousePulseRepository>(
      () => SupabaseHousePulseRepository(),
    );
  }
}
