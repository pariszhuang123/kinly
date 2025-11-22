import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/chores/models.dart';
import 'package:kinly/data/repositories/chores_repository.dart';
import 'package:kinly/features/flow/bloc/flow_chore_bloc.dart';

class _MockChoresRepository extends Mock implements ChoresRepository {}

void main() {
  late _MockChoresRepository choresRepository;

  final sampleChore = Chore(
    id: 'chore-123',
    homeId: 'home-1',
    createdByUserId: 'owner',
    assigneeUserId: null,
    name: 'Test chore',
    startDate: DateTime.utc(2024, 1, 1),
    recurrence: ChoreRecurrence.none,
    recurrenceCursor: null,
    nextOccurrence: null,
    expectationPhotoPath: null,
    howToVideoUrl: 'https://example.com/howto',
    notes: null,
    state: ChoreState.draft,
    completedAt: null,
    createdAt: DateTime.utc(2024, 1, 1),
    updatedAt: DateTime.utc(2024, 1, 1),
  );

  FlowChoreBloc buildBloc() {
    return FlowChoreBloc(
      homeId: 'home-1',
      choresRepository: choresRepository,
    );
  }

  setUpAll(() {
    registerFallbackValue(ChoreRecurrence.none);
  });

  setUp(() {
    choresRepository = _MockChoresRepository();
    when(() => choresRepository.listAssigneesForHome(any()))
        .thenAnswer((_) async => const []);
  });

  blocTest<FlowChoreBloc, FlowChoreState>(
    'blocks submission and shows validation error when how-to url is invalid',
    build: () => buildBloc(),
    act: (bloc) async {
      bloc.add(const FlowChoreStarted());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const FlowChoreTitleChanged('Wash dishes'));
      bloc.add(const FlowChoreHowToChanged('ftp://not-allowed'));
      bloc.add(const FlowChoreSubmitted());
    },
    expect: () => [
      isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', true),
      isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', false),
      isA<FlowChoreState>().having((s) => s.form.title, 'title', 'Wash dishes'),
      isA<FlowChoreState>().having(
        (s) => s.form.howToVideoUrl,
        'howToVideoUrl',
        'ftp://not-allowed',
      ),
      isA<FlowChoreState>().having(
        (s) => s.showValidationErrors,
        'showValidationErrors',
        true,
      ),
    ],
    verify: (_) {
      verify(() => choresRepository.listAssigneesForHome('home-1')).called(1);
      verifyNever(
        () => choresRepository.create(
          homeId: any(named: 'homeId'),
          name: any(named: 'name'),
          assigneeUserId: any(named: 'assigneeUserId'),
          startDate: any(named: 'startDate'),
          recurrence: any(named: 'recurrence'),
          notes: any(named: 'notes'),
          howToVideoUrl: any(named: 'howToVideoUrl'),
          expectationPhotoPath: any(named: 'expectationPhotoPath'),
        ),
      );
    },
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'submits when how-to url is valid and trims it',
    build: () => buildBloc(),
    act: (bloc) async {
      when(
        () => choresRepository.create(
          homeId: any(named: 'homeId'),
          name: any(named: 'name'),
          assigneeUserId: any(named: 'assigneeUserId'),
          startDate: any(named: 'startDate'),
          recurrence: any(named: 'recurrence'),
          notes: any(named: 'notes'),
          howToVideoUrl: any(named: 'howToVideoUrl'),
          expectationPhotoPath: any(named: 'expectationPhotoPath'),
        ),
      ).thenAnswer((_) async => sampleChore);

      bloc.add(const FlowChoreStarted());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const FlowChoreTitleChanged('Wash dishes'));
      bloc.add(const FlowChoreHowToChanged('  https://example.com/video '));
      bloc.add(const FlowChoreSubmitted());
    },
    expect: () => [
      isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', true),
      isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', false),
      isA<FlowChoreState>().having((s) => s.form.title, 'title', 'Wash dishes'),
      isA<FlowChoreState>().having(
        (s) => s.form.howToVideoUrl,
        'howToVideoUrl',
        '  https://example.com/video ',
      ),
      isA<FlowChoreState>().having((s) => s.isSubmitting, 'isSubmitting', true),
      isA<FlowChoreState>().having(
        (s) => s.successChoreId,
        'successChoreId',
        sampleChore.id,
      ),
    ],
    verify: (_) {
      verify(
        () => choresRepository.create(
          homeId: 'home-1',
          name: 'Wash dishes',
          assigneeUserId: null,
          startDate: any(named: 'startDate'),
          recurrence: ChoreRecurrence.none,
          notes: null,
          howToVideoUrl: 'https://example.com/video',
          expectationPhotoPath: null,
        ),
      ).called(1);
    },
  );
}
