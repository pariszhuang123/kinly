import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/core/supabase/enums/mood_error_code.dart';
import 'package:kinly/features/harmony/bloc/harmony_cubit.dart';

class _MockMoodRepository extends Mock implements MoodRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(MoodScale.sunny);
  });

  late _MockMoodRepository moodRepo;
  late _MockHomeRepository homeRepo;

  const homeId = 'home-123';

  setUp(() {
    moodRepo = _MockMoodRepository();
    homeRepo = _MockHomeRepository();
  });

  HarmonyCubit buildCubit() {
    return HarmonyCubit(
      homeId: homeId,
      moodRepository: moodRepo,
      homeRepository: homeRepo,
    );
  }

  HomeMemberSummary buildMember({
    String userId = 'user-1',
    String username = 'alice',
  }) {
    return HomeMemberSummary(
      userId: userId,
      username: username,
      role: 'member',
      validFrom: DateTime.now().toUtc(),
    );
  }

  group('HarmonyCubit', () {
    test('initial state is correct', () {
      final cubit = buildCubit();

      expect(cubit.state.selectedMood, isNull);
      expect(cubit.state.comment, '');
      expect(cubit.state.addToWall, false);
      expect(cubit.state.isSubmitting, false);
      expect(cubit.state.submitSuccessTick, 0);
      expect(cubit.state.submitError, isNull);
      expect(cubit.state.lastResult, isNull);
      expect(cubit.state.members, isEmpty);
      expect(cubit.state.selectedMentions, isEmpty);
      expect(cubit.state.isLoadingMembers, false);
      expect(cubit.state.membersLoadFailed, false);

      cubit.close();
    });

    group('loadMembers', () {
      blocTest<HarmonyCubit, HarmonyState>(
        'fetches members successfully',
        build: () {
          when(
            () => homeRepo.listActiveMembers(any(), excludeSelf: true),
          ).thenAnswer(
            (_) async => [buildMember(), buildMember(userId: 'user-2')],
          );
          return buildCubit();
        },
        act: (cubit) => cubit.loadMembers(),
        expect:
            () => [
              isA<HarmonyState>()
                  .having((s) => s.isLoadingMembers, 'isLoadingMembers', true)
                  .having((s) => s.membersLoadFailed, 'membersLoadFailed', false),
              isA<HarmonyState>()
                  .having((s) => s.isLoadingMembers, 'isLoadingMembers', false)
                  .having((s) => s.members.length, 'members.length', 2),
            ],
        verify: (_) {
          verify(
            () => homeRepo.listActiveMembers(homeId, excludeSelf: true),
          ).called(1);
        },
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'does not load if already loading',
        build: () {
          when(
            () => homeRepo.listActiveMembers(any(), excludeSelf: true),
          ).thenAnswer((_) async => []);
          return buildCubit();
        },
        seed: () => const HarmonyState(isLoadingMembers: true),
        act: (cubit) => cubit.loadMembers(),
        expect: () => [],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'does not load if members already present',
        build: () {
          when(
            () => homeRepo.listActiveMembers(any(), excludeSelf: true),
          ).thenAnswer((_) async => []);
          return buildCubit();
        },
        seed: () => HarmonyState(members: [buildMember()]),
        act: (cubit) => cubit.loadMembers(),
        expect: () => [],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'sets membersLoadFailed on error',
        build: () {
          when(
            () => homeRepo.listActiveMembers(any(), excludeSelf: true),
          ).thenThrow(Exception('Network error'));
          return buildCubit();
        },
        act: (cubit) => cubit.loadMembers(),
        expect:
            () => [
              isA<HarmonyState>().having(
                (s) => s.isLoadingMembers,
                'isLoadingMembers',
                true,
              ),
              isA<HarmonyState>()
                  .having((s) => s.isLoadingMembers, 'isLoadingMembers', false)
                  .having((s) => s.membersLoadFailed, 'membersLoadFailed', true),
            ],
      );
    });

    group('selectMood', () {
      blocTest<HarmonyCubit, HarmonyState>(
        'selects mood',
        build: buildCubit,
        act: (cubit) => cubit.selectMood(MoodScale.sunny),
        expect:
            () => [
              isA<HarmonyState>().having(
                (s) => s.selectedMood,
                'selectedMood',
                MoodScale.sunny,
              ),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'does not emit if same mood selected',
        build: buildCubit,
        seed: () => const HarmonyState(selectedMood: MoodScale.cloudy),
        act: (cubit) => cubit.selectMood(MoodScale.cloudy),
        expect: () => [],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'trims mentions to one when switching to negative mood',
        build: buildCubit,
        seed:
            () => const HarmonyState(
              selectedMood: MoodScale.sunny,
              comment: 'Great day!',
              selectedMentions: {'user-1', 'user-2'},
            ),
        act: (cubit) => cubit.selectMood(MoodScale.rainy),
        expect:
            () => [
              isA<HarmonyState>()
                  .having(
                    (s) => s.selectedMood,
                    'selectedMood',
                    MoodScale.rainy,
                  )
                  .having(
                    (s) => s.selectedMentions.length,
                    'selectedMentions.length',
                    1,
                  )
                  .having((s) => s.addToWall, 'addToWall', false),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'sets addToWall true when becoming eligible (sunny with comment)',
        build: buildCubit,
        seed: () => const HarmonyState(comment: 'Nice day!'),
        act: (cubit) => cubit.selectMood(MoodScale.sunny),
        expect:
            () => [
              isA<HarmonyState>()
                  .having(
                    (s) => s.selectedMood,
                    'selectedMood',
                    MoodScale.sunny,
                  )
                  .having((s) => s.addToWall, 'addToWall', true),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'sets addToWall true when becoming eligible (partiallySunny with comment)',
        build: buildCubit,
        seed: () => const HarmonyState(comment: 'Good day!'),
        act: (cubit) => cubit.selectMood(MoodScale.partiallySunny),
        expect:
            () => [
              isA<HarmonyState>()
                  .having(
                    (s) => s.selectedMood,
                    'selectedMood',
                    MoodScale.partiallySunny,
                  )
                  .having((s) => s.addToWall, 'addToWall', true),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'does not set addToWall if no comment',
        build: buildCubit,
        act: (cubit) => cubit.selectMood(MoodScale.sunny),
        expect:
            () => [
              isA<HarmonyState>().having(
                (s) => s.addToWall,
                'addToWall',
                false,
              ),
            ],
      );
    });

    group('commentChanged', () {
      blocTest<HarmonyCubit, HarmonyState>(
        'updates comment',
        build: buildCubit,
        act: (cubit) => cubit.commentChanged('Hello'),
        expect:
            () => [
              isA<HarmonyState>().having((s) => s.comment, 'comment', 'Hello'),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'sets addToWall true when comment added with sunny mood',
        build: buildCubit,
        seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
        act: (cubit) => cubit.commentChanged('Great week!'),
        expect:
            () => [
              isA<HarmonyState>()
                  .having((s) => s.comment, 'comment', 'Great week!')
                  .having((s) => s.addToWall, 'addToWall', true),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'does not set addToWall for non-shareable mood',
        build: buildCubit,
        seed: () => const HarmonyState(selectedMood: MoodScale.thunderstorm),
        act: (cubit) => cubit.commentChanged('Tough week'),
        expect:
            () => [
              isA<HarmonyState>().having(
                (s) => s.addToWall,
                'addToWall',
                false,
              ),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'sets addToWall false when comment cleared',
        build: buildCubit,
        seed:
            () => const HarmonyState(
              selectedMood: MoodScale.sunny,
              comment: 'Hello',
              addToWall: true,
            ),
        act: (cubit) => cubit.commentChanged(''),
        expect:
            () => [
              isA<HarmonyState>()
                  .having((s) => s.comment, 'comment', '')
                  .having((s) => s.addToWall, 'addToWall', false),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'preserves addToWall=false when user manually unticked',
        build: buildCubit,
        seed:
            () => const HarmonyState(
              selectedMood: MoodScale.sunny,
              comment: 'Hello',
              addToWall: false,
            ),
        act: (cubit) => cubit.commentChanged('Hello updated'),
        expect:
            () => [
              isA<HarmonyState>()
                  .having((s) => s.comment, 'comment', 'Hello updated')
                  .having((s) => s.addToWall, 'addToWall', false),
            ],
      );
    });

    group('toggleAddToWall', () {
      blocTest<HarmonyCubit, HarmonyState>(
        'toggles addToWall when mood is shareable',
        build: buildCubit,
        seed:
            () => const HarmonyState(
              selectedMood: MoodScale.sunny,
              addToWall: false,
            ),
        act: (cubit) => cubit.toggleAddToWall(true),
        expect:
            () => [
              isA<HarmonyState>().having((s) => s.addToWall, 'addToWall', true),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'does nothing when mood is not shareable',
        build: buildCubit,
        seed: () => const HarmonyState(selectedMood: MoodScale.rainy),
        act: (cubit) => cubit.toggleAddToWall(true),
        expect: () => [],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'does nothing when no mood selected',
        build: buildCubit,
        act: (cubit) => cubit.toggleAddToWall(true),
        expect: () => [],
      );
    });

    group('toggleMention', () {
      blocTest<HarmonyCubit, HarmonyState>(
        'adds mention when mood is shareable',
        build: buildCubit,
        seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
        act: (cubit) => cubit.toggleMention('user-1'),
        expect:
            () => [
              isA<HarmonyState>().having(
                (s) => s.selectedMentions,
                'selectedMentions',
                {'user-1'},
              ),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'removes mention when already selected',
        build: buildCubit,
        seed:
            () => const HarmonyState(
              selectedMood: MoodScale.sunny,
              selectedMentions: {'user-1'},
            ),
        act: (cubit) => cubit.toggleMention('user-1'),
        expect:
            () => [
              isA<HarmonyState>().having(
                (s) => s.selectedMentions,
                'selectedMentions',
                isEmpty,
              ),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'respects max 5 mentions limit',
        build: buildCubit,
        seed:
            () => const HarmonyState(
              selectedMood: MoodScale.sunny,
              selectedMentions: {'u1', 'u2', 'u3', 'u4', 'u5'},
            ),
        act: (cubit) => cubit.toggleMention('u6'),
        expect: () => [],
      );

      // Negative moods allow one mention (rewrite flow).
    });

    group('setMentions', () {
      blocTest<HarmonyCubit, HarmonyState>(
        'sets mentions when mood is shareable',
        build: buildCubit,
        seed: () => const HarmonyState(selectedMood: MoodScale.partiallySunny),
        act: (cubit) => cubit.setMentions({'u1', 'u2', 'u3'}),
        expect:
            () => [
              isA<HarmonyState>().having(
                (s) => s.selectedMentions,
                'selectedMentions',
                {'u1', 'u2', 'u3'},
              ),
            ],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'limits to 5 mentions',
        build: buildCubit,
        seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
        act: (cubit) => cubit.setMentions({'u1', 'u2', 'u3', 'u4', 'u5', 'u6'}),
        expect:
            () => [
              isA<HarmonyState>().having(
                (s) => s.selectedMentions.length,
                'selectedMentions.length',
                5,
              ),
            ],
      );

      // Negative moods allow one mention (rewrite flow); limit enforced in cubit.
    });

    group('submit', () {
      blocTest<HarmonyCubit, HarmonyState>(
        'submits successfully',
        build: () {
          when(
            () => moodRepo.submit(
              homeId: any(named: 'homeId'),
              mood: any(named: 'mood'),
              comment: any(named: 'comment'),
              addToWall: any(named: 'addToWall'),
              mentions: any(named: 'mentions'),
            ),
          ).thenAnswer(
            (_) async => const MoodSubmitResult(
              entryId: 'entry-1',
              publicPostId: 'post-1',
              mentionCount: 2,
            ),
          );
          return buildCubit();
        },
        seed:
            () => const HarmonyState(
              selectedMood: MoodScale.sunny,
              comment: 'Great week!',
              addToWall: true,
              selectedMentions: {'u1', 'u2'},
            ),
        act: (cubit) => cubit.submit(),
        expect:
            () => [
              isA<HarmonyState>()
                  .having((s) => s.isSubmitting, 'isSubmitting', true)
                  .having((s) => s.submitError, 'submitError', isNull),
              isA<HarmonyState>()
                  .having((s) => s.isSubmitting, 'isSubmitting', false)
                  .having((s) => s.submitSuccessTick, 'submitSuccessTick', 1)
                  .having((s) => s.lastResult, 'lastResult', isNotNull),
            ],
        verify: (_) {
          verify(
            () => moodRepo.submit(
              homeId: homeId,
              mood: MoodScale.sunny,
              comment: 'Great week!',
              addToWall: true,
              mentions: ['u1', 'u2'],
            ),
          ).called(1);
        },
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'does not submit without mood selected',
        build: buildCubit,
        act: (cubit) => cubit.submit(),
        expect: () => [],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'does not submit if already submitting',
        build: buildCubit,
        seed:
            () => const HarmonyState(
              selectedMood: MoodScale.sunny,
              isSubmitting: true,
            ),
        act: (cubit) => cubit.submit(),
        expect: () => [],
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'clears mentions for non-shareable mood on submit',
        build: () {
          when(
            () => moodRepo.submit(
              homeId: any(named: 'homeId'),
              mood: any(named: 'mood'),
              comment: any(named: 'comment'),
              addToWall: any(named: 'addToWall'),
              mentions: any(named: 'mentions'),
            ),
          ).thenAnswer(
            (_) async => const MoodSubmitResult(
              entryId: 'entry-1',
              publicPostId: null,
              mentionCount: 0,
            ),
          );
          return buildCubit();
        },
        seed:
            () => const HarmonyState(
              selectedMood: MoodScale.cloudy,
              selectedMentions: {'u1'},
            ),
        act: (cubit) => cubit.submit(),
        verify: (_) {
          verify(
            () => moodRepo.submit(
              homeId: homeId,
              mood: MoodScale.cloudy,
              comment: '',
              addToWall: false,
              mentions: const <String>[],
            ),
          ).called(1);
        },
      );

      blocTest<HarmonyCubit, HarmonyState>(
        'sets addToWall false if no comment even with sunny mood',
        build: () {
          when(
            () => moodRepo.submit(
              homeId: any(named: 'homeId'),
              mood: any(named: 'mood'),
              comment: any(named: 'comment'),
              addToWall: any(named: 'addToWall'),
              mentions: any(named: 'mentions'),
            ),
          ).thenAnswer(
            (_) async => const MoodSubmitResult(
              entryId: 'entry-1',
              publicPostId: null,
              mentionCount: 0,
            ),
          );
          return buildCubit();
        },
        seed:
            () => const HarmonyState(
              selectedMood: MoodScale.sunny,
              comment: '',
              addToWall: true,
            ),
        act: (cubit) => cubit.submit(),
        verify: (_) {
          verify(
            () => moodRepo.submit(
              homeId: homeId,
              mood: MoodScale.sunny,
              comment: '',
              addToWall: false,
              mentions: const <String>[],
            ),
          ).called(1);
        },
      );

      group('error mapping', () {
        void setupErrorTest(MoodSubmitErrorCode code) {
          when(
            () => moodRepo.submit(
              homeId: any(named: 'homeId'),
              mood: any(named: 'mood'),
              comment: any(named: 'comment'),
              addToWall: any(named: 'addToWall'),
              mentions: any(named: 'mentions'),
            ),
          ).thenThrow(MoodSubmitException(code, 'Error'));
        }

        blocTest<HarmonyCubit, HarmonyState>(
          'maps moodAlreadySubmitted error',
          build: () {
            setupErrorTest(MoodSubmitErrorCode.moodAlreadySubmitted);
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'moodAlreadySubmitted',
                ),
              ],
        );

        blocTest<HarmonyCubit, HarmonyState>(
          'maps notPositiveMood error',
          build: () {
            setupErrorTest(MoodSubmitErrorCode.notPositiveMood);
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'notPositiveMood',
                ),
              ],
        );

        blocTest<HarmonyCubit, HarmonyState>(
          'maps mentionLimitExceeded error',
          build: () {
            setupErrorTest(MoodSubmitErrorCode.mentionLimitExceeded);
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'mentionLimitExceeded',
                ),
              ],
        );

        blocTest<HarmonyCubit, HarmonyState>(
          'maps duplicateMentions error',
          build: () {
            setupErrorTest(MoodSubmitErrorCode.duplicateMentions);
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'duplicateMentions',
                ),
              ],
        );

        blocTest<HarmonyCubit, HarmonyState>(
          'maps selfMentionNotAllowed error',
          build: () {
            setupErrorTest(MoodSubmitErrorCode.selfMentionNotAllowed);
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'selfMentionNotAllowed',
                ),
              ],
        );

        blocTest<HarmonyCubit, HarmonyState>(
          'maps mentionNotHomeMember error',
          build: () {
            setupErrorTest(MoodSubmitErrorCode.mentionNotHomeMember);
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'mentionNotHomeMember',
                ),
              ],
        );

        blocTest<HarmonyCubit, HarmonyState>(
          'maps invalidMentionUser error',
          build: () {
            setupErrorTest(MoodSubmitErrorCode.invalidMentionUser);
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'invalidMentionUser',
                ),
              ],
        );

        blocTest<HarmonyCubit, HarmonyState>(
          'maps forbidden error',
          build: () {
            setupErrorTest(MoodSubmitErrorCode.forbidden);
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'forbidden',
                ),
              ],
        );

        blocTest<HarmonyCubit, HarmonyState>(
          'maps unauthorized to forbidden',
          build: () {
            setupErrorTest(MoodSubmitErrorCode.unauthorized);
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'forbidden',
                ),
              ],
        );

        blocTest<HarmonyCubit, HarmonyState>(
          'maps invalidHome to unknown',
          build: () {
            setupErrorTest(MoodSubmitErrorCode.invalidHome);
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'unknown',
                ),
              ],
        );

        blocTest<HarmonyCubit, HarmonyState>(
          'maps unknown exceptions to unknown',
          build: () {
            when(
              () => moodRepo.submit(
                homeId: any(named: 'homeId'),
                mood: any(named: 'mood'),
                comment: any(named: 'comment'),
                addToWall: any(named: 'addToWall'),
                mentions: any(named: 'mentions'),
              ),
            ).thenThrow(Exception('Random error'));
            return buildCubit();
          },
          seed: () => const HarmonyState(selectedMood: MoodScale.sunny),
          act: (cubit) => cubit.submit(),
          expect:
              () => [
                isA<HarmonyState>(),
                isA<HarmonyState>().having(
                  (s) => s.submitError,
                  'submitError',
                  'unknown',
                ),
              ],
        );
      });
    });
  });

  group('HarmonyState', () {
    test('copyWith preserves values when not overridden', () {
      final state = HarmonyState(
        selectedMood: MoodScale.sunny,
        comment: 'Hello',
        addToWall: true,
        isSubmitting: true,
        submitSuccessTick: 5,
        submitError: 'error',
        members: [buildMember()],
        selectedMentions: const {'u1'},
        isLoadingMembers: true,
        membersLoadFailed: true,
      );

      final copied = state.copyWith(submitError: 'error');

      expect(copied.selectedMood, MoodScale.sunny);
      expect(copied.comment, 'Hello');
      expect(copied.addToWall, true);
      expect(copied.isSubmitting, true);
      expect(copied.submitSuccessTick, 5);
      expect(copied.members.length, 1);
      expect(copied.selectedMentions, {'u1'});
      expect(copied.isLoadingMembers, true);
      expect(copied.membersLoadFailed, true);
    });

    test('copyWith clears selectedMood with clearSelectedMood flag', () {
      const state = HarmonyState(selectedMood: MoodScale.sunny);
      final cleared = state.copyWith(clearSelectedMood: true);

      expect(cleared.selectedMood, isNull);
    });

    test('copyWith clears submitError when not passed', () {
      const state = HarmonyState(submitError: 'error');
      final copied = state.copyWith();

      expect(copied.submitError, isNull);
    });

    test('props includes all fields', () {
      const state1 = HarmonyState();
      const state2 = HarmonyState();

      expect(state1.props, state2.props);
    });
  });
}
