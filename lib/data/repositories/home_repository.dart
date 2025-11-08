abstract class HomeRepository {
  Future<void> createHome(String name);
  Future<void> joinHome(String code);
  Future<void> transferOwner(String homeId, String newOwnerId);
  Future<void> leaveHome(String homeId);
}

