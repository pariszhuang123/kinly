import 'package:get_it/get_it.dart';
import 'package:kinly/features/harmony/data/supabase/supabase_mood_repository.dart';
import 'package:kinly/features/harmony/harmony.dart';

void installHarmonyDependencies(GetIt sl) {
  if (!sl.isRegistered<MoodRepository>()) {
    sl.registerLazySingleton<MoodRepository>(() => SupabaseMoodRepository());
  }
}
