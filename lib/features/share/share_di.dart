import 'package:get_it/get_it.dart';
import 'package:kinly/features/share/data/supabase/supabase_expenses_repository.dart';
import 'package:kinly/core/ui/navigation/share_navigation.dart';
import 'package:kinly/features/share/share.dart';
import 'package:kinly/features/share/ui/share_navigation.dart';

void installShareDependencies(GetIt sl) {
  if (!sl.isRegistered<ExpensesRepository>()) {
    sl.registerLazySingleton<ExpensesRepository>(
      () => SupabaseExpensesRepository(),
    );
  }
  if (!sl.isRegistered<ShareNavigation>()) {
    sl.registerLazySingleton<ShareNavigation>(
      () => const ShareNavigationImpl(),
    );
  }
}
