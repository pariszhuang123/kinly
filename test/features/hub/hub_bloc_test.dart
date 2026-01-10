import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/foundation/surfaces/hub/bloc/hub_bloc.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockPreferenceReportsRepository extends Mock
    implements PreferenceReportsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const homeId = 'home-1';
  late HomeRepository homeRepository;
  late PreferenceReportsRepository preferenceReportsRepository;

  final membership = CurrentMembership(
    userId: 'user-1',
    homeId: homeId,
    role: 'owner',
    validFrom: DateTime.now().toUtc(),
  );

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

  final reportItem = PreferenceReportListItem(
    reportId: 'report-1',
    subjectUserId: 'user-1',
    publishedAt: DateTime.now().toUtc(),
    lastEditedAt: null,
  );

  setUp(() {
    homeRepository = _MockHomeRepository();
    preferenceReportsRepository = _MockPreferenceReportsRepository();
  });

  blocTest<HubBloc, HubState>(
    'loads members and invite on start',
    build: () {
      when(
        () => homeRepository.getCurrentMembership(),
      ).thenAnswer((_) async => membership);
      when(
        () => homeRepository.listActiveMembers(homeId, excludeSelf: false),
      ).thenAnswer((_) async => [member]);
      when(
        () => homeRepository.getActiveInvite(homeId),
      ).thenThrow(Exception('no active invite'));
      when(
        () => homeRepository.getOrCreateInvite(homeId: homeId),
      ).thenAnswer((_) async => invite);
      when(
        () => preferenceReportsRepository.getTemplateResolution(
          templateKey: any(named: 'templateKey'),
        ),
      ).thenAnswer(
        (_) async => const PreferenceTemplateResolution(
          templateKey: 'personal_preferences_v1',
          requestedLocale: 'en-NZ',
          resolvedLocale: 'en',
        ),
      );
      when(
        () => preferenceReportsRepository.listReportsForHome(
          homeId: homeId,
          templateKey: any(named: 'templateKey'),
          locale: 'en',
        ),
      ).thenAnswer((_) async => [reportItem]);

      return HubBloc(
        homeRepository: homeRepository,
        preferenceReportsRepository: preferenceReportsRepository,
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
              .having((s) => s.preferenceReports.length, 'preferenceReports', 1)
              .having((s) => s.inviteCode, 'inviteCode', invite.code),
        ],
    verify: (_) {
      verify(
        () => homeRepository.listActiveMembers(homeId, excludeSelf: false),
      ).called(1);
      verify(() => homeRepository.getOrCreateInvite(homeId: homeId)).called(1);
      verify(
        () => preferenceReportsRepository.listReportsForHome(
          homeId: homeId,
          templateKey: any(named: 'templateKey'),
          locale: 'en',
        ),
      ).called(1);
    },
  );

  blocTest<HubBloc, HubState>(
    'emits failure when repository throws',
    build: () {
      when(
        () => homeRepository.getCurrentMembership(),
      ).thenAnswer((_) async => membership);
      when(
        () => homeRepository.listActiveMembers(homeId, excludeSelf: false),
      ).thenThrow(Exception('boom'));
      when(
        () => homeRepository.getOrCreateInvite(homeId: homeId),
      ).thenAnswer((_) async => invite);
      when(
        () => preferenceReportsRepository.getTemplateResolution(
          templateKey: any(named: 'templateKey'),
        ),
      ).thenAnswer(
        (_) async => const PreferenceTemplateResolution(
          templateKey: 'personal_preferences_v1',
          requestedLocale: 'en-NZ',
          resolvedLocale: 'en',
        ),
      );
      when(
        () => preferenceReportsRepository.listReportsForHome(
          homeId: homeId,
          templateKey: any(named: 'templateKey'),
          locale: 'en',
        ),
      ).thenAnswer((_) async => const []);

      return HubBloc(
        homeRepository: homeRepository,
        preferenceReportsRepository: preferenceReportsRepository,
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
        () => homeRepository.getCurrentMembership(),
      ).thenAnswer((_) async => membership);
      when(
        () => homeRepository.listActiveMembers(homeId, excludeSelf: false),
      ).thenAnswer((_) async => [member]);
      when(
        () => homeRepository.getActiveInvite(homeId),
      ).thenThrow(Exception('no active invite'));
      when(
        () => homeRepository.getOrCreateInvite(homeId: homeId),
      ).thenThrow(Exception('forbidden'));
      when(
        () => preferenceReportsRepository.getTemplateResolution(
          templateKey: any(named: 'templateKey'),
        ),
      ).thenAnswer(
        (_) async => const PreferenceTemplateResolution(
          templateKey: 'personal_preferences_v1',
          requestedLocale: 'en-NZ',
          resolvedLocale: 'en',
        ),
      );
      when(
        () => preferenceReportsRepository.listReportsForHome(
          homeId: homeId,
          templateKey: any(named: 'templateKey'),
          locale: 'en',
        ),
      ).thenAnswer((_) async => const []);

      return HubBloc(
        homeRepository: homeRepository,
        preferenceReportsRepository: preferenceReportsRepository,
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
