import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/chores/models.dart';
import 'package:kinly/core/media/expectation_photo_service.dart';
import 'package:kinly/core/media/media_repository.dart';
import 'package:kinly/data/repositories/chores_repository.dart';
import 'package:kinly/features/flow/bloc/flow_chore_bloc.dart';

class _MockChoresRepository extends Mock implements ChoresRepository {}

class _MockExpectationPhotoService extends Mock
    implements ExpectationPhotoService {}

void main() {
  late ChoresRepository choresRepository;
  late ExpectationPhotoService photoService;

  setUp(() {
    choresRepository = _MockChoresRepository();
    photoService = _MockExpectationPhotoService();
  });

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(ChoreRecurrence.none);
  });

  test(
    'photo capture success toggles uploading state and stores public url',
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
                state.form.expectationPhotoPath == upload.publicUrl &&
                state.photoErrorMessage == null,
          ),
        ]),
      );
    },
  );

  test(
    'upload failure emits error tick and message',
    () async {
      when(
        () => photoService.captureAndUpload(
          homeId: any(named: 'homeId'),
          choreId: any(named: 'choreId'),
        ),
      ).thenThrow(Exception('upload failed'));

      final bloc = FlowChoreBloc(
        homeId: 'home-1',
        choresRepository: choresRepository,
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
    },
  );

  test(
    'submit sends stored expectation photo url to repository',
    () async {
      const photoUrl = 'https://example.com/photo.jpg';
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
      ).thenAnswer(
        (_) async => _fakeChore(
          id: 'chore-1',
          expectationPhotoPath: photoUrl,
        ),
      );

      final bloc = FlowChoreBloc(
        homeId: 'home-1',
        choresRepository: choresRepository,
        expectationPhotoService: photoService,
      );

      addTearDown(bloc.close);

      bloc.add(const FlowChoreTitleChanged('Test chore'));
      bloc.add(const FlowChorePhotoChanged(photoUrl));
      bloc.add(const FlowChoreSubmitted());

      final successState =
          await bloc.stream.firstWhere((state) => state.successChoreId != null);

      expect(successState.successChoreId, 'chore-1');
      expect(successState.form.expectationPhotoPath, photoUrl);
      verify(
        () => choresRepository.create(
          homeId: 'home-1',
          name: 'Test chore',
          assigneeUserId: null,
          startDate: any(named: 'startDate'),
          recurrence: ChoreRecurrence.none,
          notes: null,
          howToVideoUrl: null,
          expectationPhotoPath: photoUrl,
        ),
      ).called(1);
    },
  );

  test(
    'permission denial surfaces error and permanent flag',
    () async {
      when(
        () => photoService.captureAndUpload(
          homeId: any(named: 'homeId'),
          choreId: any(named: 'choreId'),
        ),
      ).thenThrow(CameraPermissionException(permanentlyDenied: true));

      final bloc = FlowChoreBloc(
        homeId: 'home-1',
        choresRepository: choresRepository,
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
    },
  );
}

Chore _fakeChore({
  required String id,
  String? expectationPhotoPath,
}) {
  final now = DateTime.now().toUtc();
  return Chore(
    id: id,
    homeId: 'home-1',
    createdByUserId: 'user-1',
    assigneeUserId: null,
    name: 'Test chore',
    startDate: now,
    recurrence: ChoreRecurrence.none,
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
