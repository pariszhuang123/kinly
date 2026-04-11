import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/contracts/profile/models.dart';
import 'package:kinly/contracts/account/ports/account_repository.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/foundation/surfaces/profile/bloc/profile_settings_bloc.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockHomeUnitsRepository extends Mock implements HomeUnitsRepository {}

class _MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late _MockProfileRepository profileRepository;
  late _MockHomeRepository homeRepository;
  late _MockHomeUnitsRepository homeUnitsRepository;
  late _MockAccountRepository accountRepository;
  final currentMembership = CurrentMembership(
    membershipId: 'membership-1',
    userId: 'user-1',
    homeId: 'home-1',
    role: 'member',
    validFrom: DateTime(2024, 1, 1),
  );

  ProfileSettingsBloc buildBloc({ProfileSettingsUser? initialUser}) {
    return ProfileSettingsBloc(
      profileRepository: profileRepository,
      homeRepository: homeRepository,
      homeUnitsRepository: homeUnitsRepository,
      accountRepository: accountRepository,
      homeId: 'home-1',
      initialUser: initialUser,
    );
  }

  setUp(() {
    profileRepository = _MockProfileRepository();
    homeRepository = _MockHomeRepository();
    homeUnitsRepository = _MockHomeUnitsRepository();
    accountRepository = _MockAccountRepository();
    when(
      () => homeRepository.getCurrentMembership(),
    ).thenAnswer((_) async => currentMembership);
    when(
      () => homeRepository.listActiveMembers(
        any(),
        excludeSelf: any(named: 'excludeSelf'),
      ),
    ).thenAnswer((_) async => const <HomeMemberSummary>[]);
    when(
      () => homeRepository.kickMember(
        homeId: any(named: 'homeId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => {});
    when(
      () => homeUnitsRepository.getMyUnitContext(homeId: any(named: 'homeId')),
    ).thenAnswer(
      (_) async => HomeUnitContext(
        personalUnit: const HomeUnitSummary(
          unitId: 'unit-personal',
          homeId: 'home-1',
          name: 'Personal',
          unitType: HomeUnitType.personal,
          memberUserIds: <String>['user-1'],
        ),
        activeSharedUnit: null,
        allowedShoppingScopes: const <ShoppingItemScopeType>[],
      ),
    );
    when(
      () => homeUnitsRepository.listCreateSharedUnitCandidates(
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async => const <HomeUnitMemberCandidate>[]);
    when(
      () => homeUnitsRepository.listJoinableSharedUnits(
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async => const <HomeUnitSummary>[]);
  });

  group('ProfileSettingsBloc', () {
    const userProfile = UserProfile(
      userId: 'user-1',
      username: 'Avery',
      avatarUrl: 'https://example.com/avatar.png',
      avatarStoragePath: 'avatars/avery.svg',
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'loads profile on start',
      build: () {
        when(
          () => profileRepository.getCurrentProfile(),
        ).thenAnswer((_) async => userProfile);
        when(
          () => homeRepository.listActiveMembers(any()),
        ).thenAnswer((_) async => const <HomeMemberSummary>[]);
        when(
          () => homeRepository.getPlanStatus(),
        ).thenAnswer((_) async => PlanStatus.free);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileSettingsStarted()),
      expect: () {
        final initial = ProfileSettingsState.initial();
        final loading = initial.copyWith(
          isLoadingUser: true,
          leaveEligibilityLoading: true,
          homeUnitsLoading: true,
          leaveEligibilityError: null,
          homeUnitsError: null,
        );
        final loaded = loading.copyWith(
          isLoadingUser: false,
          user: ProfileSettingsUser(
            displayName: userProfile.username,
            avatarUrl: userProfile.avatarUrl,
            avatarStoragePath: userProfile.avatarStoragePath,
          ),
        );
        final leaveReady = loaded.copyWith(
          leaveEligibilityLoading: false,
          leaveEligibilityError: null,
          membership: currentMembership,
          activeMembers: const <HomeMemberSummary>[],
        );
        final unitsReady = leaveReady.copyWith(
          homeUnitsLoading: false,
          homeUnitsError: null,
          homeUnitContext: HomeUnitContext(
            personalUnit: const HomeUnitSummary(
              unitId: 'unit-personal',
              homeId: 'home-1',
              name: 'Personal',
              unitType: HomeUnitType.personal,
              memberUserIds: <String>['user-1'],
            ),
            activeSharedUnit: null,
            allowedShoppingScopes: const <ShoppingItemScopeType>[],
          ),
          sharedUnitCreateCandidates: const <HomeUnitMemberCandidate>[],
          joinableSharedUnits: const <HomeUnitSummary>[],
        );
        final planLoading = unitsReady.copyWith(
          planStatusLoading: true,
          planStatus: PlanStatus.unknown,
        );
        final planReady = planLoading.copyWith(
          planStatusLoading: false,
          planStatus: PlanStatus.free,
        );
        return [loading, loaded, leaveReady, unitsReady, planLoading, planReady];
      },
      verify: (_) {
        verify(() => profileRepository.getCurrentProfile()).called(1);
        verify(() => homeRepository.getCurrentMembership()).called(1);
        verify(() => homeRepository.listActiveMembers(any())).called(1);
        verify(() => homeUnitsRepository.getMyUnitContext(homeId: 'home-1'))
            .called(1);
        verify(
          () => homeUnitsRepository.listCreateSharedUnitCandidates(
            homeId: 'home-1',
          ),
        ).called(1);
        verify(
          () => homeUnitsRepository.listJoinableSharedUnits(homeId: 'home-1'),
        ).called(1);
        verify(() => homeRepository.getPlanStatus()).called(1);
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'exposes shared unit create candidates when eligible members exist',
      build: () {
        when(
          () => profileRepository.getCurrentProfile(),
        ).thenAnswer((_) async => userProfile);
        when(
          () => homeRepository.listActiveMembers(any()),
        ).thenAnswer((_) async => const <HomeMemberSummary>[]);
        when(
          () => homeRepository.getPlanStatus(),
        ).thenAnswer((_) async => PlanStatus.free);
        when(
          () => homeUnitsRepository.listCreateSharedUnitCandidates(
            homeId: any(named: 'homeId'),
          ),
        ).thenAnswer(
          (_) async => const <HomeUnitMemberCandidate>[
            HomeUnitMemberCandidate(
              membershipId: 'membership-2',
              userId: 'user-2',
              displayName: 'Sam',
            ),
          ],
        );
        when(
          () => homeUnitsRepository.listJoinableSharedUnits(
            homeId: any(named: 'homeId'),
          ),
        ).thenAnswer((_) async => const <HomeUnitSummary>[]);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileSettingsStarted()),
      verify: (bloc) {
        expect(bloc.state.canCreateSharedUnit, isTrue);
        expect(bloc.state.sharedUnitCreateCandidates, hasLength(1));
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'exposes joinable shared units when available',
      build: () {
        when(
          () => profileRepository.getCurrentProfile(),
        ).thenAnswer((_) async => userProfile);
        when(
          () => homeRepository.listActiveMembers(any()),
        ).thenAnswer((_) async => const <HomeMemberSummary>[]);
        when(
          () => homeRepository.getPlanStatus(),
        ).thenAnswer((_) async => PlanStatus.free);
        when(
          () => homeUnitsRepository.listJoinableSharedUnits(
            homeId: any(named: 'homeId'),
          ),
        ).thenAnswer(
          (_) async => const <HomeUnitSummary>[
            HomeUnitSummary(
              unitId: 'unit-shared',
              homeId: 'home-1',
              name: 'Alex + Sam',
              unitType: HomeUnitType.shared,
              memberUserIds: <String>['user-2', 'user-3'],
            ),
          ],
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileSettingsStarted()),
      verify: (bloc) {
        expect(bloc.state.canJoinSharedUnit, isTrue);
        expect(bloc.state.joinableSharedUnits, hasLength(1));
        expect(bloc.state.joinableSharedUnits.single.name, 'Alex + Sam');
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits success after leaving home',
      build: () {
        when(
          () => homeRepository.leave(homeId: any(named: 'homeId')),
        ).thenAnswer(
          (_) async => const LeaveResult(
            outcome: LeaveOutcome.leftOk,
            homeDeactivated: false,
            membersRemaining: 1,
            roleBefore: 'member',
          ),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileSettingsLeaveRequested()),
      expect: () {
        final progress = ProfileSettingsState.initial().copyWith(
          leaveInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final success = progress.copyWith(
          leaveInProgress: false,
          action: ProfileSettingsAction.leaveSuccess,
        );
        return [progress, success];
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits success after kicking a member',
      build: () => buildBloc(),
      act:
          (bloc) =>
              bloc.add(const ProfileSettingsKickMemberRequested('user-2')),
      expect: () {
        final initial = ProfileSettingsState.initial();
        final progress = initial.copyWith(
          kickInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final success = progress.copyWith(
          kickInProgress: false,
          action: ProfileSettingsAction.kickSuccess,
        );
        final reloading = success.copyWith(
          leaveEligibilityLoading: true,
          homeUnitsLoading: true,
          leaveEligibilityError: null,
          homeUnitsError: null,
        );
        final leaveRefreshed = reloading.copyWith(
          leaveEligibilityLoading: false,
          leaveEligibilityError: null,
          membership: currentMembership,
          activeMembers: const <HomeMemberSummary>[],
        );
        final unitsRefreshed = leaveRefreshed.copyWith(
          homeUnitsLoading: false,
          homeUnitsError: null,
          homeUnitContext: HomeUnitContext(
            personalUnit: const HomeUnitSummary(
              unitId: 'unit-personal',
              homeId: 'home-1',
              name: 'Personal',
              unitType: HomeUnitType.personal,
              memberUserIds: <String>['user-1'],
            ),
            activeSharedUnit: null,
            allowedShoppingScopes: const <ShoppingItemScopeType>[],
          ),
          sharedUnitCreateCandidates: const <HomeUnitMemberCandidate>[],
          joinableSharedUnits: const <HomeUnitSummary>[],
        );
        return [progress, success, reloading, leaveRefreshed, unitsRefreshed];
      },
      verify: (_) {
        verify(
          () => homeRepository.kickMember(homeId: 'home-1', userId: 'user-2'),
        ).called(1);
        verify(() => homeRepository.getCurrentMembership()).called(1);
        verify(() => homeRepository.listActiveMembers('home-1')).called(1);
        verify(() => homeUnitsRepository.getMyUnitContext(homeId: 'home-1'))
            .called(1);
        verify(
          () => homeUnitsRepository.listJoinableSharedUnits(homeId: 'home-1'),
        ).called(1);
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits failure when kicking a member fails',
      build: () {
        when(
          () => homeRepository.kickMember(
            homeId: any(named: 'homeId'),
            userId: any(named: 'userId'),
          ),
        ).thenThrow(Exception('kick failed'));
        return buildBloc();
      },
      act:
          (bloc) =>
              bloc.add(const ProfileSettingsKickMemberRequested('user-3')),
      expect: () {
        final initial = ProfileSettingsState.initial();
        final progress = initial.copyWith(
          kickInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final failure = progress.copyWith(
          kickInProgress: false,
          action: ProfileSettingsAction.kickFailure,
          actionMessage: 'Exception: kick failed',
        );
        return [progress, failure];
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits failure when leaving home fails',
      build: () {
        when(
          () => homeRepository.leave(homeId: any(named: 'homeId')),
        ).thenThrow(Exception('leave failed'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileSettingsLeaveRequested()),
      expect: () {
        final progress = ProfileSettingsState.initial().copyWith(
          leaveInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final failure = progress.copyWith(
          leaveInProgress: false,
          action: ProfileSettingsAction.leaveFailure,
          actionMessage: 'Exception: leave failed',
        );
        return [progress, failure];
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits success after deleting account',
      build: () {
        when(
          () => accountRepository.deleteAccount(),
        ).thenAnswer((_) async => {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileSettingsDeleteRequested()),
      expect: () {
        final progress = ProfileSettingsState.initial().copyWith(
          deleteInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final success = progress.copyWith(
          deleteInProgress: false,
          action: ProfileSettingsAction.deleteSuccess,
        );
        return [progress, success];
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits failure when delete account fails',
      build: () {
        when(
          () => accountRepository.deleteAccount(),
        ).thenThrow(Exception('delete failed'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileSettingsDeleteRequested()),
      expect: () {
        final progress = ProfileSettingsState.initial().copyWith(
          deleteInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final failure = progress.copyWith(
          deleteInProgress: false,
          action: ProfileSettingsAction.deleteFailure,
          actionMessage: 'Exception: delete failed',
        );
        return [progress, failure];
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits leave success after transferring ownership',
      build: () {
        when(
          () => homeRepository.transferOwner(
            homeId: any(named: 'homeId'),
            newOwnerId: any(named: 'newOwnerId'),
          ),
        ).thenAnswer((_) async => {});
        when(
          () => homeRepository.leave(homeId: any(named: 'homeId')),
        ).thenAnswer(
          (_) async => const LeaveResult(
            outcome: LeaveOutcome.leftOk,
            homeDeactivated: false,
            membersRemaining: 2,
            roleBefore: 'owner',
          ),
        );
        return buildBloc();
      },
      act:
          (bloc) =>
              bloc.add(const ProfileSettingsTransferOwnerRequested('user-2')),
      expect: () {
        final initial = ProfileSettingsState.initial();
        final transferProgress = initial.copyWith(
          transferInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final transferSuccess = transferProgress.copyWith(
          transferInProgress: false,
          action: ProfileSettingsAction.transferSuccess,
        );
        final leaveProgress = transferSuccess.copyWith(
          leaveInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final leaveSuccess = leaveProgress.copyWith(
          leaveInProgress: false,
          action: ProfileSettingsAction.leaveSuccess,
        );
        return [transferProgress, transferSuccess, leaveProgress, leaveSuccess];
      },
      verify: (_) {
        verify(
          () => homeRepository.transferOwner(
            homeId: 'home-1',
            newOwnerId: 'user-2',
          ),
        ).called(1);
        verify(() => homeRepository.leave(homeId: 'home-1')).called(1);
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits failure when transferring ownership fails',
      build: () {
        when(
          () => homeRepository.transferOwner(
            homeId: any(named: 'homeId'),
            newOwnerId: any(named: 'newOwnerId'),
          ),
        ).thenThrow(Exception('transfer failed'));
        return buildBloc();
      },
      act:
          (bloc) =>
              bloc.add(const ProfileSettingsTransferOwnerRequested('user-3')),
      expect: () {
        final initial = ProfileSettingsState.initial();
        final transferProgress = initial.copyWith(
          transferInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final transferFailure = transferProgress.copyWith(
          transferInProgress: false,
          action: ProfileSettingsAction.transferFailure,
          actionMessage: 'Exception: transfer failed',
        );
        return [transferProgress, transferFailure];
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'updates user when ProfileSettingsUserUpdated is received',
      build: buildBloc,
      act: (bloc) {
        const updated = ProfileSettingsUser(
          displayName: 'Taylor',
          avatarUrl: 'https://example.com/taylor.svg',
          avatarStoragePath: 'avatars/taylor.svg',
        );
        bloc.add(const ProfileSettingsUserUpdated(updated));
      },
      expect: () {
        final initial = ProfileSettingsState.initial();
        final updatedState = initial.copyWith(
          user: const ProfileSettingsUser(
            displayName: 'Taylor',
            avatarUrl: 'https://example.com/taylor.svg',
            avatarStoragePath: 'avatars/taylor.svg',
          ),
        );
        return [updatedState];
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits success after leaving shared unit',
      build: () {
        when(
          () => homeUnitsRepository.leaveSharedUnit(unitId: any(named: 'unitId')),
        ).thenAnswer((_) async => 'unit-shared');
        return buildBloc();
      },
      act:
          (bloc) => bloc.add(
            const ProfileSettingsSharedUnitLeaveRequested('unit-shared'),
          ),
      expect: () {
        final initial = ProfileSettingsState.initial();
        final progress = initial.copyWith(
          sharedUnitLeaveInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final success = progress.copyWith(
          sharedUnitLeaveInProgress: false,
          action: ProfileSettingsAction.sharedUnitLeaveSuccess,
        );
        final reloading = success.copyWith(
          homeUnitsLoading: true,
          homeUnitsError: null,
        );
        final refreshed = reloading.copyWith(
          homeUnitsLoading: false,
          homeUnitsError: null,
          homeUnitContext: HomeUnitContext(
            personalUnit: const HomeUnitSummary(
              unitId: 'unit-personal',
              homeId: 'home-1',
              name: 'Personal',
              unitType: HomeUnitType.personal,
              memberUserIds: <String>['user-1'],
            ),
            activeSharedUnit: null,
            allowedShoppingScopes: const <ShoppingItemScopeType>[],
          ),
          sharedUnitCreateCandidates: const <HomeUnitMemberCandidate>[],
          joinableSharedUnits: const <HomeUnitSummary>[],
        );
        return [progress, success, reloading, refreshed];
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits failure after leaving shared unit fails',
      build: () {
        when(
          () => homeUnitsRepository.leaveSharedUnit(unitId: any(named: 'unitId')),
        ).thenThrow(Exception('shared leave failed'));
        return buildBloc();
      },
      act:
          (bloc) => bloc.add(
            const ProfileSettingsSharedUnitLeaveRequested('unit-shared'),
          ),
      expect: () {
        final initial = ProfileSettingsState.initial();
        final progress = initial.copyWith(
          sharedUnitLeaveInProgress: true,
          action: ProfileSettingsAction.none,
          actionMessage: null,
        );
        final failure = progress.copyWith(
          sharedUnitLeaveInProgress: false,
          action: ProfileSettingsAction.sharedUnitLeaveFailure,
          actionMessage: 'Exception: shared leave failed',
        );
        return [progress, failure];
      },
    );
  });

  group('ProfileSettingsEvent props equality', () {
    test('ProfileSettingsStarted equality', () {
      expect(
        const ProfileSettingsStarted(),
        equals(const ProfileSettingsStarted()),
      );
      expect(const ProfileSettingsStarted().props, isEmpty);
    });

    test('ProfileSettingsLeaveRequested equality', () {
      expect(
        const ProfileSettingsLeaveRequested(),
        equals(const ProfileSettingsLeaveRequested()),
      );
      expect(const ProfileSettingsLeaveRequested().props, isEmpty);
    });

    test('ProfileSettingsTransferOwnerRequested equality', () {
      const e1 = ProfileSettingsTransferOwnerRequested('user-a');
      const e2 = ProfileSettingsTransferOwnerRequested('user-a');
      const e3 = ProfileSettingsTransferOwnerRequested('user-b');
      const e4 = ProfileSettingsTransferOwnerRequested(
        'user-a',
        followUp: TransferFollowUp.delete,
      );
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1, isNot(equals(e4)));
      expect(e1.props, equals(['user-a', TransferFollowUp.leave]));
      expect(e4.props, equals(['user-a', TransferFollowUp.delete]));
    });

    test('ProfileSettingsKickMemberRequested equality', () {
      const e1 = ProfileSettingsKickMemberRequested('user-a');
      const e2 = ProfileSettingsKickMemberRequested('user-a');
      const e3 = ProfileSettingsKickMemberRequested('user-b');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['user-a']));
    });

    test('ProfileSettingsDeleteRequested equality', () {
      expect(
        const ProfileSettingsDeleteRequested(),
        equals(const ProfileSettingsDeleteRequested()),
      );
      expect(const ProfileSettingsDeleteRequested().props, isEmpty);
    });

    test('ProfileSettingsSharedUnitLeaveRequested equality', () {
      const e1 = ProfileSettingsSharedUnitLeaveRequested('unit-a');
      const e2 = ProfileSettingsSharedUnitLeaveRequested('unit-a');
      const e3 = ProfileSettingsSharedUnitLeaveRequested('unit-b');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['unit-a']));
    });

    test('ProfileSettingsActionCleared equality', () {
      expect(
        const ProfileSettingsActionCleared(),
        equals(const ProfileSettingsActionCleared()),
      );
      expect(const ProfileSettingsActionCleared().props, isEmpty);
    });

    test('ProfileSettingsUserUpdated equality', () {
      const user1 = ProfileSettingsUser(
        displayName: 'Avery',
        avatarUrl: 'https://example.com/a.png',
        avatarStoragePath: 'avatars/a.svg',
      );
      const user2 = ProfileSettingsUser(
        displayName: 'Avery',
        avatarUrl: 'https://example.com/a.png',
        avatarStoragePath: 'avatars/a.svg',
      );
      const user3 = ProfileSettingsUser(
        displayName: 'Taylor',
        avatarUrl: 'https://example.com/t.png',
        avatarStoragePath: 'avatars/t.svg',
      );
      const e1 = ProfileSettingsUserUpdated(user1);
      const e2 = ProfileSettingsUserUpdated(user2);
      const e3 = ProfileSettingsUserUpdated(user3);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals([user1]));
    });
  });
}
