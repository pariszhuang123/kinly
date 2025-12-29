import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/features/home_membership/join/bloc/join_home_bloc.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';

class _FakeHomeRepository implements HomeRepository {
  Object? errorToThrow;

  @override
  Future<void> join(String code) async {
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<HomeCreationResult> create() =>
      Future.value(const HomeCreationResult(homeId: ''));

  @override
  Future<void> revokeInvite(String homeId) async {}

  @override
  Future<String> rotateInvite(String homeId) async => '';

  @override
  Future<HomeInvite> getActiveInvite(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<HomeInvite> getOrCreateInvite(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<void> transferOwner(String homeId, String newOwnerId) async {}

  @override
  Future<LeaveResult> leave(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<void> kickMember(String homeId, String userId) async {}

  @override
  Future<List<HomeMemberSummary>> listActiveMembers(String homeId,
      {bool excludeSelf = false}) {
    throw UnimplementedError();
  }

  @override
  Future<CurrentMembership?> getCurrentMembership() {
    throw UnimplementedError();
  }

  @override
  Future<void> logShareEvent(
      {required String feature, required String channel, String? homeId}) {
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
