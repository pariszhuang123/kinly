import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/foundation/surfaces/today/bloc/today_bloc.dart';
import 'package:kinly/features/flow/flow.dart';
import 'package:kinly/features/share/share.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/features/harmony/harmony.dart';
import 'package:kinly/contracts/onboarding/ports/onboarding_repository.dart';
import 'package:kinly/core/notifications/profile_update_notifier.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/contracts/onboarding/ports/onboarding_repository.dart'
    as onboarding;
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/mood/ports/house_pulse_repository.dart';

class _MockChoresRepository extends Mock implements ChoresRepository {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockMoodRepository extends Mock implements MoodRepository {}

class _MockHousePulseRepository extends Mock implements HousePulseRepository {}

class _MockOnboardingRepository extends Mock implements OnboardingRepository {}

class _MockPreferenceReportsRepository extends Mock
    implements PreferenceReportsRepository {}

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
  late ProfileUpdateNotifier profileUpdateNotifier;

  setUp(() {
    choresRepository = _MockChoresRepository();
    profileRepository = _MockProfileRepository();
    expensesRepository = _MockExpensesRepository();
    homeRepository = _MockHomeRepository();
    moodRepository = _MockMoodRepository();
    housePulseRepository = _MockHousePulseRepository();
    onboardingRepository = _MockOnboardingRepository();
    preferenceReportsRepository = _MockPreferenceReportsRepository();
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
      (_) async => const onboarding.OnboardingHints(
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
      () => profileRepository.getCurrentProfile(),
    ).thenAnswer((_) async => null);
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
      homeId: 'home-1',
      profileUpdateNotifier: profileUpdateNotifier,
    );
  }

  blocTest<TodayBloc, TodayState>(
    'emits failure when chores repository throws',
    build: () {
      when(
        () => choresRepository.listTodayFlow(
          homeId: any(named: 'homeId'),
          state: any(named: 'state'),
        ),
      ).thenThrow(Exception('boom'));
      return buildBloc();
    },
    wait: const Duration(milliseconds: 10),
    expect:
        () => [
          isA<TodayState>().having((s) => s.isLoading, 'loading', true),
          isA<TodayState>().having(
            (s) => s.message,
            'message',
            contains("Could not load today's chores"),
          ),
        ],
  );
}
