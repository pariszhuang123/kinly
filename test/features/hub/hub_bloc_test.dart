import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/house_vibe_repository.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/foundation/surfaces/hub/bloc/hub_bloc.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockPreferenceReportsRepository extends Mock
    implements PreferenceReportsRepository {}

class _MockHouseVibeRepository extends Mock implements HouseVibeRepository {}

class _MockHouseNormsRepository extends Mock implements HouseNormsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const homeId = 'home-1';
  late HomeRepository homeRepository;
  late PreferenceReportsRepository preferenceReportsRepository;
  late HouseVibeRepository houseVibeRepository;
  late HouseNormsRepository houseNormsRepository;

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

  final houseVibe = HouseVibePayload(
    homeId: homeId,
    mappingVersion: 'v1',
    labelId: 'default_home',
    titleKey: 'vibe.default.title',
    summaryKey: 'vibe.default.summary',
    imageKey: 'vibe_default_v1',
    ui: const {},
    coverage: const HouseVibeCoverage(answered: 2, total: 2),
  );

  setUp(() {
    homeRepository = _MockHomeRepository();
    preferenceReportsRepository = _MockPreferenceReportsRepository();
    houseVibeRepository = _MockHouseVibeRepository();
    houseNormsRepository = _MockHouseNormsRepository();
    when(
      () => houseVibeRepository.getHomeVibe(homeId: homeId),
    ).thenAnswer((_) async => houseVibe);
    when(
      () => houseNormsRepository.getForHome(
        homeId: any(named: 'homeId'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer((_) async => null);
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
        houseVibeRepository: houseVibeRepository,
        houseNormsRepository: houseNormsRepository,
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
        houseVibeRepository: houseVibeRepository,
        houseNormsRepository: houseNormsRepository,
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
    'loads house norms when document exists',
    build: () {
      when(
        () => homeRepository.getCurrentMembership(),
      ).thenAnswer((_) async => membership);
      when(
        () => homeRepository.listActiveMembers(homeId, excludeSelf: false),
      ).thenAnswer((_) async => [member]);
      when(
        () => homeRepository.getActiveInvite(homeId),
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
      when(
        () => houseNormsRepository.getForHome(homeId: homeId, locale: 'en'),
      ).thenAnswer((_) async => _buildHouseNormDocument(homeId));

      return HubBloc(
        homeRepository: homeRepository,
        preferenceReportsRepository: preferenceReportsRepository,
        houseVibeRepository: houseVibeRepository,
        houseNormsRepository: houseNormsRepository,
        homeId: homeId,
        logger: const DebugLogger(),
      );
    },
    expect:
        () => [
          isA<HubState>().having((s) => s.status, 'status', HubStatus.loading),
          isA<HubState>()
              .having((s) => s.status, 'status', HubStatus.success)
              .having((s) => s.hasHouseNorms, 'hasHouseNorms', true),
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
        houseVibeRepository: houseVibeRepository,
        houseNormsRepository: houseNormsRepository,
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

HouseNormDocument _buildHouseNormDocument(String homeId) {
  return HouseNormDocument(
    homeId: homeId,
    templateKey: 'house_norms_v1',
    status: 'published',
    inputs: const {},
    draftContent: null,
    draftUpdatedAt: null,
    publishedContent: const HouseNormContent(
      summary: HouseNormSummary(
        title: 'House norms',
        subtitle: 'Shared defaults',
        framing: 'A shared starting point.',
      ),
      context: 'Context',
      sections: [
        HouseNormSection(
          sectionKey: 'norms_rhythm_quiet',
          title: 'Rhythm',
          text: 'We usually wind down.',
        ),
      ],
    ),
    publishedAt: DateTime.utc(2026, 1, 1),
    publishedVersion: 'v1',
    isPublished: true,
    hasUnpublishedChanges: false,
    lastEditedAt: null,
    lastEditedBy: null,
    homePublicId: 'home-public',
    publicUrl: 'https://go.makinglifeeasie.com/norms/home-public',
    showPublishButton: false,
    showRepublishButton: false,
    showPublicUrl: true,
  );
}
