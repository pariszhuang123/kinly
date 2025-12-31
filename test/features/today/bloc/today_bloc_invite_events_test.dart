import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/today/bloc/today_bloc.dart';
import 'package:kinly/features/flow/flow.dart';
import 'package:kinly/data/repositories/expenses_repository.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/data/repositories/profile_repository.dart';
import 'package:kinly/data/repositories/mood_repository.dart';
import 'package:kinly/core/onboarding/onboarding.dart';
import 'package:kinly/core/profile/profile_update_notifier.dart';
import 'package:kinly/core/mood/models.dart';
import 'package:kinly/core/chores/models.dart';
import 'package:kinly/core/expenses/models.dart';
import 'package:kinly/core/onboarding/onboarding.dart' as onboarding;
import 'package:kinly/core/homes/models.dart';

class _MockChoresRepository extends Mock implements ChoresRepository {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockMoodRepository extends Mock implements MoodRepository {}

class _MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(ChoreState.active);
  });

  late _MockChoresRepository choresRepository;
  late _MockProfileRepository profileRepository;
  late _MockExpensesRepository expensesRepository;
  late _MockHomeRepository homeRepository;
  late _MockMoodRepository moodRepository;
  late _MockOnboardingRepository onboardingRepository;
  late ProfileUpdateNotifier profileUpdateNotifier;

  setUp(() {
    choresRepository = _MockChoresRepository();
    profileRepository = _MockProfileRepository();
    expensesRepository = _MockExpensesRepository();
    homeRepository = _MockHomeRepository();
    moodRepository = _MockMoodRepository();
    onboardingRepository = _MockOnboardingRepository();
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
        shouldPromptFlatmateInviteShare: true,
        shouldPromptInviteShare: true,
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
      onboardingRepository: onboardingRepository,
      homeId: 'home-1',
      profileUpdateNotifier: profileUpdateNotifier,
    );
  }

  blocTest<TodayBloc, TodayState>(
    'dismiss flatmate invite logs and clears prompt',
    build: buildBloc,
    wait: const Duration(milliseconds: 10),
    skip: 2, // skip initial loading + loaded
    act: (bloc) async {
      // Wait for initial load to complete
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const TodayFlatmateInviteDismissed());
    },
    expect:
        () => [
          isA<TodayState>().having(
            (s) => s.shouldPromptFlatmateInviteShare,
            'shouldPromptFlatmateInviteShare',
            false,
          ),
        ],
    verify: (_) {
      verify(
        () => homeRepository.logShareEvent(
          feature: 'invite_housemate',
          channel: 'onboarding_dismiss',
          homeId: 'home-1',
        ),
      ).called(1);
    },
  );

  blocTest<TodayBloc, TodayState>(
    'logging invite share clears generic invite prompt',
    build: buildBloc,
    wait: const Duration(milliseconds: 10),
    skip: 2,
    act: (bloc) async {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const TodayInviteShareLogged(channel: 'copy_link'));
    },
    expect:
        () => [
          isA<TodayState>().having(
            (s) => s.shouldPromptInviteShare,
            'shouldPromptInviteShare',
            false,
          ),
        ],
    verify: (_) {
      verify(
        () => homeRepository.logShareEvent(
          feature: 'invite_button',
          channel: 'copy_link',
          homeId: 'home-1',
        ),
      ).called(1);
    },
  );
}
