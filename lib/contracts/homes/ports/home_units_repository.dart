import '../home_units_models.dart';

abstract class HomeUnitsRepository {
  Future<HomeUnitContext> getMyUnitContext({required String homeId});

  Future<List<HomeUnitSummary>> listSelectableExpenseUnits({
    required String homeId,
  });

  Future<List<HomeUnitMemberCandidate>> listCreateSharedUnitCandidates({
    required String homeId,
  });

  Future<List<HomeUnitSummary>> listJoinableSharedUnits({
    required String homeId,
  });

  Future<String> createSharedUnit({
    required String homeId,
    required String name,
    required List<String> membershipIds,
  });

  Future<String> renameSharedUnit({
    required String unitId,
    required String name,
  });

  Future<String> joinSharedUnit({required String unitId});

  Future<String> leaveSharedUnit({required String unitId});
}
