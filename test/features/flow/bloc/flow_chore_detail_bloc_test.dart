import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/chores/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/data/repositories/chores_repository.dart';
import 'package:kinly/features/flow/bloc/flow_chore_detail_bloc.dart';

class _MockChoresRepository extends Mock implements ChoresRepository {}

void main() {
  final sampleChore = Chore(
    id: 'chore-1',
    homeId: 'home-1',
    createdByUserId: 'owner',
    assigneeUserId: 'assignee',
    name: 'Wash dishes',
    startDate: DateTime.utc(2024, 1, 1),
    recurrence: ChoreRecurrence.none,
    recurrenceCursor: null,
    nextOccurrence: null,
    expectationPhotoPath: null,
    howToVideoUrl: null,
    notes: 'Use blue sponge',
    state: ChoreState.active,
    completedAt: null,
    createdAt: DateTime.utc(2024, 1, 1),
    updatedAt: DateTime.utc(2024, 1, 1),
  );

  final sampleDetails = ChoreDetails(
    chore: sampleChore,
    assignees: const [
      ChoreAssigneeSummary(userId: 'assignee', fullName: 'Jordan'),
    ],
  );

  final completionResult = ChoreCompletionResult(
    status: ChoreCompletionStatus.nonRecurringCompleted,
    choreId: 'chore-1',
    homeId: 'home-1',
    state: ChoreState.completed,
    recurrence: ChoreRecurrence.none,
    previousNextOccurrence: null,
    newNextOccurrence: null,
    stepsAdvanced: null,
  );

  late _MockChoresRepository choresRepository;

  FlowChoreDetailBloc buildBloc() {
    return FlowChoreDetailBloc(
      homeId: 'home-1',
      choreId: 'chore-1',
      choresRepository: choresRepository,
    );
  }

  setUp(() {
    choresRepository = _MockChoresRepository();
  });

  const initialState = FlowChoreDetailState.initial();
  final loadingState = initialState.copyWith(
    isLoading: true,
    clearLoadError: true,
  );

  blocTest<FlowChoreDetailBloc, FlowChoreDetailState>(
    'emits loaded state when details resolve',
    build: () {
      when(
        () => choresRepository.getForHome(
          homeId: any(named: 'homeId'),
          choreId: any(named: 'choreId'),
        ),
      ).thenAnswer((_) async => sampleDetails);
      return buildBloc();
    },
    act: (bloc) => bloc.add(const FlowChoreDetailStarted()),
    expect:
        () => [
          loadingState,
          initialState.copyWith(
            isLoading: false,
            details: sampleDetails,
            clearLoadError: true,
          ),
        ],
    verify: (_) {
      verify(
        () => choresRepository.getForHome(
          homeId: any(named: 'homeId'),
          choreId: any(named: 'choreId'),
        ),
      ).called(1);
    },
  );

  blocTest<FlowChoreDetailBloc, FlowChoreDetailState>(
    'captures error when details fail to resolve',
    build: () {
      when(
        () => choresRepository.getForHome(
          homeId: any(named: 'homeId'),
          choreId: any(named: 'choreId'),
        ),
      ).thenThrow(Exception('boom'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const FlowChoreDetailStarted()),
    expect:
        () => [
          loadingState,
          initialState.copyWith(
            isLoading: false,
            loadErrorMessage: 'Exception: boom',
          ),
        ],
  );

  blocTest<FlowChoreDetailBloc, FlowChoreDetailState>(
    'emits completion result when complete succeeds',
    build: () {
      when(
        () => choresRepository.complete(any()),
      ).thenAnswer((_) async => completionResult);
      return buildBloc();
    },
    act: (bloc) => bloc.add(const FlowChoreDetailCompletionRequested()),
    expect:
        () => [
          initialState.copyWith(
            isCompleting: true,
            clearCompletionError: true,
            clearCompletionResult: true,
          ),
          initialState.copyWith(
            isCompleting: false,
            completionResult: completionResult,
            clearCompletionError: true,
          ),
        ],
  );

  blocTest<FlowChoreDetailBloc, FlowChoreDetailState>(
    'emits completion error when complete fails',
    build: () {
      when(
        () => choresRepository.complete(any()),
      ).thenThrow(const ChoreException(ChoreErrorCode.unknown, 'not allowed'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const FlowChoreDetailCompletionRequested()),
    expect:
        () => [
          initialState.copyWith(
            isCompleting: true,
            clearCompletionError: true,
            clearCompletionResult: true,
          ),
          initialState.copyWith(
            isCompleting: false,
            completionErrorMessage: 'not allowed',
            completionErrorTick: 1,
            clearCompletionResult: true,
          ),
        ],
  );
}
