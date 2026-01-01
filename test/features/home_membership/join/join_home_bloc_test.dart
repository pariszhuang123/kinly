import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/features/home_membership/join/bloc/join_home_bloc.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';

class _FakeHomeRepository implements HomeRepository {
  Object? errorToThrow;

  @override
  Future<HomeJoinResult> join(String code) async {
    if (errorToThrow != null) throw errorToThrow!;
    return const HomeJoinResult(homeId: 'home-1', outcome: JoinOutcome.success);
  }

  @override
  Future<HomeJoinResult> joinHome(String code) => join(code);

  @override
  Future<HomeCreationResult> create({String? name}) =>
      Future.value(const HomeCreationResult(homeId: ''));

  @override
  Future<HomeInvite> revokeInvite({required String homeId}) async =>
      HomeInvite(
        id: 'invite-1',
        homeId: homeId,
        code: 'code',
        createdBy: 'user',
        createdAt: DateTime(2024),
      );

  @override
  Future<HomeInvite> rotateInvite(String homeId) async => revokeInvite(
        homeId: homeId,
      );

  @override
  Future<HomeInvite> getActiveInvite(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<HomeInvite> getOrCreateInvite({required String homeId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> transferOwner({
    required String homeId,
    required String newOwnerId,
  }) async {}

  @override
  Future<void> kickMember({required String homeId, required String userId}) async {}

  @override
  Future<LeaveResult> leave({required String homeId}) {
    throw UnimplementedError();
  }

  @override
  Future<List<HomeMemberSummary>> listMembers({
    required String homeId,
    bool activeOnly = false,
    bool excludeSelf = false,
  }) async =>
      const <HomeMemberSummary>[];

  @override
  Future<List<HomeMemberSummary>> listActiveMembers(
    String homeId, {
    bool excludeSelf = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<CurrentMembership?> getCurrentMembership({bool excludeSelf = false}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logShareEvent(
    {required String feature,
    required String channel,
    required String homeId}) {
    throw UnimplementedError();
  }
}

void main() {
  group('JoinHomeBloc', () {
    late _FakeHomeRepository repo;

    setUp(() {
      repo = _FakeHomeRepository();
    });

    blocTest<JoinHomeBloc, JoinHomeState>(
      'emits profileDeactivated error when mapper throws profile deactivated',
      build: () => JoinHomeBloc(homeRepository: repo),
      act: (bloc) {
        repo.errorToThrow = HomeJoinException(
          JoinErrorCode.profileDeactivated,
          'blocked',
        );
        bloc
          ..add(const JoinHomeCodeChanged('ABCDEF'))
          ..add(const JoinHomeSubmitted());
      },
      expect: () => [
        const JoinHomeState(code: 'ABCDEF', status: JoinHomeStatus.editing),
        const JoinHomeState(
          code: 'ABCDEF',
          status: JoinHomeStatus.submitting,
          errorType: null,
          errorMessage: null,
        ),
        predicate<JoinHomeState>(
          (state) =>
              state.status == JoinHomeStatus.failure &&
              state.errorType == JoinHomeErrorType.profileDeactivated,
        ),
      ],
    );
  });
}
