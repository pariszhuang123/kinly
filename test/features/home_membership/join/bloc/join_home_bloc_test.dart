import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/data/repositories/home_repository.dart';
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
      when(() => homeRepository.join(any())).thenAnswer((_) async {});
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
        () => [
          const JoinHomeState(
            code: 'CODE99',
            status: JoinHomeStatus.submitting,
          ),
          isA<JoinHomeState>().having(
            (s) => s.status,
            'status',
            JoinHomeStatus.failure,
          ),
        ],
    verify: (_) {
      verify(() => homeRepository.join('CODE99')).called(1);
    },
  );
}
