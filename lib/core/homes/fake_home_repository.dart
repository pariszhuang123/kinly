import '../../data/repositories/home_repository.dart';
import 'models.dart';

class FakeHomeRepository implements HomeRepository {
  @override
  Future<void> join(String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (code.isEmpty) {
      throw ArgumentError('Invite code cannot be empty');
    }
    // No-op: pretend the join succeeded.
  }

  @override
  Future<HomeCreationResult> create() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const HomeCreationResult(homeId: 'fake-home-id');
  }

  @override
  Future<void> revokeInvite(String homeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  @override
  Future<String> rotateInvite(String homeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return 'ABC123';
  }

  @override
  Future<HomeInvite> getActiveInvite(String homeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return HomeInvite(
      id: 'invite-id',
      homeId: homeId,
      code: 'abc123',
      createdBy: 'user-1',
      createdAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<HomeInvite> getOrCreateInvite(String homeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return HomeInvite(
      id: 'invite-id',
      homeId: homeId,
      code: 'abc123',
      createdBy: 'user-1',
      createdAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<void> transferOwner(String homeId, String newOwnerId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  @override
  Future<LeaveResult> leave(String homeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return const LeaveResult(
      outcome: LeaveOutcome.leftOk,
      homeDeactivated: false,
      membersRemaining: 1,
      roleBefore: 'member',
    );
  }

  @override
  Future<CurrentMembership?> getCurrentMembership() async {
    // Pretend user has no membership by default
    return null;
  }

  @override
  Future<List<HomeMemberSummary>> listActiveMembers(
    String homeId, {
    bool excludeSelf = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return const [];
  }
}
