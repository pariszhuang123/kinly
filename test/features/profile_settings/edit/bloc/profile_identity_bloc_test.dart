import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/profile/models.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/core/profile/enums/profile_error_code.dart';
import 'package:kinly/core/profile/profile_error_mapper.dart';
import 'package:kinly/features/profile_settings/edit/bloc/profile_identity_bloc.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late _MockProfileRepository profileRepository;

  const sampleAvatar = ProfileAvatar(
    id: 'avatar-1',
    storagePath: 'avatars/cat.png',
    category: 'animals',
    imageUrl: 'https://example.com/cat.png',
  );

  const sampleAvatar2 = ProfileAvatar(
    id: 'avatar-2',
    storagePath: 'avatars/dog.png',
    category: 'animals',
    imageUrl: 'https://example.com/dog.png',
  );

  const avatars = [sampleAvatar, sampleAvatar2];

  const sampleProfile = UserProfile(
    userId: 'user-1',
    username: 'testuser',
    avatarStoragePath: 'avatars/cat.png',
    avatarUrl: 'https://example.com/cat.png',
  );

  const homeId = 'home-1';

  ProfileIdentityBloc buildBloc({
    String? initialUsername,
    String? initialAvatarStoragePath,
    String? initialAvatarUrl,
  }) {
    return ProfileIdentityBloc(
      profileRepository: profileRepository,
      homeId: homeId,
      initialUsername: initialUsername ?? 'testuser',
      initialAvatarStoragePath: initialAvatarStoragePath ?? 'avatars/cat.png',
      initialAvatarUrl: initialAvatarUrl ?? 'https://example.com/cat.png',
    );
  }

  void stubSuccessfulLoad() {
    when(
      () => profileRepository.getCurrentProfile(),
    ).thenAnswer((_) async => sampleProfile);
    when(
      () => profileRepository.listAvailableAvatars(any()),
    ).thenAnswer((_) async => avatars);
  }

  setUp(() {
    profileRepository = _MockProfileRepository();
  });

  _eventPropsTests();
  _stateTests();

  group('ProfileIdentityBloc', () {
    group('ProfileIdentityStarted', () {
      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'loads profile and avatars successfully',
        build: () {
          stubSuccessfulLoad();
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ProfileIdentityStarted()),
        expect:
            () => [
              isA<ProfileIdentityState>().having(
                (s) => s.isLoading,
                'isLoading',
                true,
              ),
              isA<ProfileIdentityState>()
                  .having((s) => s.isLoading, 'isLoading', false)
                  .having((s) => s.loadErrorMessage, 'loadErrorMessage', isNull)
                  .having((s) => s.avatars.length, 'avatars.length', 2)
                  .having(
                    (s) => s.selectedAvatarId,
                    'selectedAvatarId',
                    'avatar-1',
                  )
                  .having((s) => s.username, 'username', 'testuser')
                  .having(
                    (s) => s.initialUsername,
                    'initialUsername',
                    'testuser',
                  )
                  .having(
                    (s) => s.initialAvatarId,
                    'initialAvatarId',
                    'avatar-1',
                  ),
            ],
        verify: (_) {
          verify(() => profileRepository.getCurrentProfile()).called(1);
          verify(
            () => profileRepository.listAvailableAvatars(homeId),
          ).called(1);
        },
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'handles null profile by keeping initial values',
        build: () {
          when(
            () => profileRepository.getCurrentProfile(),
          ).thenAnswer((_) async => null);
          when(
            () => profileRepository.listAvailableAvatars(any()),
          ).thenAnswer((_) async => avatars);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ProfileIdentityStarted()),
        expect:
            () => [
              isA<ProfileIdentityState>(),
              isA<ProfileIdentityState>()
                  .having((s) => s.isLoading, 'isLoading', false)
                  .having((s) => s.username, 'username', 'testuser'),
            ],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'emits error when getCurrentProfile throws',
        build: () {
          when(
            () => profileRepository.getCurrentProfile(),
          ).thenThrow(Exception('profile fetch failed'));
          when(
            () => profileRepository.listAvailableAvatars(any()),
          ).thenAnswer((_) async => avatars);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ProfileIdentityStarted()),
        expect:
            () => [
              isA<ProfileIdentityState>(),
              isA<ProfileIdentityState>()
                  .having((s) => s.isLoading, 'isLoading', false)
                  .having(
                    (s) => s.loadErrorMessage,
                    'loadErrorMessage',
                    isNotNull,
                  ),
            ],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'emits error when listAvailableAvatars throws',
        build: () {
          when(
            () => profileRepository.getCurrentProfile(),
          ).thenAnswer((_) async => sampleProfile);
          when(
            () => profileRepository.listAvailableAvatars(any()),
          ).thenThrow(Exception('avatars failed'));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ProfileIdentityStarted()),
        expect:
            () => [
              isA<ProfileIdentityState>(),
              isA<ProfileIdentityState>()
                  .having((s) => s.isLoading, 'isLoading', false)
                  .having(
                    (s) => s.loadErrorMessage,
                    'loadErrorMessage',
                    contains('avatars failed'),
                  ),
            ],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'resolves avatar id from storage path',
        build: () {
          when(() => profileRepository.getCurrentProfile()).thenAnswer(
            (_) async => const UserProfile(
              userId: 'user-1',
              username: 'testuser',
              avatarStoragePath: 'avatars/dog.png',
              avatarUrl: 'https://example.com/dog.png',
            ),
          );
          when(
            () => profileRepository.listAvailableAvatars(any()),
          ).thenAnswer((_) async => avatars);
          return buildBloc(initialAvatarStoragePath: 'avatars/dog.png');
        },
        act: (bloc) => bloc.add(const ProfileIdentityStarted()),
        expect:
            () => [
              isA<ProfileIdentityState>(),
              isA<ProfileIdentityState>()
                  .having(
                    (s) => s.selectedAvatarId,
                    'selectedAvatarId',
                    'avatar-2',
                  )
                  .having(
                    (s) => s.initialAvatarId,
                    'initialAvatarId',
                    'avatar-2',
                  ),
            ],
      );
    });

    group('ProfileIdentityUsernameChanged', () {
      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'updates username and trims/lowercases input',
        build: () {
          stubSuccessfulLoad();
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(
              username: 'testuser',
            ).copyWith(isLoading: false, avatars: avatars),
        act:
            (bloc) =>
                bloc.add(const ProfileIdentityUsernameChanged('  NewUser  ')),
        expect:
            () => [
              isA<ProfileIdentityState>().having(
                (s) => s.username,
                'username',
                'newuser',
              ),
            ],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'sets empty error when username is empty',
        build: () {
          stubSuccessfulLoad();
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(
              username: 'testuser',
            ).copyWith(isLoading: false, avatars: avatars),
        act: (bloc) => bloc.add(const ProfileIdentityUsernameChanged('')),
        expect:
            () => [
              isA<ProfileIdentityState>()
                  .having((s) => s.username, 'username', '')
                  .having(
                    (s) => s.usernameError,
                    'usernameError',
                    ProfileIdentityValidationError.empty,
                  ),
            ],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'sets invalidFormat error for username with invalid characters',
        build: () {
          stubSuccessfulLoad();
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(
              username: 'testuser',
            ).copyWith(isLoading: false, avatars: avatars),
        act:
            (bloc) =>
                bloc.add(const ProfileIdentityUsernameChanged('invalid@name!')),
        expect:
            () => [
              isA<ProfileIdentityState>().having(
                (s) => s.usernameError,
                'usernameError',
                ProfileIdentityValidationError.invalidFormat,
              ),
            ],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'sets invalidFormat error for username too short',
        build: () {
          stubSuccessfulLoad();
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(
              username: 'testuser',
            ).copyWith(isLoading: false, avatars: avatars),
        act: (bloc) => bloc.add(const ProfileIdentityUsernameChanged('ab')),
        expect:
            () => [
              isA<ProfileIdentityState>().having(
                (s) => s.usernameError,
                'usernameError',
                ProfileIdentityValidationError.invalidFormat,
              ),
            ],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'clears error for valid username',
        build: () {
          stubSuccessfulLoad();
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(username: 'testuser').copyWith(
              isLoading: false,
              avatars: avatars,
              usernameError: ProfileIdentityValidationError.empty,
            ),
        act:
            (bloc) =>
                bloc.add(const ProfileIdentityUsernameChanged('validusername')),
        expect:
            () => [
              isA<ProfileIdentityState>()
                  .having((s) => s.username, 'username', 'validusername')
                  .having((s) => s.usernameError, 'usernameError', isNull),
            ],
      );
    });

    group('ProfileIdentityAvatarSelected', () {
      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'updates selected avatar id and url',
        build: () {
          stubSuccessfulLoad();
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(username: 'testuser').copyWith(
              isLoading: false,
              avatars: avatars,
              selectedAvatarId: 'avatar-1',
              selectedAvatarUrl: 'https://example.com/cat.png',
            ),
        act:
            (bloc) => bloc.add(const ProfileIdentityAvatarSelected('avatar-2')),
        expect:
            () => [
              isA<ProfileIdentityState>()
                  .having(
                    (s) => s.selectedAvatarId,
                    'selectedAvatarId',
                    'avatar-2',
                  )
                  .having(
                    (s) => s.selectedAvatarUrl,
                    'selectedAvatarUrl',
                    'https://example.com/dog.png',
                  ),
            ],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'keeps existing url when avatar not found',
        build: () {
          stubSuccessfulLoad();
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(username: 'testuser').copyWith(
              isLoading: false,
              avatars: avatars,
              selectedAvatarId: 'avatar-1',
              selectedAvatarUrl: 'https://example.com/cat.png',
            ),
        act:
            (bloc) =>
                bloc.add(const ProfileIdentityAvatarSelected('nonexistent')),
        expect:
            () => [
              isA<ProfileIdentityState>()
                  .having(
                    (s) => s.selectedAvatarId,
                    'selectedAvatarId',
                    'nonexistent',
                  )
                  .having(
                    (s) => s.selectedAvatarUrl,
                    'selectedAvatarUrl',
                    'https://example.com/cat.png',
                  ),
            ],
      );
    });

    group('ProfileIdentitySubmitted', () {
      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'does nothing when canSubmit is false (no changes)',
        build: () {
          stubSuccessfulLoad();
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(username: 'testuser').copyWith(
              isLoading: false,
              avatars: avatars,
              initialUsername: 'testuser',
              selectedAvatarId: 'avatar-1',
              initialAvatarId: 'avatar-1',
            ),
        act: (bloc) => bloc.add(const ProfileIdentitySubmitted()),
        expect: () => <ProfileIdentityState>[],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'does nothing when selectedAvatarId is null',
        build: () {
          stubSuccessfulLoad();
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(username: 'newuser').copyWith(
              isLoading: false,
              avatars: avatars,
              initialUsername: 'testuser',
              selectedAvatarId: null,
            ),
        act: (bloc) => bloc.add(const ProfileIdentitySubmitted()),
        expect: () => <ProfileIdentityState>[],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'submits successfully when username changed',
        build: () {
          stubSuccessfulLoad();
          when(
            () => profileRepository.updateIdentity(
              username: any(named: 'username'),
              avatarId: any(named: 'avatarId'),
            ),
          ).thenAnswer(
            (_) async => const UserProfile(
              userId: 'user-1',
              username: 'newusername',
              avatarStoragePath: 'avatars/cat.png',
              avatarUrl: 'https://example.com/cat.png',
            ),
          );
          return buildBloc();
        },
        seed:
            () =>
                ProfileIdentityState.initial(username: 'newusername').copyWith(
                  isLoading: false,
                  avatars: avatars,
                  initialUsername: 'testuser',
                  selectedAvatarId: 'avatar-1',
                  initialAvatarId: 'avatar-1',
                ),
        act: (bloc) => bloc.add(const ProfileIdentitySubmitted()),
        expect:
            () => [
              isA<ProfileIdentityState>()
                  .having((s) => s.isSubmitting, 'isSubmitting', true)
                  .having(
                    (s) => s.action,
                    'action',
                    ProfileIdentityAction.none,
                  ),
              isA<ProfileIdentityState>()
                  .having((s) => s.isSubmitting, 'isSubmitting', false)
                  .having(
                    (s) => s.action,
                    'action',
                    ProfileIdentityAction.success,
                  )
                  .having(
                    (s) => s.updatedProfile?.username,
                    'updatedProfile.username',
                    'newusername',
                  )
                  .having(
                    (s) => s.initialUsername,
                    'initialUsername',
                    'newusername',
                  )
                  .having((s) => s.actionError, 'actionError', isNull),
            ],
        verify: (_) {
          verify(
            () => profileRepository.updateIdentity(
              username: 'newusername',
              avatarId: 'avatar-1',
            ),
          ).called(1);
        },
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'submits successfully when avatar changed',
        build: () {
          stubSuccessfulLoad();
          when(
            () => profileRepository.updateIdentity(
              username: any(named: 'username'),
              avatarId: any(named: 'avatarId'),
            ),
          ).thenAnswer(
            (_) async => const UserProfile(
              userId: 'user-1',
              username: 'testuser',
              avatarStoragePath: 'avatars/dog.png',
              avatarUrl: 'https://example.com/dog.png',
            ),
          );
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(username: 'testuser').copyWith(
              isLoading: false,
              avatars: avatars,
              initialUsername: 'testuser',
              selectedAvatarId: 'avatar-2',
              initialAvatarId: 'avatar-1',
            ),
        act: (bloc) => bloc.add(const ProfileIdentitySubmitted()),
        expect:
            () => [
              isA<ProfileIdentityState>().having(
                (s) => s.isSubmitting,
                'isSubmitting',
                true,
              ),
              isA<ProfileIdentityState>()
                  .having((s) => s.isSubmitting, 'isSubmitting', false)
                  .having(
                    (s) => s.action,
                    'action',
                    ProfileIdentityAction.success,
                  )
                  .having(
                    (s) => s.initialAvatarId,
                    'initialAvatarId',
                    'avatar-2',
                  ),
            ],
        verify: (_) {
          verify(
            () => profileRepository.updateIdentity(
              username: 'testuser',
              avatarId: 'avatar-2',
            ),
          ).called(1);
        },
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'handles ProfileIdentityException on submit failure',
        build: () {
          stubSuccessfulLoad();
          when(
            () => profileRepository.updateIdentity(
              username: any(named: 'username'),
              avatarId: any(named: 'avatarId'),
            ),
          ).thenThrow(
            const ProfileIdentityException(
              ProfileErrorCode.usernameTaken,
              'Username already taken',
            ),
          );
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(username: 'takenuser').copyWith(
              isLoading: false,
              avatars: avatars,
              initialUsername: 'testuser',
              selectedAvatarId: 'avatar-1',
              initialAvatarId: 'avatar-1',
            ),
        act: (bloc) => bloc.add(const ProfileIdentitySubmitted()),
        expect:
            () => [
              isA<ProfileIdentityState>().having(
                (s) => s.isSubmitting,
                'isSubmitting',
                true,
              ),
              isA<ProfileIdentityState>()
                  .having((s) => s.isSubmitting, 'isSubmitting', false)
                  .having(
                    (s) => s.action,
                    'action',
                    ProfileIdentityAction.failure,
                  )
                  .having(
                    (s) => s.actionError,
                    'actionError',
                    ProfileErrorCode.usernameTaken,
                  )
                  .having(
                    (s) => s.actionMessage,
                    'actionMessage',
                    'Username already taken',
                  ),
            ],
      );

      blocTest<ProfileIdentityBloc, ProfileIdentityState>(
        'maps unknown error through ProfileErrorMapper',
        build: () {
          stubSuccessfulLoad();
          when(
            () => profileRepository.updateIdentity(
              username: any(named: 'username'),
              avatarId: any(named: 'avatarId'),
            ),
          ).thenThrow(Exception('network error'));
          return buildBloc();
        },
        seed:
            () => ProfileIdentityState.initial(username: 'newuser').copyWith(
              isLoading: false,
              avatars: avatars,
              initialUsername: 'testuser',
              selectedAvatarId: 'avatar-1',
              initialAvatarId: 'avatar-1',
            ),
        act: (bloc) => bloc.add(const ProfileIdentitySubmitted()),
        expect:
            () => [
              isA<ProfileIdentityState>().having(
                (s) => s.isSubmitting,
                'isSubmitting',
                true,
              ),
              isA<ProfileIdentityState>()
                  .having((s) => s.isSubmitting, 'isSubmitting', false)
                  .having(
                    (s) => s.action,
                    'action',
                    ProfileIdentityAction.failure,
                  )
                  .having(
                    (s) => s.actionError,
                    'actionError',
                    ProfileErrorCode.unknown,
                  ),
            ],
      );
    });
  });
}

void _eventPropsTests() {
  group('ProfileIdentityEvent props', () {
    group('ProfileIdentityStarted', () {
      test('props is empty', () {
        const event = ProfileIdentityStarted();
        expect(event.props, isEmpty);
      });

      test('two instances are equal', () {
        const event1 = ProfileIdentityStarted();
        const event2 = ProfileIdentityStarted();
        expect(event1, equals(event2));
      });
    });

    group('ProfileIdentityUsernameChanged', () {
      test('props contains username', () {
        const event = ProfileIdentityUsernameChanged('testuser');
        expect(event.props, ['testuser']);
      });

      test('two events with same username are equal', () {
        const event1 = ProfileIdentityUsernameChanged('alice');
        const event2 = ProfileIdentityUsernameChanged('alice');
        expect(event1, equals(event2));
      });

      test('two events with different usernames are not equal', () {
        const event1 = ProfileIdentityUsernameChanged('alice');
        const event2 = ProfileIdentityUsernameChanged('bob');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('ProfileIdentityAvatarSelected', () {
      test('props contains avatarId', () {
        const event = ProfileIdentityAvatarSelected('avatar-1');
        expect(event.props, ['avatar-1']);
      });

      test('two events with same avatarId are equal', () {
        const event1 = ProfileIdentityAvatarSelected('avatar-1');
        const event2 = ProfileIdentityAvatarSelected('avatar-1');
        expect(event1, equals(event2));
      });

      test('two events with different avatarIds are not equal', () {
        const event1 = ProfileIdentityAvatarSelected('avatar-1');
        const event2 = ProfileIdentityAvatarSelected('avatar-2');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('ProfileIdentitySubmitted', () {
      test('props is empty', () {
        const event = ProfileIdentitySubmitted();
        expect(event.props, isEmpty);
      });

      test('two instances are equal', () {
        const event1 = ProfileIdentitySubmitted();
        const event2 = ProfileIdentitySubmitted();
        expect(event1, equals(event2));
      });
    });
  });
}

void _stateTests() {
  group('ProfileIdentityState', () {
    group('initial factory', () {
      test('creates state with expected defaults', () {
        final state = ProfileIdentityState.initial(username: 'testuser');

        expect(state.username, 'testuser');
        expect(state.initialUsername, 'testuser');
        expect(state.usernameError, isNull);
        expect(state.avatars, isEmpty);
        expect(state.selectedAvatarId, isNull);
        expect(state.selectedAvatarUrl, isNull);
        expect(state.initialAvatarId, isNull);
        expect(state.initialAvatarStoragePath, isNull);
        expect(state.isLoading, isTrue);
        expect(state.isSubmitting, isFalse);
        expect(state.loadErrorMessage, isNull);
        expect(state.action, ProfileIdentityAction.none);
        expect(state.actionMessage, isNull);
        expect(state.actionError, isNull);
        expect(state.updatedProfile, isNull);
      });

      test('sets initialUsername to null when username is empty', () {
        final state = ProfileIdentityState.initial(username: '');
        expect(state.initialUsername, isNull);
      });

      test('accepts optional avatarStoragePath and avatarUrl', () {
        final state = ProfileIdentityState.initial(
          username: 'testuser',
          avatarStoragePath: 'avatars/cat.png',
          avatarUrl: 'https://example.com/cat.png',
        );

        expect(state.initialAvatarStoragePath, 'avatars/cat.png');
        expect(state.selectedAvatarUrl, 'https://example.com/cat.png');
      });
    });

    group('canSubmit', () {
      const avatars = [
        ProfileAvatar(
          id: 'avatar-1',
          storagePath: 'avatars/cat.png',
          category: 'animals',
          imageUrl: 'https://example.com/cat.png',
        ),
      ];

      test('returns false when isLoading is true', () {
        final state = ProfileIdentityState.initial(
          username: 'newuser',
        ).copyWith(
          isLoading: true,
          initialUsername: 'testuser',
          selectedAvatarId: 'avatar-1',
        );
        expect(state.canSubmit, isFalse);
      });

      test('returns false when isSubmitting is true', () {
        final state = ProfileIdentityState.initial(
          username: 'newuser',
        ).copyWith(
          isLoading: false,
          isSubmitting: true,
          initialUsername: 'testuser',
          selectedAvatarId: 'avatar-1',
        );
        expect(state.canSubmit, isFalse);
      });

      test('returns false when loadErrorMessage is set', () {
        final state = ProfileIdentityState.initial(
          username: 'newuser',
        ).copyWith(
          isLoading: false,
          loadErrorMessage: 'Error occurred',
          initialUsername: 'testuser',
          selectedAvatarId: 'avatar-1',
        );
        expect(state.canSubmit, isFalse);
      });

      test('returns false when usernameError is set', () {
        final state = ProfileIdentityState.initial(
          username: 'newuser',
        ).copyWith(
          isLoading: false,
          usernameError: ProfileIdentityValidationError.empty,
          initialUsername: 'testuser',
          selectedAvatarId: 'avatar-1',
        );
        expect(state.canSubmit, isFalse);
      });

      test('returns false when username is empty', () {
        final state = ProfileIdentityState.initial(username: '').copyWith(
          isLoading: false,
          initialUsername: 'testuser',
          selectedAvatarId: 'avatar-1',
        );
        expect(state.canSubmit, isFalse);
      });

      test('returns false when selectedAvatarId is null', () {
        final state = ProfileIdentityState.initial(
          username: 'newuser',
        ).copyWith(
          isLoading: false,
          initialUsername: 'testuser',
          selectedAvatarId: null,
        );
        expect(state.canSubmit, isFalse);
      });

      test('returns false when no changes made', () {
        final state = ProfileIdentityState.initial(
          username: 'testuser',
        ).copyWith(
          isLoading: false,
          initialUsername: 'testuser',
          selectedAvatarId: 'avatar-1',
          initialAvatarId: 'avatar-1',
          avatars: avatars,
        );
        expect(state.canSubmit, isFalse);
      });

      test('returns true when username changed', () {
        final state = ProfileIdentityState.initial(
          username: 'newuser',
        ).copyWith(
          isLoading: false,
          initialUsername: 'testuser',
          selectedAvatarId: 'avatar-1',
          initialAvatarId: 'avatar-1',
          avatars: avatars,
        );
        expect(state.canSubmit, isTrue);
      });

      test('returns true when avatar changed', () {
        final state = ProfileIdentityState.initial(
          username: 'testuser',
        ).copyWith(
          isLoading: false,
          initialUsername: 'testuser',
          selectedAvatarId: 'avatar-2',
          initialAvatarId: 'avatar-1',
          avatars: avatars,
        );
        expect(state.canSubmit, isTrue);
      });

      test('returns true when both username and avatar changed', () {
        final state = ProfileIdentityState.initial(
          username: 'newuser',
        ).copyWith(
          isLoading: false,
          initialUsername: 'testuser',
          selectedAvatarId: 'avatar-2',
          initialAvatarId: 'avatar-1',
          avatars: avatars,
        );
        expect(state.canSubmit, isTrue);
      });
    });
  });
}
