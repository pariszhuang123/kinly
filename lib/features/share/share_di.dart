import 'package:get_it/get_it.dart';
import 'package:kinly/features/share/data/supabase/supabase_expenses_repository.dart';
import 'package:kinly/features/share/share.dart';

void installShareDependencies(GetIt sl) {
  if (!sl.isRegistered<ExpensesRepository>()) {
    sl.registerLazySingleton<ExpensesRepository>(
      () => SupabaseExpensesRepository(),
    );
  }
}
