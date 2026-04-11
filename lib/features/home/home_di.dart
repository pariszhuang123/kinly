import 'package:get_it/get_it.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';
import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/features/home/data/supabase/supabase_fit_check_repository.dart';
import 'package:kinly/features/home/data/supabase/supabase_home_repository.dart';
import 'package:kinly/features/home/data/supabase/supabase_home_units_repository.dart';
import 'package:kinly/features/home/data/supabase/supabase_shopping_list_repository.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/core/links/join_intent_coordinator.dart';
import 'package:kinly/core/links/invite_code_parser.dart';
import 'package:kinly/core/links/pending_join_intent_storage.dart';
import 'package:kinly/core/logging/logger.dart';

void installHomeDependencies(GetIt sl) {
  if (!sl.isRegistered<HomeRepository>()) {
    sl.registerLazySingleton<HomeRepository>(() => SupabaseHomeRepository());
  }
  if (!sl.isRegistered<ShoppingListRepository>()) {
    sl.registerLazySingleton<ShoppingListRepository>(
      () => SupabaseShoppingListRepository(),
    );
  }
  if (!sl.isRegistered<HomeUnitsRepository>()) {
    sl.registerLazySingleton<HomeUnitsRepository>(
      () => SupabaseHomeUnitsRepository(),
    );
  }
  if (!sl.isRegistered<FitCheckRepository>()) {
    sl.registerLazySingleton<FitCheckRepository>(
      () => SupabaseFitCheckRepository(),
    );
  }
  if (!sl.isRegistered<InviteCodeParser>()) {
    sl.registerLazySingleton<InviteCodeParser>(() => const InviteCodeParser());
  }
  if (!sl.isRegistered<PendingJoinIntentStorage>()) {
    sl.registerLazySingleton<PendingJoinIntentStorage>(
      () => PendingJoinIntentStorage(),
    );
  }
  if (!sl.isRegistered<JoinIntentCoordinator>()) {
    sl.registerLazySingleton<JoinIntentCoordinator>(
      () => JoinIntentCoordinator(
        storage: sl<PendingJoinIntentStorage>(),
        parser: sl<InviteCodeParser>(),
        homeRepository: sl<HomeRepository>(),
        logger: sl<Logger>(),
      ),
    );
  }
}
