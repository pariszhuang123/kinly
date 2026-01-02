import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/profile/models.dart';
import 'package:kinly/contracts/account/ports/account_repository.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/foundation/surfaces/profile/bloc/profile_settings_bloc.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late _MockProfileRepository profileRepository;
  late _MockHomeRepository homeRepository;
  late _MockAccountRepository accountRepository;
  final currentMembership = CurrentMembership(
    userId: 'user-1',
    homeId: 'home-1',
    role: 'member',
    validFrom: DateTime(2024, 1, 1),
  );

  ProfileSettingsBloc buildBloc({ProfileSettingsUser? initialUser}) {
    return ProfileSettingsBloc(
      profileRepository: profileRepository,
      homeRepository: homeRepository,
      accountRepository: accountRepository,
      homeId: 'home-1',
      initialUser: initialUser,
    );
  }

  setUp(() {
    profileRepository = _MockProfileRepository();
    homeRepository = _MockHomeRepository();
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
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileSettingsStarted()),
      expect: () {
        final initial = ProfileSettingsState.initial();
        final loading = initial.copyWith(
          isLoadingUser: true,
          leaveEligibilityLoading: true,
          leaveEligibilityError: null,
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
        return [loading, loaded, leaveReady];
      },
      verify: (_) {
        verify(() => profileRepository.getCurrentProfile()).called(1);
        verify(() => homeRepository.getCurrentMembership()).called(1);
        verify(() => homeRepository.listActiveMembers(any())).called(1);
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
          leaveEligibilityError: null,
        );
        final refreshed = reloading.copyWith(
          leaveEligibilityLoading: false,
          leaveEligibilityError: null,
          membership: currentMembership,
          activeMembers: const <HomeMemberSummary>[],
        );
        return [progress, success, reloading, refreshed];
      },
      verify: (_) {
        verify(
          () => homeRepository.kickMember(homeId: 'home-1', userId: 'user-2'),
        ).called(1);
        verify(() => homeRepository.getCurrentMembership()).called(1);
        verify(() => homeRepository.listActiveMembers('home-1')).called(1);
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
  });
}
