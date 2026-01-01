import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/home/home.dart';
import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/features/home_membership/join/bloc/join_home_bloc.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late _MockHomeRepository homeRepository;

  setUp(() {
    homeRepository = _MockHomeRepository();
  });

  JoinHomeBloc buildBloc() => JoinHomeBloc(homeRepository: homeRepository);

  blocTest<JoinHomeBloc, JoinHomeState>(
    'updates code when JoinHomeCodeChanged is added',
    build: buildBloc,
    act: (bloc) => bloc.add(const JoinHomeCodeChanged(' ABC123 ')),
    expect:
        () => const [
          JoinHomeState(code: 'ABC123', status: JoinHomeStatus.editing),
        ],
  );

  blocTest<JoinHomeBloc, JoinHomeState>(
    'emits success when repository join succeeds',
    build: () {
      when(() => homeRepository.join(any())).thenAnswer(
        (_) async =>
            const HomeJoinResult(homeId: 'home-1', outcome: JoinOutcome.success),
      );
      return buildBloc();
    },
    seed:
        () =>
            const JoinHomeState(code: 'ABC123', status: JoinHomeStatus.editing),
    act: (bloc) => bloc.add(const JoinHomeSubmitted()),
    expect:
        () => const [
          JoinHomeState(code: 'ABC123', status: JoinHomeStatus.submitting),
          JoinHomeState(code: 'ABC123', status: JoinHomeStatus.success),
        ],
    verify: (_) {
      verify(() => homeRepository.join('ABC123')).called(1);
    },
  );

  blocTest<JoinHomeBloc, JoinHomeState>(
    'emits blocked when repository returns blocked outcome',
    build: () {
      when(() => homeRepository.join(any())).thenAnswer(
        (_) async =>
            const HomeJoinResult(homeId: 'home-1', outcome: JoinOutcome.blocked),
      );
      return buildBloc();
    },
    seed:
        () =>
            const JoinHomeState(code: 'CAP123', status: JoinHomeStatus.editing),
    act: (bloc) => bloc.add(const JoinHomeSubmitted()),
    expect:
        () => const [
          JoinHomeState(code: 'CAP123', status: JoinHomeStatus.submitting),
          JoinHomeState(code: 'CAP123', status: JoinHomeStatus.blocked),
        ],
    verify: (_) {
      verify(() => homeRepository.join('CAP123')).called(1);
    },
  );

  blocTest<JoinHomeBloc, JoinHomeState>(
    'emits failure when repository join throws',
    build: () {
      when(() => homeRepository.join(any())).thenThrow(Exception('boom'));
      return buildBloc();
    },
    seed:
        () =>
            const JoinHomeState(code: 'CODE99', status: JoinHomeStatus.editing),
    act: (bloc) => bloc.add(const JoinHomeSubmitted()),
    expect:
        () => const [
          JoinHomeState(code: 'CODE99', status: JoinHomeStatus.submitting),
          JoinHomeState(
            code: 'CODE99',
            status: JoinHomeStatus.failure,
            errorMessage: 'Exception: boom',
            errorType: JoinHomeErrorType.unknown,
          ),
        ],
    verify: (_) {
      verify(() => homeRepository.join('CODE99')).called(1);
    },
  );

  blocTest<JoinHomeBloc, JoinHomeState>(
    'surfaces friendly message when home is at the member limit',
    build: () {
      when(() => homeRepository.join(any())).thenThrow(
        HomeJoinException(
          JoinErrorCode.paywallLimitActiveMembers,
          'Free plan allows up to 4 active members per home.',
        ),
      );
      return buildBloc();
    },
    seed:
        () =>
            const JoinHomeState(code: 'FULLHM', status: JoinHomeStatus.editing),
    act: (bloc) => bloc.add(const JoinHomeSubmitted()),
    expect:
        () => const [
          JoinHomeState(code: 'FULLHM', status: JoinHomeStatus.submitting),
          JoinHomeState(
            code: 'FULLHM',
            status: JoinHomeStatus.failure,
            errorMessage: 'Free plan allows up to 4 active members per home.',
            errorType: JoinHomeErrorType.paywallLimit,
          ),
        ],
    verify: (_) {
      verify(() => homeRepository.join('FULLHM')).called(1);
    },
  );

  blocTest<JoinHomeBloc, JoinHomeState>(
    'maps inactive invite error',
    build: () {
      when(() => homeRepository.join(any())).thenThrow(
        HomeJoinException(
          JoinErrorCode.inactiveInvite,
          'Invite inactive',
        ),
      );
      return buildBloc();
    },
    seed: () => const JoinHomeState(code: 'INACTIVE', status: JoinHomeStatus.editing),
    act: (bloc) => bloc.add(const JoinHomeSubmitted()),
    expect: () => const [
      JoinHomeState(code: 'INACTIVE', status: JoinHomeStatus.submitting),
      JoinHomeState(
        code: 'INACTIVE',
        status: JoinHomeStatus.failure,
        errorMessage: 'Invite inactive',
        errorType: JoinHomeErrorType.inactiveInvite,
      ),
    ],
    verify: (_) => verify(() => homeRepository.join('INACTIVE')).called(1),
  );

  blocTest<JoinHomeBloc, JoinHomeState>(
    'maps unauthorized error',
    build: () {
      when(() => homeRepository.join(any())).thenThrow(
        HomeJoinException(
          JoinErrorCode.unauthorized,
          'Unauthorized',
        ),
      );
      return buildBloc();
    },
    seed: () => const JoinHomeState(code: 'UNAUTH', status: JoinHomeStatus.editing),
    act: (bloc) => bloc.add(const JoinHomeSubmitted()),
    expect: () => const [
      JoinHomeState(code: 'UNAUTH', status: JoinHomeStatus.submitting),
      JoinHomeState(
        code: 'UNAUTH',
        status: JoinHomeStatus.failure,
        errorMessage: 'Unauthorized',
        errorType: JoinHomeErrorType.unauthorized,
      ),
    ],
    verify: (_) => verify(() => homeRepository.join('UNAUTH')).called(1),
  );

  blocTest<JoinHomeBloc, JoinHomeState>(
    'maps forbidden error',
    build: () {
      when(() => homeRepository.join(any())).thenThrow(
        HomeJoinException(
          JoinErrorCode.forbidden,
          'Forbidden',
        ),
      );
      return buildBloc();
    },
    seed: () => const JoinHomeState(code: 'FORBID', status: JoinHomeStatus.editing),
    act: (bloc) => bloc.add(const JoinHomeSubmitted()),
    expect: () => const [
      JoinHomeState(code: 'FORBID', status: JoinHomeStatus.submitting),
      JoinHomeState(
        code: 'FORBID',
        status: JoinHomeStatus.failure,
        errorMessage: 'Forbidden',
        errorType: JoinHomeErrorType.forbidden,
      ),
    ],
    verify: (_) => verify(() => homeRepository.join('FORBID')).called(1),
  );
}
