import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/core/media/expectation_photo_service.dart';
import 'package:kinly/contracts/media/ports/media_repository.dart';
import 'package:kinly/features/flow/flow.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/features/flow/bloc/flow_chore_bloc.dart';

class _MockChoresRepository extends Mock implements ChoresRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockExpectationPhotoService extends Mock
    implements ExpectationPhotoService {}

void main() {
  late ChoresRepository choresRepository;
  late HomeRepository homeRepository;
  late ExpectationPhotoService photoService;

  setUp(() {
    choresRepository = _MockChoresRepository();
    homeRepository = _MockHomeRepository();
    photoService = _MockExpectationPhotoService();
    when(
      () => homeRepository.listActiveMembers(
        any(),
        excludeSelf: any(named: 'excludeSelf'),
      ),
    ).thenAnswer((_) async => const []);
  });

  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  test(
    'photo capture success toggles uploading state and stores storage path',
    () async {
      const upload = MediaUploadResult(
        storagePath: 'households/flow/expectations/home-1/temp/file.jpg',
        publicUrl: 'https://example.com/file.jpg',
      );
      when(
        () => photoService.captureAndUpload(
          homeId: any(named: 'homeId'),
          choreId: any(named: 'choreId'),
        ),
      ).thenAnswer((_) async => upload);

      final bloc = FlowChoreBloc(
        homeId: 'home-1',
        choresRepository: choresRepository,
        homeRepository: homeRepository,
        expectationPhotoService: photoService,
      );

      addTearDown(bloc.close);

      bloc.add(const FlowChorePhotoCaptureRequested());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<FlowChoreState>((state) => state.isUploadingPhoto),
          predicate<FlowChoreState>(
            (state) =>
                !state.isUploadingPhoto &&
                state.form.expectationPhotoPath == upload.storagePath &&
                state.photoErrorMessage == null,
          ),
        ]),
      );
    },
  );

  test('upload failure emits error tick and message', () async {
    when(
      () => photoService.captureAndUpload(
        homeId: any(named: 'homeId'),
        choreId: any(named: 'choreId'),
      ),
    ).thenThrow(Exception('upload failed'));

    final bloc = FlowChoreBloc(
      homeId: 'home-1',
      choresRepository: choresRepository,
      homeRepository: homeRepository,
      expectationPhotoService: photoService,
    );

    addTearDown(bloc.close);

    bloc.add(const FlowChorePhotoCaptureRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<FlowChoreState>((state) => state.isUploadingPhoto),
        predicate<FlowChoreState>(
          (state) =>
              !state.isUploadingPhoto &&
              state.photoErrorTick == 1 &&
              state.photoErrorMessage?.contains('upload failed') == true,
        ),
      ]),
    );
  });

  test('submit sends stored expectation photo path to repository', () async {
    const photoPath = 'flow/expectations/home-1/temp/file.jpg';
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
    ).thenAnswer(
      (_) async => _fakeChore(id: 'chore-1', expectationPhotoPath: photoPath),
    );

    final bloc = FlowChoreBloc(
      homeId: 'home-1',
      choresRepository: choresRepository,
      homeRepository: homeRepository,
      expectationPhotoService: photoService,
    );

    addTearDown(bloc.close);

    bloc.add(const FlowChoreTitleChanged('Test chore'));
    bloc.add(const FlowChorePhotoChanged(photoPath));
    bloc.add(const FlowChoreSubmitted());

    final successState = await bloc.stream.firstWhere(
      (state) => state.successChoreId != null,
    );

    expect(successState.successChoreId, 'chore-1');
    expect(successState.form.expectationPhotoPath, photoPath);
    verify(
      () => choresRepository.create(
        homeId: 'home-1',
        name: 'Test chore',
        assigneeUserId: null,
        startDate: any(named: 'startDate'),
        recurrenceEvery: null,
        recurrenceUnit: null,
        notes: null,
        howToVideoUrl: null,
        expectationPhotoPath: photoPath,
      ),
    ).called(1);
  });

  test('permission denial surfaces error and permanent flag', () async {
    when(
      () => photoService.captureAndUpload(
        homeId: any(named: 'homeId'),
        choreId: any(named: 'choreId'),
      ),
    ).thenThrow(CameraPermissionException(permanentlyDenied: true));

    final bloc = FlowChoreBloc(
      homeId: 'home-1',
      choresRepository: choresRepository,
      homeRepository: homeRepository,
      expectationPhotoService: photoService,
    );

    addTearDown(bloc.close);

    bloc.add(const FlowChorePhotoCaptureRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<FlowChoreState>((state) => state.isUploadingPhoto),
        predicate<FlowChoreState>(
          (state) =>
              !state.isUploadingPhoto &&
              state.photoErrorTick == 1 &&
              state.isCameraPermissionPermanentlyDenied,
        ),
      ]),
    );
  });
}

Chore _fakeChore({required String id, String? expectationPhotoPath}) {
  final now = DateTime.now().toUtc();
  return Chore(
    id: id,
    homeId: 'home-1',
    createdByUserId: 'user-1',
    assigneeUserId: null,
    name: 'Test chore',
    startDate: now,
    recurrenceEvery: null,
    recurrenceUnit: null,
    recurrenceCursor: null,
    nextOccurrence: null,
    expectationPhotoPath: expectationPhotoPath,
    howToVideoUrl: null,
    notes: null,
    state: ChoreState.active,
    completedAt: null,
    createdAt: now,
    updatedAt: now,
  );
}
