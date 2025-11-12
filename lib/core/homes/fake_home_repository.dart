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
  Future<void> revokeInvite(String homeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  @override
  Future<String> rotateInvite(String homeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return 'ABC123';
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
}
