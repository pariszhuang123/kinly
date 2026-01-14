import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/core/media/expectation_photo_service.dart';
import 'package:kinly/features/paywall/paywall.dart';
import 'package:kinly/contracts/paywall/enums/paywall_retry_action.dart';
import 'package:kinly/contracts/paywall/enums/paywall_gate_status.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/features/flow/flow.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/features/flow/bloc/flow_chore_bloc.dart';
import 'package:kinly/features/flow/domain/flow_chore_form.dart';
import 'package:kinly/contracts/media/ports/media_repository.dart';

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
    recurrenceEvery: null,
    recurrenceUnit: null,
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
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    choresRepository = _MockChoresRepository();
    homeRepository = _MockHomeRepository();
    expectationPhotoService = _MockExpectationPhotoService();
    when(
      () => homeRepository.getCurrentMembership(),
    ).thenAnswer((_) async => null);
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
          recurrenceEvery: null,
          recurrenceUnit: null,
          notes: null,
          howToVideoUrl: 'https://example.com/video',
          expectationPhotoPath: null,
        ),
      ).called(1);
    },
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'recurrence toggle defaults to 1 week when empty',
    build: () => buildBloc(),
    act: (bloc) async {
      bloc.add(const FlowChoreStarted());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const FlowChoreRecurrenceToggled(true));
    },
    expect:
        () => [
          isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', false),
          isA<FlowChoreState>()
              .having((s) => s.form.recurrenceEvery, 'recurrenceEvery', 1)
              .having(
                (s) => s.form.recurrenceUnit,
                'recurrenceUnit',
                ChoreRecurrenceUnit.week,
              ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'submits recurrenceEvery/unit when recurring',
    build: () => buildBloc(),
    setUp: () {
      when(
        () => choresRepository.create(
          homeId: any(named: 'homeId'),
          name: any(named: 'name'),
          assigneeUserId: any(named: 'assigneeUserId'),
          startDate: any(named: 'startDate'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          notes: any(named: 'notes'),
          howToVideoUrl: any(named: 'howToVideoUrl'),
          expectationPhotoPath: any(named: 'expectationPhotoPath'),
        ),
      ).thenAnswer((_) async => sampleChore);
    },
    act: (bloc) async {
      bloc.add(const FlowChoreStarted());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const FlowChoreTitleChanged('Vacuum'));
      bloc.add(const FlowChoreRecurrenceToggled(true));
      bloc.add(const FlowChoreSubmitted());
    },
    verify: (_) {
      verify(
        () => choresRepository.create(
          homeId: 'home-1',
          name: 'Vacuum',
          assigneeUserId: null,
          startDate: any(named: 'startDate'),
          recurrenceEvery: 1,
          recurrenceUnit: ChoreRecurrenceUnit.week,
          notes: null,
          howToVideoUrl: null,
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
    expect:
        () => [
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
    'sets trigger for active cap with photo intent',
    build: () => buildBloc(),
    setUp: () {
      when(
        () => choresRepository.create(
          homeId: any(named: 'homeId'),
          name: any(named: 'name'),
          assigneeUserId: any(named: 'assigneeUserId'),
          startDate: any(named: 'startDate'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          notes: any(named: 'notes'),
          howToVideoUrl: any(named: 'howToVideoUrl'),
          expectationPhotoPath: any(named: 'expectationPhotoPath'),
        ),
      ).thenThrow(const ChoreException(ChoreErrorCode.paywallActiveCap, 'cap'));
    },
    act: (bloc) {
      bloc
        ..add(const FlowChoreTitleChanged('Valid title'))
        ..add(const FlowChorePhotoChanged('photo.jpg'))
        ..add(const FlowChoreSubmitted());
    },
    expect:
        () => [
          isA<FlowChoreState>(),
          isA<FlowChoreState>(),
          isA<FlowChoreState>(),
          isA<FlowChoreState>().having(
            (s) => s.paywallRequest?.triggers,
            'triggers',
            containsAll({
              PaywallTrigger.flowActiveCap,
              PaywallTrigger.flowPhotosCap,
            }),
          ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'sets trigger for media cap',
    build: () => buildBloc(),
    setUp: () {
      when(
        () => choresRepository.create(
          homeId: any(named: 'homeId'),
          name: any(named: 'name'),
          assigneeUserId: any(named: 'assigneeUserId'),
          startDate: any(named: 'startDate'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          notes: any(named: 'notes'),
          howToVideoUrl: any(named: 'howToVideoUrl'),
          expectationPhotoPath: any(named: 'expectationPhotoPath'),
        ),
      ).thenThrow(const ChoreException(ChoreErrorCode.paywallMediaCap, 'cap'));
    },
    act: (bloc) {
      bloc
        ..add(const FlowChoreTitleChanged('Valid title'))
        ..add(const FlowChorePhotoChanged('photo.jpg'))
        ..add(const FlowChoreSubmitted());
    },
    expect:
        () => [
          isA<FlowChoreState>(),
          isA<FlowChoreState>(),
          isA<FlowChoreState>(),
          isA<FlowChoreState>().having(
            (s) => s.paywallRequest?.triggers,
            'triggers',
            contains(PaywallTrigger.flowPhotosCap),
          ),
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
    expect:
        () => [
          isA<FlowChoreState>(),
          isA<FlowChoreState>().having(
            (s) => s.isSubmitting,
            'isSubmitting',
            true,
          ),
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

  blocTest<FlowChoreBloc, FlowChoreState>(
    'emits load error when started fails',
    build: () {
      when(
        () => homeRepository.getCurrentMembership(),
      ).thenThrow(Exception('Network error'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const FlowChoreStarted()),
    expect:
        () => [
          isA<FlowChoreState>().having((s) => s.isLoading, 'loading', true),
          isA<FlowChoreState>()
              .having((s) => s.isLoading, 'loading', false)
              .having(
                (s) => s.loadErrorMessage,
                'error',
                contains('Network error'),
              ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'updates assignee userId',
    build: () => buildBloc(),
    act: (bloc) => bloc.add(const FlowChoreAssigneeChanged('user-123')),
    expect:
        () => [
          isA<FlowChoreState>().having(
            (s) => s.form.assigneeUserId,
            'assigneeUserId',
            'user-123',
          ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'updates start date',
    build: () => buildBloc(),
    act: (bloc) => bloc.add(FlowChoreStartDateChanged(DateTime(2024, 6, 15))),
    expect:
        () => [
          isA<FlowChoreState>().having(
            (s) => s.form.startDate,
            'startDate',
            DateTime(2024, 6, 15),
          ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'clears recurrence when toggled off',
    build: () => buildBloc(),
    seed:
        () => FlowChoreState.initial(
          isEditMode: false,
          initialStartDate: DateTime.now(),
        ).copyWith(
          form: FlowChoreForm.initial(startDate: DateTime.now()).copyWith(
            recurrenceEvery: 2,
            recurrenceUnit: ChoreRecurrenceUnit.month,
          ),
        ),
    act: (bloc) => bloc.add(const FlowChoreRecurrenceToggled(false)),
    expect:
        () => [
          isA<FlowChoreState>()
              .having((s) => s.form.recurrenceEvery, 'recurrenceEvery', isNull)
              .having((s) => s.form.recurrenceUnit, 'recurrenceUnit', isNull),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'updates recurrence every value',
    build: () => buildBloc(),
    act: (bloc) => bloc.add(const FlowChoreRecurrenceEveryChanged('3')),
    expect:
        () => [
          isA<FlowChoreState>().having(
            (s) => s.form.recurrenceEvery,
            'recurrenceEvery',
            3,
          ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'parses recurrence every from string input',
    build: () => buildBloc(),
    act: (bloc) => bloc.add(const FlowChoreRecurrenceEveryChanged('3')),
    expect:
        () => [
          isA<FlowChoreState>().having(
            (s) => s.form.recurrenceEvery,
            'recurrenceEvery',
            3,
          ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'updates recurrence unit',
    build: () => buildBloc(),
    act:
        (bloc) => bloc.add(
          const FlowChoreRecurrenceUnitChanged(ChoreRecurrenceUnit.month),
        ),
    expect:
        () => [
          isA<FlowChoreState>().having(
            (s) => s.form.recurrenceUnit,
            'recurrenceUnit',
            ChoreRecurrenceUnit.month,
          ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'updates notes',
    build: () => buildBloc(),
    act: (bloc) => bloc.add(const FlowChoreNotesChanged('Clean thoroughly')),
    expect:
        () => [
          isA<FlowChoreState>().having(
            (s) => s.form.notes,
            'notes',
            'Clean thoroughly',
          ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'emits submission error when repository throws ChoreException',
    build: () {
      when(
        () => choresRepository.create(
          homeId: any(named: 'homeId'),
          name: any(named: 'name'),
          assigneeUserId: any(named: 'assigneeUserId'),
          startDate: any(named: 'startDate'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          notes: any(named: 'notes'),
          howToVideoUrl: any(named: 'howToVideoUrl'),
          expectationPhotoPath: any(named: 'expectationPhotoPath'),
        ),
      ).thenThrow(const ChoreException(ChoreErrorCode.notFound, 'Not found'));
      return buildBloc();
    },
    act: (bloc) {
      bloc.add(const FlowChoreTitleChanged('Valid title'));
      bloc.add(const FlowChoreSubmitted());
    },
    expect:
        () => [
          isA<FlowChoreState>(),
          isA<FlowChoreState>().having(
            (s) => s.isSubmitting,
            'isSubmitting',
            true,
          ),
          isA<FlowChoreState>()
              .having((s) => s.isSubmitting, 'isSubmitting', false)
              .having(
                (s) => s.submissionErrorCode,
                'code',
                ChoreErrorCode.notFound,
              )
              .having(
                (s) => s.submissionErrorMessage,
                'message',
                contains('Not found'),
              ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'emits submission error when repository throws generic error',
    build: () {
      when(
        () => choresRepository.create(
          homeId: any(named: 'homeId'),
          name: any(named: 'name'),
          assigneeUserId: any(named: 'assigneeUserId'),
          startDate: any(named: 'startDate'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          notes: any(named: 'notes'),
          howToVideoUrl: any(named: 'howToVideoUrl'),
          expectationPhotoPath: any(named: 'expectationPhotoPath'),
        ),
      ).thenThrow(Exception('Unexpected error'));
      return buildBloc();
    },
    act: (bloc) {
      bloc.add(const FlowChoreTitleChanged('Valid title'));
      bloc.add(const FlowChoreSubmitted());
    },
    expect:
        () => [
          isA<FlowChoreState>(),
          isA<FlowChoreState>().having(
            (s) => s.isSubmitting,
            'isSubmitting',
            true,
          ),
          isA<FlowChoreState>()
              .having((s) => s.isSubmitting, 'isSubmitting', false)
              .having((s) => s.submissionErrorCode, 'code', isNull)
              .having(
                (s) => s.submissionErrorMessage,
                'message',
                contains('Unexpected error'),
              ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'does nothing on delete when choreId is null',
    build: () => buildBloc(),
    act: (bloc) => bloc.add(const FlowChoreDeleted()),
    expect: () => <FlowChoreState>[],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'deletes chore successfully',
    build: () {
      when(
        () => choresRepository.cancel(any()),
      ).thenAnswer((_) async => sampleChore);
      return FlowChoreBloc(
        homeId: 'home-1',
        choreId: 'chore-123',
        choresRepository: choresRepository,
        homeRepository: homeRepository,
        expectationPhotoService: expectationPhotoService,
      );
    },
    act: (bloc) => bloc.add(const FlowChoreDeleted()),
    expect:
        () => [
          isA<FlowChoreState>().having((s) => s.isDeleting, 'deleting', true),
          isA<FlowChoreState>()
              .having((s) => s.isDeleting, 'deleting', false)
              .having((s) => s.successChoreId, 'successChoreId', 'chore-123')
              .having((s) => s.successWasDelete, 'successWasDelete', true),
        ],
    verify: (_) {
      verify(() => choresRepository.cancel('chore-123')).called(1);
    },
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'emits error when delete throws ChoreException',
    build: () {
      when(() => choresRepository.cancel(any())).thenThrow(
        const ChoreException(ChoreErrorCode.notFound, 'Chore not found'),
      );
      return FlowChoreBloc(
        homeId: 'home-1',
        choreId: 'chore-123',
        choresRepository: choresRepository,
        homeRepository: homeRepository,
        expectationPhotoService: expectationPhotoService,
      );
    },
    act: (bloc) => bloc.add(const FlowChoreDeleted()),
    expect:
        () => [
          isA<FlowChoreState>().having((s) => s.isDeleting, 'deleting', true),
          isA<FlowChoreState>()
              .having((s) => s.isDeleting, 'deleting', false)
              .having(
                (s) => s.submissionErrorCode,
                'code',
                ChoreErrorCode.notFound,
              )
              .having(
                (s) => s.submissionErrorMessage,
                'message',
                contains('Chore not found'),
              ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'uploads photo on capture success',
    build: () {
      when(
        () => expectationPhotoService.captureAndUpload(
          homeId: any(named: 'homeId'),
          choreId: any(named: 'choreId'),
        ),
      ).thenAnswer(
        (_) async => const MediaUploadResult(
          storagePath: 'photos/expectation.jpg',
          publicUrl: 'https://example.com/photos/expectation.jpg',
        ),
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const FlowChorePhotoCaptureRequested()),
    expect:
        () => [
          isA<FlowChoreState>().having(
            (s) => s.isUploadingPhoto,
            'uploading',
            true,
          ),
          isA<FlowChoreState>()
              .having((s) => s.isUploadingPhoto, 'uploading', false)
              .having(
                (s) => s.form.expectationPhotoPath,
                'path',
                'photos/expectation.jpg',
              ),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'emits camera permission error when permanently denied',
    build: () {
      when(
        () => expectationPhotoService.captureAndUpload(
          homeId: any(named: 'homeId'),
          choreId: any(named: 'choreId'),
        ),
      ).thenThrow(CameraPermissionException(permanentlyDenied: true));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const FlowChorePhotoCaptureRequested()),
    expect:
        () => [
          isA<FlowChoreState>().having(
            (s) => s.isUploadingPhoto,
            'uploading',
            true,
          ),
          isA<FlowChoreState>()
              .having((s) => s.isUploadingPhoto, 'uploading', false)
              .having(
                (s) => s.isCameraPermissionPermanentlyDenied,
                'permanentlyDenied',
                true,
              )
              .having((s) => s.photoErrorMessage, 'error', 'permission'),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'handles photo capture cancellation silently',
    build: () {
      when(
        () => expectationPhotoService.captureAndUpload(
          homeId: any(named: 'homeId'),
          choreId: any(named: 'choreId'),
        ),
      ).thenThrow(CameraCaptureCancelled());
      return buildBloc();
    },
    act: (bloc) => bloc.add(const FlowChorePhotoCaptureRequested()),
    expect:
        () => [
          isA<FlowChoreState>().having(
            (s) => s.isUploadingPhoto,
            'uploading',
            true,
          ),
          isA<FlowChoreState>()
              .having((s) => s.isUploadingPhoto, 'uploading', false)
              .having((s) => s.photoErrorMessage, 'error', isNull),
        ],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'does not retry photo capture when already uploading',
    build: () => buildBloc(),
    seed:
        () => FlowChoreState.initial(
          isEditMode: false,
          initialStartDate: DateTime.now(),
        ).copyWith(isUploadingPhoto: true),
    act: (bloc) => bloc.add(const FlowChorePhotoCaptureRequested()),
    expect: () => <FlowChoreState>[],
  );

  blocTest<FlowChoreBloc, FlowChoreState>(
    'paywall resolved does not retry when status is not granted',
    build: () => buildBloc(),
    seed:
        () => FlowChoreState.initial(
          isEditMode: false,
          initialStartDate: DateTime.now(),
        ).copyWith(paywallInFlightRequestId: 'req-123'),
    act:
        (bloc) => bloc.add(
          FlowChorePaywallResolved(
            PaywallGateOutcome(
              requestId: 'req-123',
              action: PaywallRetryAction.submit,
              status: PaywallGateStatus.cancelled,
            ),
          ),
        ),
    verify: (_) {
      verifyNever(
        () => choresRepository.create(
          homeId: any(named: 'homeId'),
          name: any(named: 'name'),
          assigneeUserId: any(named: 'assigneeUserId'),
          startDate: any(named: 'startDate'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          notes: any(named: 'notes'),
          howToVideoUrl: any(named: 'howToVideoUrl'),
          expectationPhotoPath: any(named: 'expectationPhotoPath'),
        ),
      );
    },
  );

  group('FlowChoreEvent props equality', () {
    test('FlowChoreStarted equality', () {
      expect(const FlowChoreStarted(), equals(const FlowChoreStarted()));
      expect(const FlowChoreStarted().props, isEmpty);
    });

    test('FlowChoreTitleChanged equality', () {
      const e1 = FlowChoreTitleChanged('A');
      const e2 = FlowChoreTitleChanged('A');
      const e3 = FlowChoreTitleChanged('B');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['A']));
    });

    test('FlowChoreAssigneeChanged equality', () {
      const e1 = FlowChoreAssigneeChanged('user-1');
      const e2 = FlowChoreAssigneeChanged('user-1');
      const e3 = FlowChoreAssigneeChanged(null);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['user-1']));
      expect(e3.props, equals([null]));
    });

    test('FlowChoreStartDateChanged equality', () {
      final date = DateTime.utc(2024, 6, 15);
      final e1 = FlowChoreStartDateChanged(date);
      final e2 = FlowChoreStartDateChanged(date);
      final e3 = FlowChoreStartDateChanged(DateTime.utc(2024, 6, 16));
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals([date]));
    });

    test('FlowChoreRecurrenceToggled equality', () {
      const e1 = FlowChoreRecurrenceToggled(true);
      const e2 = FlowChoreRecurrenceToggled(true);
      const e3 = FlowChoreRecurrenceToggled(false);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals([true]));
    });

    test('FlowChoreRecurrenceEveryChanged equality', () {
      const e1 = FlowChoreRecurrenceEveryChanged('3');
      const e2 = FlowChoreRecurrenceEveryChanged('3');
      const e3 = FlowChoreRecurrenceEveryChanged('5');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['3']));
    });

    test('FlowChoreRecurrenceUnitChanged equality', () {
      const e1 = FlowChoreRecurrenceUnitChanged(ChoreRecurrenceUnit.week);
      const e2 = FlowChoreRecurrenceUnitChanged(ChoreRecurrenceUnit.week);
      const e3 = FlowChoreRecurrenceUnitChanged(ChoreRecurrenceUnit.month);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals([ChoreRecurrenceUnit.week]));
    });

    test('FlowChoreNotesChanged equality', () {
      const e1 = FlowChoreNotesChanged('Note A');
      const e2 = FlowChoreNotesChanged('Note A');
      const e3 = FlowChoreNotesChanged('Note B');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['Note A']));
    });

    test('FlowChoreHowToChanged equality', () {
      const e1 = FlowChoreHowToChanged('https://a.com');
      const e2 = FlowChoreHowToChanged('https://a.com');
      const e3 = FlowChoreHowToChanged('https://b.com');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['https://a.com']));
    });

    test('FlowChorePhotoChanged equality', () {
      const e1 = FlowChorePhotoChanged('path/a.jpg');
      const e2 = FlowChorePhotoChanged('path/a.jpg');
      const e3 = FlowChorePhotoChanged('path/b.jpg');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['path/a.jpg']));
    });

    test('FlowChorePhotoCaptureRequested equality', () {
      expect(
        const FlowChorePhotoCaptureRequested(),
        equals(const FlowChorePhotoCaptureRequested()),
      );
      expect(const FlowChorePhotoCaptureRequested().props, isEmpty);
    });

    test('FlowChoreSubmitted equality', () {
      expect(const FlowChoreSubmitted(), equals(const FlowChoreSubmitted()));
      expect(const FlowChoreSubmitted().props, isEmpty);
    });

    test('FlowChoreDeleted equality', () {
      expect(const FlowChoreDeleted(), equals(const FlowChoreDeleted()));
      expect(const FlowChoreDeleted().props, isEmpty);
    });

    test('FlowChorePaywallOpened equality', () {
      const e1 = FlowChorePaywallOpened('req-1');
      const e2 = FlowChorePaywallOpened('req-1');
      const e3 = FlowChorePaywallOpened('req-2');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['req-1']));
    });

    test('FlowChorePaywallResolved equality', () {
      final outcome1 = PaywallGateOutcome(
        requestId: 'r1',
        action: PaywallRetryAction.submit,
        status: PaywallGateStatus.granted,
      );
      final outcome3 = PaywallGateOutcome(
        requestId: 'r2',
        action: PaywallRetryAction.submit,
        status: PaywallGateStatus.cancelled,
      );
      final e1 = FlowChorePaywallResolved(outcome1);
      final e1b = FlowChorePaywallResolved(outcome1);
      final e3 = FlowChorePaywallResolved(outcome3);
      expect(e1, equals(e1b));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, hasLength(1));
    });
  });

  group('additional handler coverage', () {
    blocTest<FlowChoreBloc, FlowChoreState>(
      'updates assignee via FlowChoreAssigneeChanged',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FlowChoreAssigneeChanged('user-abc')),
      expect:
          () => [
            isA<FlowChoreState>().having(
              (s) => s.form.assigneeUserId,
              'assigneeUserId',
              'user-abc',
            ),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'updates start date via FlowChoreStartDateChanged',
      build: () => buildBloc(),
      act: (bloc) {
        final date = DateTime(2025, 3, 20);
        bloc.add(FlowChoreStartDateChanged(date));
      },
      expect:
          () => [
            isA<FlowChoreState>().having(
              (s) => s.form.startDate,
              'startDate',
              DateTime(2025, 3, 20),
            ),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'clears recurrence when toggled off',
      build: () => buildBloc(),
      seed:
          () => FlowChoreState.initial(
            isEditMode: false,
            initialStartDate: DateTime.now(),
          ).copyWith(
            form: FlowChoreForm.initial(startDate: DateTime.now()).copyWith(
              recurrenceEvery: 2,
              recurrenceUnit: ChoreRecurrenceUnit.month,
            ),
          ),
      act: (bloc) => bloc.add(const FlowChoreRecurrenceToggled(false)),
      expect:
          () => [
            isA<FlowChoreState>()
                .having((s) => s.form.recurrenceEvery, 'recurrenceEvery', null)
                .having((s) => s.form.recurrenceUnit, 'recurrenceUnit', null),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'updates recurrence every via FlowChoreRecurrenceEveryChanged',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FlowChoreRecurrenceEveryChanged('4')),
      expect:
          () => [
            isA<FlowChoreState>().having(
              (s) => s.form.recurrenceEvery,
              'recurrenceEvery',
              4,
            ),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'updates recurrence unit via FlowChoreRecurrenceUnitChanged',
      build: () => buildBloc(),
      act:
          (bloc) => bloc.add(
            const FlowChoreRecurrenceUnitChanged(ChoreRecurrenceUnit.day),
          ),
      expect:
          () => [
            isA<FlowChoreState>().having(
              (s) => s.form.recurrenceUnit,
              'recurrenceUnit',
              ChoreRecurrenceUnit.day,
            ),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'updates notes via FlowChoreNotesChanged',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FlowChoreNotesChanged('Test notes')),
      expect:
          () => [
            isA<FlowChoreState>().having(
              (s) => s.form.notes,
              'notes',
              'Test notes',
            ),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'updates photo path via FlowChorePhotoChanged',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FlowChorePhotoChanged('photos/test.jpg')),
      expect:
          () => [
            isA<FlowChoreState>().having(
              (s) => s.form.expectationPhotoPath,
              'expectationPhotoPath',
              'photos/test.jpg',
            ),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'sets paywall in-flight request ID on FlowChorePaywallOpened',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const FlowChorePaywallOpened('req-xyz')),
      expect:
          () => [
            isA<FlowChoreState>().having(
              (s) => s.paywallInFlightRequestId,
              'paywallInFlightRequestId',
              'req-xyz',
            ),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'retries submission after paywall resolved with granted status',
      build: () {
        when(
          () => choresRepository.create(
            homeId: any(named: 'homeId'),
            name: any(named: 'name'),
            assigneeUserId: any(named: 'assigneeUserId'),
            startDate: any(named: 'startDate'),
            recurrenceEvery: any(named: 'recurrenceEvery'),
            recurrenceUnit: any(named: 'recurrenceUnit'),
            notes: any(named: 'notes'),
            howToVideoUrl: any(named: 'howToVideoUrl'),
            expectationPhotoPath: any(named: 'expectationPhotoPath'),
          ),
        ).thenAnswer((_) async => sampleChore);
        return buildBloc();
      },
      seed:
          () => FlowChoreState.initial(
            isEditMode: false,
            initialStartDate: DateTime.now(),
          ).copyWith(
            form: FlowChoreForm.initial(
              startDate: DateTime.now(),
            ).copyWith(title: 'Valid chore'),
            paywallInFlightRequestId: 'req-retry',
          ),
      act:
          (bloc) => bloc.add(
            FlowChorePaywallResolved(
              PaywallGateOutcome(
                requestId: 'req-retry',
                action: PaywallRetryAction.submit,
                status: PaywallGateStatus.granted,
              ),
            ),
          ),
      expect:
          () => [
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
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'emits load error when _onStarted fails',
      build: () {
        when(
          () => homeRepository.getCurrentMembership(),
        ).thenThrow(Exception('Network error'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const FlowChoreStarted()),
      expect:
          () => [
            isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', true),
            isA<FlowChoreState>()
                .having((s) => s.isLoading, 'isLoading', false)
                .having(
                  (s) => s.loadErrorMessage,
                  'loadErrorMessage',
                  contains('Network error'),
                ),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'loads chore details in edit mode',
      build: () {
        when(
          () => choresRepository.getForHome(
            homeId: any(named: 'homeId'),
            choreId: any(named: 'choreId'),
          ),
        ).thenAnswer(
          (_) async => ChoreDetails(
            chore: Chore(
              id: 'chore-123',
              homeId: 'home-1',
              createdByUserId: 'owner',
              assigneeUserId: null,
              name: 'Loaded chore',
              startDate: DateTime.utc(2024, 1, 1),
              recurrenceEvery: null,
              recurrenceUnit: null,
              recurrenceCursor: null,
              nextOccurrence: null,
              expectationPhotoPath: null,
              howToVideoUrl: null,
              notes: null,
              state: ChoreState.draft,
              completedAt: null,
              createdAt: DateTime.utc(2024, 1, 1),
              updatedAt: DateTime.utc(2024, 1, 1),
            ),
            assignees: const [],
          ),
        );
        return FlowChoreBloc(
          homeId: 'home-1',
          choreId: 'chore-123',
          choresRepository: choresRepository,
          homeRepository: homeRepository,
          expectationPhotoService: expectationPhotoService,
        );
      },
      act: (bloc) => bloc.add(const FlowChoreStarted()),
      expect:
          () => [
            isA<FlowChoreState>().having((s) => s.isLoading, 'isLoading', true),
            isA<FlowChoreState>()
                .having((s) => s.isLoading, 'isLoading', false)
                .having((s) => s.form.title, 'title', 'Loaded chore')
                .having((s) => s.choreState, 'choreState', ChoreState.draft),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'emits photo error on generic exception during capture',
      build: () {
        when(
          () => expectationPhotoService.captureAndUpload(
            homeId: any(named: 'homeId'),
            choreId: any(named: 'choreId'),
          ),
        ).thenThrow(Exception('Upload failed'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const FlowChorePhotoCaptureRequested()),
      expect:
          () => [
            isA<FlowChoreState>().having(
              (s) => s.isUploadingPhoto,
              'uploading',
              true,
            ),
            isA<FlowChoreState>()
                .having((s) => s.isUploadingPhoto, 'uploading', false)
                .having(
                  (s) => s.photoErrorMessage,
                  'error',
                  contains('Upload failed'),
                ),
          ],
    );

    blocTest<FlowChoreBloc, FlowChoreState>(
      'emits error when delete throws generic exception',
      build: () {
        when(
          () => choresRepository.cancel(any()),
        ).thenThrow(Exception('Delete failed'));
        return FlowChoreBloc(
          homeId: 'home-1',
          choreId: 'chore-123',
          choresRepository: choresRepository,
          homeRepository: homeRepository,
          expectationPhotoService: expectationPhotoService,
        );
      },
      act: (bloc) => bloc.add(const FlowChoreDeleted()),
      expect:
          () => [
            isA<FlowChoreState>().having((s) => s.isDeleting, 'deleting', true),
            isA<FlowChoreState>()
                .having((s) => s.isDeleting, 'deleting', false)
                .having((s) => s.submissionErrorCode, 'code', isNull)
                .having(
                  (s) => s.submissionErrorMessage,
                  'message',
                  contains('Delete failed'),
                ),
          ],
    );
  });
}
