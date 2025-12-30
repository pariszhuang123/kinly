import 'package:kinly/core/homes/models.dart';
import 'package:kinly/features/home/home.dart';

class FakeHomeRepository implements HomeRepository {
  final List<HomeMemberSummary> _members = [];
  CurrentMembership? currentMembership;

  @override
  Future<HomeCreationResult> create({String? name}) async {
    return HomeCreationResult(homeId: 'home-1');
  }

  @override
  Future<HomeInvite> getOrCreateInvite({required String homeId}) async {
    return HomeInvite(
      id: 'invite-1',
      homeId: homeId,
      code: 'code-1',
      createdBy: 'user-1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      revokedAt: null,
    );
  }

  @override
  Future<HomeInvite> revokeInvite({required String homeId}) async {
    return getOrCreateInvite(homeId: homeId);
  }

  @override
  Future<HomeJoinResult> join(String code) async => joinHome(code);

  @override
  Future<HomeJoinResult> joinHome(String code) async {
    return HomeJoinResult(homeId: 'home-1');
  }

  @override
  Future<void> transferOwner({
    required String homeId,
    required String newOwnerId,
  }) async {}

  @override
  Future<void> kickMember({
    required String homeId,
    required String userId,
  }) async {
    _members.removeWhere((member) => member.userId == userId);
    if (currentMembership?.userId == userId) {
      currentMembership = null;
    }
  }

  @override
  Future<LeaveResult> leave({required String homeId}) async {
    return LeaveResult(
      outcome: LeaveOutcome.leftOk,
      homeDeactivated: false,
      membersRemaining: 1,
      roleBefore: 'owner',
    );
  }

  @override
  Future<List<HomeMemberSummary>> listMembers({
    required String homeId,
    bool activeOnly = false,
    bool excludeSelf = false,
  }) async {
    final filtered =
        excludeSelf && currentMembership != null
            ? _members
                .where((m) => m.userId != currentMembership!.userId)
                .toList()
            : List<HomeMemberSummary>.from(_members);
    return activeOnly
        ? filtered.where((m) => m.role.isNotEmpty).toList()
        : filtered;
  }

  @override
  Future<List<HomeMemberSummary>> listActiveMembers(
    String homeId, {
    bool excludeSelf = false,
  }) async {
    final filtered =
        excludeSelf && currentMembership != null
            ? _members
                .where((m) => m.userId != currentMembership!.userId)
                .toList()
            : List<HomeMemberSummary>.from(_members);
    return filtered.where((m) => m.role.isNotEmpty).toList();
  }

  @override
  Future<HomeInvite> getActiveInvite(String homeId) async =>
      getOrCreateInvite(homeId: homeId);

  @override
  Future<HomeInvite> rotateInvite(String homeId) async =>
      getOrCreateInvite(homeId: homeId);

  @override
  Future<void> logShareEvent({
    required String homeId,
    required String feature,
    required String channel,
  }) async {}

  @override
  Future<CurrentMembership?> getCurrentMembership({
    bool excludeSelf = false,
  }) async => excludeSelf ? null : currentMembership;
}
