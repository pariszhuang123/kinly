import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/profile/models.dart';
import 'package:kinly/data/repositories/account_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/data/repositories/profile_repository.dart';
import 'package:kinly/features/profile_settings/bloc/profile_settings_bloc.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late _MockProfileRepository profileRepository;
  late _MockHomeRepository homeRepository;
  late _MockAccountRepository accountRepository;

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
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileSettingsStarted()),
      expect: () {
        final initial = ProfileSettingsState.initial();
        final loading = initial.copyWith(isLoadingUser: true);
        final loaded = loading.copyWith(
          isLoadingUser: false,
          user: ProfileSettingsUser(
            displayName: userProfile.username,
            avatarUrl: userProfile.avatarUrl,
            avatarStoragePath: userProfile.avatarStoragePath,
          ),
        );
        return [loading, loaded];
      },
      verify: (_) {
        verify(() => profileRepository.getCurrentProfile()).called(1);
      },
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'emits success after leaving home',
      build: () {
        when(() => homeRepository.leave(any())).thenAnswer(
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
      'emits failure when leaving home fails',
      build: () {
        when(
          () => homeRepository.leave(any()),
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
