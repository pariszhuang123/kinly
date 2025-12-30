import 'package:get_it/get_it.dart';
import 'package:kinly/features/flow/data/supabase/supabase_chores_repository.dart';
import 'package:kinly/features/flow/flow.dart';

void installFlowDependencies(GetIt sl) {
  if (!sl.isRegistered<ChoresRepository>()) {
    sl.registerLazySingleton<ChoresRepository>(
      () => SupabaseChoresRepository(),
    );
  }
}
