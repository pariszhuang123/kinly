import 'package:get_it/get_it.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/features/house_directory/data/supabase/supabase_house_directory_repository.dart';

void installHouseDirectoryDependencies(GetIt sl) {
  if (!sl.isRegistered<HouseDirectoryRepository>()) {
    sl.registerLazySingleton<HouseDirectoryRepository>(
      () => SupabaseHouseDirectoryRepository(),
    );
  }
}
