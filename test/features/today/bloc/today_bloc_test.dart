import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/foundation/surfaces/today/bloc/today_bloc.dart';
import 'package:kinly/foundation/surfaces/today/domain/models.dart';
import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/contracts/flow/ports/chores_repository.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/contracts/mood/ports/house_pulse_repository.dart';
import 'package:kinly/contracts/onboarding/ports/onboarding_repository.dart';
import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/contracts/profile/models.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/core/notifications/profile_update_notifier.dart';

class _MockChoresRepository extends Mock implements ChoresRepository {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockMoodRepository extends Mock implements MoodRepository {}

class _MockHousePulseRepository extends Mock implements HousePulseRepository {}

class _MockOnboardingRepository extends Mock implements OnboardingRepository {}

class _MockPreferenceReportsRepository extends Mock
    implements PreferenceReportsRepository {}

class _MockHouseNormsRepository extends Mock implements HouseNormsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(ChoreState.active);
  });

  late _MockChoresRepository choresRepository;
  late _MockProfileRepository profileRepository;
  late _MockExpensesRepository expensesRepository;
  late _MockHomeRepository homeRepository;
  late _MockMoodRepository moodRepository;
  late _MockHousePulseRepository housePulseRepository;
  late _MockOnboardingRepository onboardingRepository;
  late _MockPreferenceReportsRepository preferenceReportsRepository;
  late _MockHouseNormsRepository houseNormsRepository;
  late ProfileUpdateNotifier profileUpdateNotifier;

  const homeId = 'home-1';
  const ownerUserId = 'user-owner';
  const memberUserId = 'user-member';

  final ownerMember = HomeMemberSummary(
    userId: ownerUserId,
    username: 'Owner',
    role: 'owner',
    validFrom: DateTime(2024, 1, 1),
  );

  final regularMember = HomeMemberSummary(
    userId: memberUserId,
    username: 'Member',
    role: 'member',
    validFrom: DateTime(2024, 1, 2),
  );

  final testProfile = UserProfile(
    userId: ownerUserId,
    username: 'TestUser',
    avatarUrl: 'https://example.com/avatar.png',
  );

  TodayFlowEntry createChoreEntry({
    required String id,
    required DateTime startDate,
    ChoreState state = ChoreState.active,
  }) {
    return TodayFlowEntry(
      id: id,
      homeId: homeId,
      name: 'Chore $id',
      startDate: startDate,
      state: state,
    );
  }

  setUp(() {
    choresRepository = _MockChoresRepository();
    profileRepository = _MockProfileRepository();
    expensesRepository = _MockExpensesRepository();
    homeRepository = _MockHomeRepository();
    moodRepository = _MockMoodRepository();
    housePulseRepository = _MockHousePulseRepository();
    onboardingRepository = _MockOnboardingRepository();
    preferenceReportsRepository = _MockPreferenceReportsRepository();
    houseNormsRepository = _MockHouseNormsRepository();
    profileUpdateNotifier = ProfileUpdateNotifier();

    when(
      () => moodRepository.isSubmittedThisWeek(any()),
    ).thenAnswer((_) async => false);
    when(
      () => moodRepository.isNpsRequired(any()),
    ).thenAnswer((_) async => false);
    when(
      () => moodRepository.getWallStatus(any()),
    ).thenAnswer((_) async => const GratitudeWallStatus(hasUnread: false));
    when(() => onboardingRepository.getTodayHints()).thenAnswer(
      (_) async => const OnboardingHints(
        activeChoreCount: 0,
        shouldPromptNotifications: false,
        shouldPromptFlatmateInviteShare: false,
        shouldPromptInviteShare: false,
      ),
    );
    when(
      () => choresRepository.listTodayFlow(
        homeId: any(named: 'homeId'),
        state: any(named: 'state'),
      ),
    ).thenAnswer((_) async => const <TodayFlowEntry>[]);
    when(
      () => homeRepository.listActiveMembers(
        any(),
        excludeSelf: any(named: 'excludeSelf'),
      ),
    ).thenAnswer((_) async => const <HomeMemberSummary>[]);
    when(
      () => expensesRepository.listCurrentOwed(homeId: any(named: 'homeId')),
    ).thenAnswer((_) async => const <ExpenseOwedGroup>[]);
    when(
      () => expensesRepository.listCreatedByMe(homeId: any(named: 'homeId')),
    ).thenAnswer((_) async => const <ExpenseCreatedSummary>[]);
    when(
      () =>
          expensesRepository.listPaidToMeDebtors(homeId: any(named: 'homeId')),
    ).thenAnswer((_) async => const <ExpensePaidToMeDebtor>[]);
    when(
      () => profileRepository.getCurrentProfile(),
    ).thenAnswer((_) async => null);
    when(
      () => preferenceReportsRepository.getTemplateResolution(
        templateKey: any(named: 'templateKey'),
      ),
    ).thenAnswer(
      (_) async => const PreferenceTemplateResolution(
        templateKey: 'personal_preferences_v1',
        requestedLocale: 'en',
        resolvedLocale: 'en',
      ),
    );
    when(
      () => preferenceReportsRepository.getReportForHome(
        homeId: any(named: 'homeId'),
        subjectUserId: any(named: 'subjectUserId'),
        templateKey: any(named: 'templateKey'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer((_) async => null);
    when(
      () => houseNormsRepository.getForHome(
        homeId: any(named: 'homeId'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer((_) async => _buildHouseNormDocument());
    when(
      () => housePulseRepository.getWeeklyPulse(homeId: any(named: 'homeId')),
    ).thenAnswer((_) async => null);
    when(
      () => homeRepository.logShareEvent(
        feature: any(named: 'feature'),
        channel: any(named: 'channel'),
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => homeRepository.dismissMemberCapJoinRequests(
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() async {
    await profileUpdateNotifier.dispose();
  });

  TodayBloc buildBloc() {
    return TodayBloc(
      choresRepository: choresRepository,
      profileRepository: profileRepository,
      expensesRepository: expensesRepository,
      homeRepository: homeRepository,
      moodRepository: moodRepository,
      housePulseRepository: housePulseRepository,
      onboardingRepository: onboardingRepository,
      preferenceReportsRepository: preferenceReportsRepository,
      houseNormsRepository: houseNormsRepository,
      homeId: homeId,
      profileUpdateNotifier: profileUpdateNotifier,
    );
  }

  group('TodayBloc', () {
    test('homeId getter returns the configured homeId', () {
      final bloc = buildBloc();
      expect(bloc.homeId, homeId);
      bloc.close();
    });

    group('TodayStarted', () {
      blocTest<TodayBloc, TodayState>(
        'emits loading then loaded on successful load',
        build: buildBloc,
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>().having((s) => s.isLoading, 'isLoading', true),
              isA<TodayState>()
                  .having((s) => s.isLoading, 'isLoading', false)
                  .having((s) => s.message, 'message', isNull)
                  .having((s) => s.error, 'error', isNull),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'loads active and draft tasks',
        build: () {
          final today = DateTime.now();
          when(
            () => choresRepository.listTodayFlow(
              homeId: homeId,
              state: ChoreState.active,
            ),
          ).thenAnswer(
            (_) async => [
              createChoreEntry(
                id: '1',
                startDate: today,
                state: ChoreState.active,
              ),
            ],
          );
          when(
            () => choresRepository.listTodayFlow(
              homeId: homeId,
              state: ChoreState.draft,
            ),
          ).thenAnswer(
            (_) async => [
              createChoreEntry(
                id: '2',
                startDate: today,
                state: ChoreState.draft,
              ),
            ],
          );
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>()
                  .having((s) => s.activeTasks.length, 'activeTasks', 1)
                  .having((s) => s.draftTasks.length, 'draftTasks', 1),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'resolves profile with isOwner=true when user is owner',
        build: () {
          when(
            () => profileRepository.getCurrentProfile(),
          ).thenAnswer((_) async => testProfile);
          when(
            () => homeRepository.listActiveMembers(
              any(),
              excludeSelf: any(named: 'excludeSelf'),
            ),
          ).thenAnswer((_) async => [ownerMember, regularMember]);
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>()
                  .having((s) => s.profile?.userId, 'userId', ownerUserId)
                  .having((s) => s.profile?.isOwner, 'isOwner', true),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'sets shouldPromptHouseNorms when owner has no house norms document',
        build: () {
          when(
            () => profileRepository.getCurrentProfile(),
          ).thenAnswer((_) async => testProfile);
          when(
            () => homeRepository.listActiveMembers(
              any(),
              excludeSelf: any(named: 'excludeSelf'),
            ),
          ).thenAnswer((_) async => [ownerMember, regularMember]);
          when(
            () => houseNormsRepository.getForHome(
              homeId: any(named: 'homeId'),
              locale: any(named: 'locale'),
            ),
          ).thenAnswer((_) async => null);
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>().having(
                (s) => s.shouldPromptHouseNorms,
                'shouldPromptHouseNorms',
                true,
              ),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'resolves profile with isOwner=false when user is not owner',
        build: () {
          when(() => profileRepository.getCurrentProfile()).thenAnswer(
            (_) async => UserProfile(userId: memberUserId, username: 'Member'),
          );
          when(
            () => homeRepository.listActiveMembers(
              any(),
              excludeSelf: any(named: 'excludeSelf'),
            ),
          ).thenAnswer((_) async => [ownerMember, regularMember]);
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>()
                  .having((s) => s.profile?.userId, 'userId', memberUserId)
                  .having((s) => s.profile?.isOwner, 'isOwner', false),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'keeps shouldPromptHouseNorms false for non-owner',
        build: () {
          when(() => profileRepository.getCurrentProfile()).thenAnswer(
            (_) async => UserProfile(userId: memberUserId, username: 'Member'),
          );
          when(
            () => homeRepository.listActiveMembers(
              any(),
              excludeSelf: any(named: 'excludeSelf'),
            ),
          ).thenAnswer((_) async => [ownerMember, regularMember]);
          when(
            () => houseNormsRepository.getForHome(
              homeId: any(named: 'homeId'),
              locale: any(named: 'locale'),
            ),
          ).thenAnswer((_) async => null);
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>().having(
                (s) => s.shouldPromptHouseNorms,
                'shouldPromptHouseNorms',
                false,
              ),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'sets harmonyPromptTick when mood not submitted and not shown',
        build: () {
          when(
            () => moodRepository.isSubmittedThisWeek(any()),
          ).thenAnswer((_) async => false);
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>()
                  .having((s) => s.harmonyPromptTick, 'harmonyPromptTick', 1)
                  .having((s) => s.hasShownHarmonyPrompt, 'hasShown', true),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'does not increment harmonyPromptTick when mood already submitted',
        build: () {
          when(
            () => moodRepository.isSubmittedThisWeek(any()),
          ).thenAnswer((_) async => true);
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>().having(
                (s) => s.harmonyPromptTick,
                'harmonyPromptTick',
                0,
              ),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'sets npsPromptTick when NPS is required',
        build: () {
          when(
            () => moodRepository.isNpsRequired(any()),
          ).thenAnswer((_) async => true);
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>()
                  .having((s) => s.npsPromptTick, 'npsPromptTick', 1)
                  .having((s) => s.hasShownNpsPrompt, 'hasShown', true),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'loads onboarding hints (notification prompt, flatmate invite)',
        build: () {
          when(() => onboardingRepository.getTodayHints()).thenAnswer(
            (_) async => const OnboardingHints(
              activeChoreCount: 5,
              shouldPromptNotifications: true,
              shouldPromptFlatmateInviteShare: true,
              shouldPromptInviteShare: true,
            ),
          );
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>()
                  .having((s) => s.activeChoreCount, 'activeChoreCount', 5)
                  .having(
                    (s) => s.shouldPromptFlatmateInviteShare,
                    'flatmate',
                    true,
                  )
                  .having((s) => s.shouldPromptInviteShare, 'invite', true)
                  .having(
                    (s) => s.notificationPromptTick,
                    'notificationTick',
                    1,
                  ),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'loads share snapshot with owed, paid, and drafts',
        build: () {
          when(
            () => expensesRepository.listCurrentOwed(homeId: homeId),
          ).thenAnswer(
            (_) async => [
              const ExpenseOwedGroup(
                payerUserId: memberUserId,
                payerDisplay: 'Member',
                totalOwedCents: 10000,
                items: [],
              ),
            ],
          );
          when(
            () => expensesRepository.listPaidToMeDebtors(homeId: homeId),
          ).thenAnswer(
            (_) async => [
              ExpensePaidToMeDebtor(
                debtorUserId: memberUserId,
                debtorUsername: 'Member',
                totalPaidCents: 5000,
                unseenCount: 0,
                latestPaidAt: DateTime(2024, 1, 1),
              ),
            ],
          );
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>()
                  .having((s) => s.shareOwed.length, 'shareOwed', 1)
                  .having((s) => s.sharePaidToMe.length, 'sharePaidToMe', 1),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'loads gratitude wall status',
        build: () {
          when(() => moodRepository.getWallStatus(any())).thenAnswer(
            (_) async => GratitudeWallStatus(
              hasUnread: true,
              lastReadAt: DateTime(2024, 1, 1),
            ),
          );
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>()
                  .having(
                    (s) => s.gratitudeStatus?.hasUnread,
                    'hasUnread',
                    true,
                  )
                  .having((s) => s.hasGratitudeUnread, 'getter', true),
            ],
      );
    });

    group('TodayRefreshed', () {
      blocTest<TodayBloc, TodayState>(
        'refresh reloads data without showing loading indicator',
        build: buildBloc,
        act: (bloc) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          bloc.add(const TodayRefreshed());
        },
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verify(
            () => choresRepository.listTodayFlow(
              homeId: homeId,
              state: ChoreState.active,
            ),
          ).called(2);
        },
      );

      blocTest<TodayBloc, TodayState>(
        'reloads data on refresh',
        build: () {
          when(
            () => choresRepository.listTodayFlow(
              homeId: any(named: 'homeId'),
              state: any(named: 'state'),
            ),
          ).thenAnswer((_) async => []);
          return buildBloc();
        },
        act: (bloc) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          bloc.add(const TodayRefreshed());
        },
        wait: const Duration(milliseconds: 100),
        verify: (_) {
          verify(
            () => choresRepository.listTodayFlow(
              homeId: homeId,
              state: ChoreState.active,
            ),
          ).called(2);
        },
      );
    });

    group('TodayProfileUpdated', () {
      blocTest<TodayBloc, TodayState>(
        'updates profile when notifier emits',
        build: () {
          when(
            () => profileRepository.getCurrentProfile(),
          ).thenAnswer((_) async => testProfile);
          when(
            () => homeRepository.listActiveMembers(
              any(),
              excludeSelf: any(named: 'excludeSelf'),
            ),
          ).thenAnswer((_) async => [ownerMember]);
          return buildBloc();
        },
        act: (bloc) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          profileUpdateNotifier.notify(
            UserProfile(userId: 'new-user', username: 'NewName'),
          );
        },
        wait: const Duration(milliseconds: 100),
        skip: 2,
        expect:
            () => [
              isA<TodayState>()
                  .having((s) => s.profile?.userId, 'userId', 'new-user')
                  .having((s) => s.profile?.username, 'username', 'NewName'),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'preserves isOwner from previous profile on update',
        build: () {
          when(
            () => profileRepository.getCurrentProfile(),
          ).thenAnswer((_) async => testProfile);
          when(
            () => homeRepository.listActiveMembers(
              any(),
              excludeSelf: any(named: 'excludeSelf'),
            ),
          ).thenAnswer((_) async => [ownerMember]);
          return buildBloc();
        },
        act: (bloc) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          profileUpdateNotifier.notify(
            UserProfile(
              userId: ownerUserId,
              username: 'UpdatedOwner',
              avatarUrl: 'https://new.avatar.png',
            ),
          );
        },
        wait: const Duration(milliseconds: 100),
        skip: 2,
        expect:
            () => [
              isA<TodayState>()
                  .having((s) => s.profile?.isOwner, 'isOwner', true)
                  .having(
                    (s) => s.profile?.username,
                    'username',
                    'UpdatedOwner',
                  ),
            ],
      );
    });

    group('TodayFlatmateInviteDismissed', () {
      blocTest<TodayBloc, TodayState>(
        'logs dismiss event and hides flatmate prompt',
        build: buildBloc,
        seed:
            () => const TodayState.loaded(
              activeTasks: [],
              draftTasks: [],
              shareOwed: [],
              sharePaidToMe: [],
              shareDrafts: [],
              shouldPromptFlatmateInviteShare: true,
            ),
        act: (bloc) => bloc.add(const TodayFlatmateInviteDismissed()),
        wait: const Duration(milliseconds: 50),
        skip: 2,
        expect:
            () => [
              isA<TodayState>().having(
                (s) => s.shouldPromptFlatmateInviteShare,
                'prompt',
                false,
              ),
            ],
        verify: (_) {
          verify(
            () => homeRepository.logShareEvent(
              feature: 'invite_housemate',
              channel: 'onboarding_dismiss',
              homeId: homeId,
            ),
          ).called(1);
        },
      );

      blocTest<TodayBloc, TodayState>(
        'still hides prompt even if log fails',
        build: () {
          when(
            () => homeRepository.logShareEvent(
              feature: any(named: 'feature'),
              channel: any(named: 'channel'),
              homeId: any(named: 'homeId'),
            ),
          ).thenThrow(Exception('Log failed'));
          return buildBloc();
        },
        seed:
            () => const TodayState.loaded(
              activeTasks: [],
              draftTasks: [],
              shareOwed: [],
              sharePaidToMe: [],
              shareDrafts: [],
              shouldPromptFlatmateInviteShare: true,
            ),
        act: (bloc) => bloc.add(const TodayFlatmateInviteDismissed()),
        wait: const Duration(milliseconds: 50),
        skip: 2,
        expect:
            () => [
              isA<TodayState>().having(
                (s) => s.shouldPromptFlatmateInviteShare,
                'prompt',
                false,
              ),
            ],
      );
    });

    group('TodayFlatmateInviteShareLogged', () {
      blocTest<TodayBloc, TodayState>(
        'logs share event with channel and hides flatmate prompt',
        build: buildBloc,
        seed:
            () => const TodayState.loaded(
              activeTasks: [],
              draftTasks: [],
              shareOwed: [],
              sharePaidToMe: [],
              shareDrafts: [],
              shouldPromptFlatmateInviteShare: true,
            ),
        act:
            (bloc) => bloc.add(
              const TodayFlatmateInviteShareLogged(channel: 'whatsapp'),
            ),
        wait: const Duration(milliseconds: 50),
        skip: 2,
        expect:
            () => [
              isA<TodayState>().having(
                (s) => s.shouldPromptFlatmateInviteShare,
                'prompt',
                false,
              ),
            ],
        verify: (_) {
          verify(
            () => homeRepository.logShareEvent(
              feature: 'invite_housemate',
              channel: 'whatsapp',
              homeId: homeId,
            ),
          ).called(1);
        },
      );
    });

    group('TodayInviteShareLogged', () {
      blocTest<TodayBloc, TodayState>(
        'logs share event and hides invite prompt',
        build: buildBloc,
        seed:
            () => const TodayState.loaded(
              activeTasks: [],
              draftTasks: [],
              shareOwed: [],
              sharePaidToMe: [],
              shareDrafts: [],
              shouldPromptInviteShare: true,
            ),
        act:
            (bloc) =>
                bloc.add(const TodayInviteShareLogged(channel: 'clipboard')),
        wait: const Duration(milliseconds: 50),
        skip: 2,
        expect:
            () => [
              isA<TodayState>().having(
                (s) => s.shouldPromptInviteShare,
                'prompt',
                false,
              ),
            ],
        verify: (_) {
          verify(
            () => homeRepository.logShareEvent(
              feature: 'invite_button',
              channel: 'clipboard',
              homeId: homeId,
            ),
          ).called(1);
        },
      );
    });

    group('TodayMemberCapDismissed', () {
      blocTest<TodayBloc, TodayState>(
        'dismisses member cap requests and clears prompt',
        build: buildBloc,
        seed:
            () => TodayState.loaded(
              activeTasks: const [],
              draftTasks: const [],
              shareOwed: const [],
              sharePaidToMe: const [],
              shareDrafts: const [],
              memberCapJoinRequests: const MemberCapJoinRequests(
                homeId: homeId,
                pendingCount: 2,
                joinerNames: ['Alice', 'Bob'],
                requestIds: ['req-1', 'req-2'],
              ),
            ),
        act: (bloc) => bloc.add(const TodayMemberCapDismissed()),
        wait: const Duration(milliseconds: 50),
        skip: 2,
        expect:
            () => [
              isA<TodayState>().having(
                (s) => s.memberCapJoinRequests,
                'memberCap',
                isNull,
              ),
            ],
        verify: (_) {
          verify(
            () => homeRepository.dismissMemberCapJoinRequests(homeId: homeId),
          ).called(1);
        },
      );

      blocTest<TodayBloc, TodayState>(
        'clears prompt even if dismiss call fails',
        build: () {
          when(
            () => homeRepository.dismissMemberCapJoinRequests(
              homeId: any(named: 'homeId'),
            ),
          ).thenThrow(Exception('Dismiss failed'));
          return buildBloc();
        },
        seed:
            () => TodayState.loaded(
              activeTasks: const [],
              draftTasks: const [],
              shareOwed: const [],
              sharePaidToMe: const [],
              shareDrafts: const [],
              memberCapJoinRequests: const MemberCapJoinRequests(
                homeId: homeId,
                pendingCount: 1,
                joinerNames: ['Bob'],
                requestIds: ['req-1'],
              ),
            ),
        act: (bloc) => bloc.add(const TodayMemberCapDismissed()),
        wait: const Duration(milliseconds: 50),
        skip: 2,
        expect:
            () => [
              isA<TodayState>().having(
                (s) => s.memberCapJoinRequests,
                'memberCap',
                isNull,
              ),
            ],
      );
    });

    group('TodayState helpers', () {
      test('hasFlowContent returns true when activeTasks is non-empty', () {
        const state = TodayState.loaded(
          activeTasks: [
            TodayFlowTask(id: '1', title: 'Task', state: ChoreState.active),
          ],
          draftTasks: [],
          shareOwed: [],
          sharePaidToMe: [],
          shareDrafts: [],
        );
        expect(state.hasFlowContent, isTrue);
      });

      test('hasFlowContent returns true when draftTasks is non-empty', () {
        const state = TodayState.loaded(
          activeTasks: [],
          draftTasks: [
            TodayFlowTask(id: '1', title: 'Draft', state: ChoreState.draft),
          ],
          shareOwed: [],
          sharePaidToMe: [],
          shareDrafts: [],
        );
        expect(state.hasFlowContent, isTrue);
      });

      test('hasFlowContent returns false when both lists are empty', () {
        const state = TodayState.loaded(
          activeTasks: [],
          draftTasks: [],
          shareOwed: [],
          sharePaidToMe: [],
          shareDrafts: [],
        );
        expect(state.hasFlowContent, isFalse);
      });

      test('hasShareContent returns true when shareOwed is non-empty', () {
        const state = TodayState.loaded(
          activeTasks: [],
          draftTasks: [],
          shareOwed: [
            TodayShareOwed(
              payerUserId: 'u1',
              displayName: 'User',
              totalOwedCents: 1000,
              items: [],
              isOwner: false,
            ),
          ],
          sharePaidToMe: [],
          shareDrafts: [],
        );
        expect(state.hasShareContent, isTrue);
      });

      test('isCaughtUp returns true when no content', () {
        const state = TodayState.loaded(
          activeTasks: [],
          draftTasks: [],
          shareOwed: [],
          sharePaidToMe: [],
          shareDrafts: [],
        );
        expect(state.isCaughtUp, isTrue);
      });

      test('isCaughtUp returns false when has content', () {
        const state = TodayState.loaded(
          activeTasks: [
            TodayFlowTask(id: '1', title: 'Task', state: ChoreState.active),
          ],
          draftTasks: [],
          shareOwed: [],
          sharePaidToMe: [],
          shareDrafts: [],
        );
        expect(state.isCaughtUp, isFalse);
      });
    });

    group('error handling', () {
      blocTest<TodayBloc, TodayState>(
        'keeps previous hints if onboarding RPC fails',
        build: () {
          when(
            () => onboardingRepository.getTodayHints(),
          ).thenThrow(Exception('RPC failed'));
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>().having((s) => s.isLoading, 'isLoading', true),
              isA<TodayState>()
                  .having((s) => s.isLoading, 'isLoading', false)
                  .having((s) => s.activeChoreCount, 'activeChoreCount', 0),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'uses fallback when profile fetch fails',
        build: () {
          when(
            () => profileRepository.getCurrentProfile(),
          ).thenThrow(Exception('Profile error'));
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>().having((s) => s.profile, 'profile', isNull),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'captures share error but still loads',
        build: () {
          when(
            () => expensesRepository.listCurrentOwed(
              homeId: any(named: 'homeId'),
            ),
          ).thenThrow(Exception('Share error'));
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>()
                  .having((s) => s.isLoading, 'isLoading', false)
                  .having((s) => s.shareOwed, 'shareOwed', isEmpty)
                  .having(
                    (s) => s.shareErrorMessage,
                    'error',
                    contains('Share error'),
                  ),
            ],
      );

      blocTest<TodayBloc, TodayState>(
        'uses fallback gratitude status on error',
        build: () {
          when(
            () => moodRepository.getWallStatus(any()),
          ).thenThrow(Exception('Wall status error'));
          return buildBloc();
        },
        wait: const Duration(milliseconds: 50),
        expect:
            () => [
              isA<TodayState>(),
              isA<TodayState>()
                  .having((s) => s.isLoading, 'isLoading', false)
                  .having(
                    (s) => s.gratitudeStatus,
                    'gratitudeStatus',
                    anyOf(
                      isNull,
                      isA<GratitudeWallStatus>().having(
                        (g) => g.hasUnread,
                        'hasUnread',
                        false,
                      ),
                    ),
                  ),
            ],
      );
    });
  });

  group('TodayEvent props equality', () {
    test('TodayStarted equality', () {
      expect(const TodayStarted(), equals(const TodayStarted()));
      expect(const TodayStarted().props, isEmpty);
    });

    test('TodayRefreshed equality', () {
      expect(const TodayRefreshed(), equals(const TodayRefreshed()));
      expect(const TodayRefreshed().props, isEmpty);
    });

    test('TodayProfileUpdated equality', () {
      final profile = UserProfile(
        userId: 'user-1',
        username: 'Test User',
        avatarUrl: null,
      );
      final profile2 = UserProfile(
        userId: 'user-2',
        username: 'Other User',
        avatarUrl: null,
      );
      final e1 = TodayProfileUpdated(profile);
      final e2 = TodayProfileUpdated(profile);
      final e3 = TodayProfileUpdated(profile2);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals([profile]));
    });

    test('TodayFlatmateInviteDismissed equality', () {
      expect(
        const TodayFlatmateInviteDismissed(),
        equals(const TodayFlatmateInviteDismissed()),
      );
      expect(const TodayFlatmateInviteDismissed().props, isEmpty);
    });

    test('TodayFlatmateInviteShareLogged equality', () {
      const e1 = TodayFlatmateInviteShareLogged(channel: 'whatsapp');
      const e2 = TodayFlatmateInviteShareLogged(channel: 'whatsapp');
      const e3 = TodayFlatmateInviteShareLogged(channel: 'sms');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['whatsapp']));
    });

    test('TodayInviteShareLogged equality', () {
      const e1 = TodayInviteShareLogged(channel: 'whatsapp');
      const e2 = TodayInviteShareLogged(channel: 'whatsapp');
      const e3 = TodayInviteShareLogged(channel: 'sms');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['whatsapp']));
    });

    test('TodayMemberCapDismissed equality', () {
      expect(
        const TodayMemberCapDismissed(),
        equals(const TodayMemberCapDismissed()),
      );
      expect(const TodayMemberCapDismissed().props, isEmpty);
    });
  });
}

HouseNormDocument _buildHouseNormDocument() {
  return HouseNormDocument(
    homeId: 'home-1',
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
          text: 'We try to wind down.',
        ),
      ],
    ),
    publishedAt: DateTime.utc(2026, 1, 1),
    publishedVersion: 'v1',
    isPublished: true,
    hasUnpublishedChanges: false,
    lastEditedAt: null,
    lastEditedBy: null,
    homePublicId: 'home_public_1',
    publicUrl: 'https://go.makinglifeeasie.com/norms/home_public_1',
    showPublishButton: false,
    showRepublishButton: false,
    showPublicUrl: true,
  );
}
