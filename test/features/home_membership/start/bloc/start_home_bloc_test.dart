import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/home_membership/start/bloc/start_home_bloc.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/contracts/homes/models.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late _MockHomeRepository homeRepository;

  setUp(() {
    homeRepository = _MockHomeRepository();
  });

  blocTest<StartHomeBloc, StartHomeState>(
    'emits loading then success when create succeeds',
    build: () {
      when(
        () => homeRepository.create(),
      ).thenAnswer((_) async => const HomeCreationResult(homeId: 'home-123'));
      return StartHomeBloc(homeRepository);
    },
    act: (bloc) => bloc.add(const StartHomeCreateRequested()),
    expect:
        () => [
          isA<StartHomeState>()
              .having((s) => s.status, 'status', StartHomeStatus.loading)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<StartHomeState>().having(
            (s) => s.status,
            'status',
            StartHomeStatus.success,
          ),
        ],
    verify: (_) => verify(() => homeRepository.create()).called(1),
  );

  blocTest<StartHomeBloc, StartHomeState>(
    'emits failure when create throws',
    build: () {
      when(() => homeRepository.create()).thenThrow(Exception('boom'));
      return StartHomeBloc(homeRepository);
    },
    act: (bloc) => bloc.add(const StartHomeCreateRequested()),
    expect:
        () => [
          isA<StartHomeState>().having(
            (s) => s.status,
            'status',
            StartHomeStatus.loading,
          ),
          isA<StartHomeState>()
              .having((s) => s.status, 'status', StartHomeStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', 'Exception: boom'),
        ],
    verify: (_) => verify(() => homeRepository.create()).called(1),
  );

  blocTest<StartHomeBloc, StartHomeState>(
    'ignores duplicate create when already loading',
    build: () => StartHomeBloc(homeRepository),
    seed: () => const StartHomeState(status: StartHomeStatus.loading),
    act: (bloc) => bloc.add(const StartHomeCreateRequested()),
    expect: () => <StartHomeState>[],
    verify: (_) => verifyNever(() => homeRepository.create()),
  );
}
