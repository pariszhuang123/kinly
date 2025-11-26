import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/features/hub/bloc/hub_bloc.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const homeId = 'home-1';
  late HomeRepository homeRepository;

  final invite = HomeInvite(
    id: 'invite-1',
    homeId: homeId,
    code: 'abc123',
    createdBy: 'user-1',
    createdAt: DateTime.now().toUtc(),
  );

  final member = HomeMemberSummary(
    userId: 'user-1',
    username: 'Pat',
    role: 'owner',
    validFrom: DateTime.now().toUtc(),
    avatarUrl: null,
    canTransferTo: false,
  );

  setUp(() {
    homeRepository = _MockHomeRepository();
  });

  blocTest<HubBloc, HubState>(
    'loads members and invite on start',
    build: () {
      when(
        () => homeRepository.listActiveMembers(homeId, excludeSelf: false),
      ).thenAnswer((_) async => [member]);
      when(
        () => homeRepository.getOrCreateInvite(homeId),
      ).thenAnswer((_) async => invite);

      return HubBloc(
        homeRepository: homeRepository,
        homeId: homeId,
        logger: const DebugLogger(),
      );
    },
    expect:
        () => [
          isA<HubState>().having((s) => s.status, 'status', HubStatus.loading),
          isA<HubState>()
              .having((s) => s.status, 'status', HubStatus.success)
              .having((s) => s.members.length, 'members', 1)
              .having((s) => s.inviteCode, 'inviteCode', invite.code),
        ],
    verify: (_) {
      verify(
        () => homeRepository.listActiveMembers(homeId, excludeSelf: false),
      ).called(1);
      verify(() => homeRepository.getOrCreateInvite(homeId)).called(1);
    },
  );

  blocTest<HubBloc, HubState>(
    'emits failure when repository throws',
    build: () {
      when(
        () => homeRepository.listActiveMembers(homeId, excludeSelf: false),
      ).thenThrow(Exception('boom'));
      when(
        () => homeRepository.getOrCreateInvite(homeId),
      ).thenAnswer((_) async => invite);

      return HubBloc(
        homeRepository: homeRepository,
        homeId: homeId,
        logger: const DebugLogger(),
      );
    },
    expect:
        () => [
          isA<HubState>().having((s) => s.status, 'status', HubStatus.loading),
          isA<HubState>().having((s) => s.status, 'status', HubStatus.failure),
        ],
  );

  blocTest<HubBloc, HubState>(
    'still succeeds when invite fails (non-owner)',
    build: () {
      when(
        () => homeRepository.listActiveMembers(homeId, excludeSelf: false),
      ).thenAnswer((_) async => [member]);
      when(
        () => homeRepository.getOrCreateInvite(homeId),
      ).thenThrow(Exception('forbidden'));

      return HubBloc(
        homeRepository: homeRepository,
        homeId: homeId,
        logger: const DebugLogger(),
      );
    },
    expect:
        () => [
          isA<HubState>().having((s) => s.status, 'status', HubStatus.loading),
          isA<HubState>()
              .having((s) => s.status, 'status', HubStatus.success)
              .having((s) => s.members.length, 'members', 1)
              .having((s) => s.invite, 'invite', isNull),
        ],
  );
}
