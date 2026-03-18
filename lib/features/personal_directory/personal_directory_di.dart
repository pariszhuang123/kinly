import 'package:get_it/get_it.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/features/personal_directory/data/supabase/supabase_personal_directory_repository.dart';

void installPersonalDirectoryDependencies(GetIt sl) {
  if (!sl.isRegistered<PersonalDirectoryRepository>()) {
    sl.registerLazySingleton<PersonalDirectoryRepository>(
      () => SupabasePersonalDirectoryRepository(),
    );
  }
}
