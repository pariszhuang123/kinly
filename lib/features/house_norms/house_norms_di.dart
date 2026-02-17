import 'package:get_it/get_it.dart';

import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/features/house_norms/data/supabase/supabase_house_norms_repository.dart';

void installHouseNormsDependencies(GetIt sl) {
  if (!sl.isRegistered<HouseNormsRepository>()) {
    sl.registerLazySingleton<HouseNormsRepository>(
      () => SupabaseHouseNormsRepository(),
    );
  }
}
