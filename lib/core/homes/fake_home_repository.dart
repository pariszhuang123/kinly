import '../../data/repositories/home_repository.dart';

class FakeHomeRepository implements HomeRepository {
  @override
  Future<void> join(String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (code.isEmpty) {
      throw ArgumentError('Invite code cannot be empty');
    }
    // No-op: pretend the join succeeded.
  }
}

