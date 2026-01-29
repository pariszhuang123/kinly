import '../models.dart';

abstract class HomeRepository {
  Future<HomeCreationResult> create({String? name});

  Future<HomeInvite> getOrCreateInvite({required String homeId});

  Future<HomeInvite> revokeInvite({required String homeId});

  Future<HomeInvite> getActiveInvite(String homeId);

  Future<HomeJoinResult> join(String code);

  Future<HomeJoinResult> joinHome(String code);

  Future<void> transferOwner({
    required String homeId,
    required String newOwnerId,
  });

  Future<void> kickMember({required String homeId, required String userId});

  Future<LeaveResult> leave({required String homeId});

  Future<CurrentMembership?> getCurrentMembership({bool excludeSelf = false});

  Future<List<HomeMemberSummary>> listActiveMembers(
    String homeId, {
    bool excludeSelf = false,
  });

  Future<HomeInvite> rotateInvite(String homeId);

  Future<void> logShareEvent({
    required String homeId,
    required String feature,
    required String channel,
  });

  Future<void> dismissMemberCapJoinRequests({required String homeId});

  Future<PlanStatus> getPlanStatus();
}
