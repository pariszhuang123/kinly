import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/chores/models.dart';
import 'package:kinly/core/media/expectation_photo_service.dart';
import 'package:kinly/core/paywall/paywall_gate.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/data/repositories/chores_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/features/flow/bloc/flow_chore_bloc.dart';

class _MockChoresRepository extends Mock implements ChoresRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockExpectationPhotoService extends Mock
    implements ExpectationPhotoService {}

void main() {
  late _MockChoresRepository choresRepository;
  late _MockHomeRepository homeRepository;
  late _MockExpectationPhotoService expectationPhotoService;

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
      homeRepository: homeRepository,
      expectationPhotoService: expectationPhotoService,
    );
  }

  setUpAll(() {
    registerFallbackValue(ChoreRecurrence.none);
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    choresRepository = _MockChoresRepository();
    homeRepository = _MockHomeRepository();
    expectationPhotoService = _MockExpectationPhotoService();
    when(() => homeRepository.getCurrentMembership())
        .thenAnswer((_) async => null);
    when(
      () => homeRepository.listActiveMembers(
        any(),
        excludeSelf: any(named: 'excludeSelf'),
      ),
    ).thenAnswer((_) async => const []);
    when(
      () => choresRepository.listAssigneesForHome(any()),
    ).thenAnswer((_) async => const []);
    when(
      () => expectationPhotoService.captureAndUpload(
        homeId: any(named: 'homeId'),
        choreId: any(named: 'choreId'),
      ),
    ).thenThrow(UnimplementedError());
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
    expect:
        () => [
          isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', false),
          isA<FlowChoreState>().having(
            (s) => s.form.title,
            'title',
            'Wash dishes',
          ),
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
    expect:
        () => [
          isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', false),
          isA<FlowChoreState>().having(
            (s) => s.form.title,
            'title',
            'Wash dishes',
          ),
          isA<FlowChoreState>().having(
            (s) => s.form.howToVideoUrl,
            'howToVideoUrl',
            '  https://example.com/video ',
          ),
          isA<FlowChoreState>().having(
            (s) => s.isSubmitting,
            'isSubmitting',
            true,
          ),
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

  blocTest<FlowChoreBloc, FlowChoreState>(
    'emits paywall gate request on paywall cap error',
    build: () => buildBloc(),
    setUp: () {
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
      ).thenThrow(ChoreException(ChoreErrorCode.paywallActiveCap, 'cap'));
    },
    act: (bloc) {
      bloc.add(const FlowChoreTitleChanged('Valid title'));
      bloc.add(const FlowChoreSubmitted());
    },
    expect: () => [
      isA<FlowChoreState>().having(
        (s) => s.form.title,
        'title updated',
        'Valid title',
      ),
      isA<FlowChoreState>().having(
        (s) => s.isSubmitting,
        'isSubmitting while sending',
        true,
      ),
      isA<FlowChoreState>()
          .having((s) => s.paywallRequestTick, 'paywallRequestTick', 1)
          .having(
            (s) => s.paywallRequest?.action,
            'action',
            PaywallRetryAction.submit,
          )
          .having((s) => s.paywallRequest?.homeId, 'homeId', 'home-1'),
    ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'retries submission after paywall resolved as granted',
    build: () => buildBloc(),
    setUp: () {
      var callCount = 0;
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
      ).thenAnswer((_) async {
        callCount += 1;
        if (callCount == 1) {
          throw ChoreException(ChoreErrorCode.paywallActiveCap, 'cap');
        }
        return sampleChore;
      });
    },
    act: (bloc) async {
      bloc.add(const FlowChoreTitleChanged('Valid title'));
      bloc.add(const FlowChoreSubmitted());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      final req = bloc.state.paywallRequest!;
      bloc.add(FlowChorePaywallOpened(req.requestId));
      bloc.add(
        FlowChorePaywallResolved(
          PaywallGateOutcome(
            requestId: req.requestId,
            action: PaywallRetryAction.submit,
            status: PaywallGateStatus.granted,
          ),
        ),
      );
    },
    expect: () => [
      isA<FlowChoreState>(),
      isA<FlowChoreState>().having((s) => s.isSubmitting, 'isSubmitting', true),
      isA<FlowChoreState>().having(
        (s) => s.paywallRequest?.action,
        'paywall request emitted',
        PaywallRetryAction.submit,
      ),
      isA<FlowChoreState>().having(
        (s) => s.paywallInFlightRequestId,
        'in-flight set',
        isNotNull,
      ),
      isA<FlowChoreState>().having(
        (s) => s.isSubmitting,
        'isSubmitting on retry',
        true,
      ),
      isA<FlowChoreState>().having(
        (s) => s.successChoreId,
        'success after retry',
        sampleChore.id,
      ),
    ],
  );
}
