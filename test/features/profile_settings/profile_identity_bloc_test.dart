import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/profile/models.dart';
import 'package:kinly/features/profile_settings/profile_settings.dart';
import 'package:kinly/features/profile_settings/edit/bloc/profile_identity_bloc.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late _MockProfileRepository profileRepository;

  const avatars = [
    ProfileAvatar(
      id: 'a-1',
      storagePath: 'avatars/cat.svg',
      category: 'animal',
      imageUrl: 'https://example.com/cat.svg',
    ),
    ProfileAvatar(
      id: 'a-2',
      storagePath: 'avatars/plant.svg',
      category: 'plant',
      imageUrl: 'https://example.com/plant.svg',
    ),
  ];

  const userProfile = UserProfile(
    userId: 'user-1',
    username: 'avery',
    avatarStoragePath: 'avatars/cat.svg',
    avatarUrl: 'https://example.com/cat.svg',
  );

  ProfileIdentityBloc buildBloc() {
    return ProfileIdentityBloc(
      profileRepository: profileRepository,
      homeId: 'home-1',
      initialUsername: 'avery',
      initialAvatarStoragePath: 'avatars/cat.svg',
      initialAvatarUrl: 'https://example.com/cat.svg',
    );
  }

  setUp(() {
    profileRepository = _MockProfileRepository();
  });

  group('ProfileIdentityBloc', () {
    blocTest<ProfileIdentityBloc, ProfileIdentityState>(
      'loads profile and avatars on start',
      build: () {
        when(
          () => profileRepository.getCurrentProfile(),
        ).thenAnswer((_) async => userProfile);
        when(
          () => profileRepository.listAvailableAvatars(any()),
        ).thenAnswer((_) async => avatars);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileIdentityStarted()),
      expect:
          () => [
            isA<ProfileIdentityState>(), // loading snapshot
            predicate<ProfileIdentityState>(
              (state) =>
                  !state.isLoading &&
                  state.loadErrorMessage == null &&
                  state.avatars.length == avatars.length &&
                  state.selectedAvatarId == avatars.first.id &&
                  state.username == userProfile.username,
            ),
          ],
      verify: (_) {
        verify(() => profileRepository.getCurrentProfile()).called(1);
        verify(
          () => profileRepository.listAvailableAvatars('home-1'),
        ).called(1);
      },
    );

    blocTest<ProfileIdentityBloc, ProfileIdentityState>(
      'emits failure when loading avatars throws',
      build: () {
        when(
          () => profileRepository.getCurrentProfile(),
        ).thenAnswer((_) async => userProfile);
        when(
          () => profileRepository.listAvailableAvatars(any()),
        ).thenThrow(Exception('avatars failed'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileIdentityStarted()),
      expect:
          () => [
            isA<ProfileIdentityState>(),
            predicate<ProfileIdentityState>(
              (state) => !state.isLoading && state.loadErrorMessage != null,
            ),
          ],
    );

    blocTest<ProfileIdentityBloc, ProfileIdentityState>(
      'emits success after submitting updated identity',
      build: () {
        when(
          () => profileRepository.getCurrentProfile(),
        ).thenAnswer((_) async => userProfile);
        when(
          () => profileRepository.listAvailableAvatars(any()),
        ).thenAnswer((_) async => avatars);
        when(
          () => profileRepository.updateIdentity(
            username: any(named: 'username'),
            avatarId: any(named: 'avatarId'),
          ),
        ).thenAnswer(
          (_) async => const UserProfile(
            userId: 'user-1',
            username: 'taylor',
            avatarStoragePath: 'avatars/plant.svg',
            avatarUrl: 'https://example.com/plant.svg',
          ),
        );
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const ProfileIdentityStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const ProfileIdentityAvatarSelected('a-2'));
        bloc.add(const ProfileIdentityUsernameChanged('taylor'));
        bloc.add(const ProfileIdentitySubmitted());
      },
      expect:
          () => [
            isA<ProfileIdentityState>(),
            isA<ProfileIdentityState>(),
            isA<ProfileIdentityState>(),
            isA<ProfileIdentityState>(),
            isA<ProfileIdentityState>(),
            predicate<ProfileIdentityState>(
              (state) =>
                  state.action == ProfileIdentityAction.success &&
                  state.updatedProfile != null &&
                  state.updatedProfile!.username == 'taylor',
            ),
          ],
      verify: (_) {
        verify(
          () => profileRepository.updateIdentity(
            username: 'taylor',
            avatarId: 'a-2',
          ),
        ).called(1);
      },
    );
  });
}
