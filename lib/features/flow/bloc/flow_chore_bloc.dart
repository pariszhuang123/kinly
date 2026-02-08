import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../contracts/chores/models.dart';
import '../../../core/media/expectation_photo_service.dart';
import '../../../core/media/supabase_media_repository.dart';
import 'package:kinly/contracts/paywall/enums/paywall_retry_action.dart';
import 'package:kinly/contracts/paywall/enums/paywall_gate_status.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/ui/paywall/paywall_gate.dart';
import 'package:kinly/core/ui/paywall/paywall_sources.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import 'package:kinly/contracts/flow/ports/chores_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import '../domain/flow_chore_form.dart';

part 'flow_chore_event.dart';
part 'flow_chore_state.dart';

class FlowChoreBloc extends Bloc<FlowChoreEvent, FlowChoreState> {
  FlowChoreBloc({
    required String homeId,
    String? choreId,
    required ChoresRepository choresRepository,
    required HomeRepository homeRepository,
    ExpectationPhotoService? expectationPhotoService,
    Logger? logger,
  }) : _homeId = homeId,
       _choreId = choreId,
       _choresRepository = choresRepository,
       _homeRepository = homeRepository,
       _expectationPhotoService =
           expectationPhotoService ??
           ExpectationPhotoService(mediaRepository: SupabaseMediaRepository()),
       _logger = logger ?? const DebugLogger(),
       _uuid = const Uuid(),
       super(
         FlowChoreState.initial(
           isEditMode: choreId != null,
           initialStartDate: DateTime.now(),
         ),
       ) {
    on<FlowChoreStarted>(_onStarted);
    on<FlowChoreTitleChanged>(_onTitleChanged);
    on<FlowChoreAssigneeChanged>(_onAssigneeChanged);
    on<FlowChoreStartDateChanged>(_onStartDateChanged);
    on<FlowChoreRecurrenceToggled>(_onRecurrenceToggled);
    on<FlowChoreRecurrenceEveryChanged>(_onRecurrenceEveryChanged);
    on<FlowChoreRecurrenceUnitChanged>(_onRecurrenceUnitChanged);
    on<FlowChoreNotesChanged>(_onNotesChanged);
    on<FlowChoreHowToChanged>(_onHowToChanged);
    on<FlowChorePhotoChanged>(_onPhotoChanged);
    on<FlowChorePhotoCaptureRequested>(_onPhotoCaptureRequested);
    on<FlowChorePhotoRecoveryRequested>(_onPhotoRecoveryRequested);
    on<FlowChoreSubmitted>(_onSubmitted);
    on<FlowChoreDeleted>(_onDeleted);
    on<FlowChorePaywallOpened>(_onPaywallOpened);
    on<FlowChorePaywallResolved>(_onPaywallResolved);
  }

  final String _homeId;
  final String? _choreId;
  final ChoresRepository _choresRepository;
  final HomeRepository _homeRepository;
  final ExpectationPhotoService _expectationPhotoService;
  final Logger _logger;
  final Uuid _uuid;

  Future<void> _onStarted(
    FlowChoreStarted event,
    Emitter<FlowChoreState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearLoadError: true));
    try {
      final membership = await _homeRepository.getCurrentMembership();
      final members = await _homeRepository.listActiveMembers(
        _homeId,
        excludeSelf: false,
      );
      final ownerUserId =
          members.isNotEmpty
              ? members
                  .firstWhere(
                    (member) => member.isOwner,
                    orElse: () => members.first,
                  )
                  .userId
              : null;
      final assignees = await _choresRepository.listAssigneesForHome(_homeId);
      final assigneesWithOwner = assignees
          .map(
            (assignee) => assignee.copyWith(
              isOwner: ownerUserId != null && assignee.userId == ownerUserId,
            ),
          )
          .toList(growable: false);
      FlowChoreForm form = state.form;
      ChoreState? choreState = _choreId == null ? ChoreState.draft : null;

      if (_choreId != null) {
        final details = await _choresRepository.getForHome(
          homeId: _homeId,
          choreId: _choreId,
        );
        form = FlowChoreForm.fromChore(details.chore);
        choreState = details.chore.state;
      }

      emit(
        state.copyWith(
          isLoading: false,
          assignees: assigneesWithOwner,
          form: form,
          referenceForm: form,
          clearLoadError: true,
          currentUserId: membership?.userId,
          choreState: choreState,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isLoading: false, loadErrorMessage: error.toString()),
      );
    }
  }

  void _onTitleChanged(
    FlowChoreTitleChanged event,
    Emitter<FlowChoreState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(title: event.title)));
  }

  void _onAssigneeChanged(
    FlowChoreAssigneeChanged event,
    Emitter<FlowChoreState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(assigneeUserId: event.assigneeUserId),
      ),
    );
  }

  void _onStartDateChanged(
    FlowChoreStartDateChanged event,
    Emitter<FlowChoreState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(startDate: event.startDate)));
  }

  void _onRecurrenceToggled(
    FlowChoreRecurrenceToggled event,
    Emitter<FlowChoreState> emit,
  ) {
    if (!event.isRecurring) {
      emit(state.copyWith(form: state.form.copyWith(clearRecurrence: true)));
      return;
    }

    final nextEvery = state.form.recurrenceEvery ?? 1;
    final nextUnit = state.form.recurrenceUnit ?? ChoreRecurrenceUnit.week;
    emit(
      state.copyWith(
        form: state.form.copyWith(
          recurrenceEvery: nextEvery,
          recurrenceUnit: nextUnit,
        ),
      ),
    );
  }

  void _onRecurrenceEveryChanged(
    FlowChoreRecurrenceEveryChanged event,
    Emitter<FlowChoreState> emit,
  ) {
    final trimmed = event.value.trim();
    final every = trimmed.isEmpty ? null : int.tryParse(trimmed);
    emit(state.copyWith(form: state.form.copyWith(recurrenceEvery: every)));
  }

  void _onRecurrenceUnitChanged(
    FlowChoreRecurrenceUnitChanged event,
    Emitter<FlowChoreState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(recurrenceUnit: event.unit)));
  }

  void _onNotesChanged(
    FlowChoreNotesChanged event,
    Emitter<FlowChoreState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(notes: event.notes)));
  }

  void _onHowToChanged(
    FlowChoreHowToChanged event,
    Emitter<FlowChoreState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(howToVideoUrl: event.url)));
  }

  void _onPhotoChanged(
    FlowChorePhotoChanged event,
    Emitter<FlowChoreState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(expectationPhotoPath: event.photoPath),
      ),
    );
  }

  Future<void> _onPhotoCaptureRequested(
    FlowChorePhotoCaptureRequested event,
    Emitter<FlowChoreState> emit,
  ) async {
    if (state.isUploadingPhoto) return;
    _logger.info(
      'Flow photo capture started. homeId=$_homeId choreId=$_choreId',
      tag: 'FlowPhoto',
    );
    emit(
      state.copyWith(
        isUploadingPhoto: true,
        clearPhotoError: true,
        isCameraPermissionPermanentlyDenied: false,
      ),
    );

    try {
      final upload = await _expectationPhotoService.captureAndUpload(
        homeId: _homeId,
        choreId: _choreId,
        rootSegment: 'flow',
        featureSegment: 'expectations',
      );
      _logger.info(
        'Flow photo capture succeeded. homeId=$_homeId choreId=$_choreId '
        'storagePath=${upload.storagePath}',
        tag: 'FlowPhoto',
      );
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          form: state.form.copyWith(expectationPhotoPath: upload.storagePath),
          clearPhotoError: true,
        ),
      );
    } on CameraPermissionException catch (error) {
      _logger.warn(
        'Flow photo capture permission denied. homeId=$_homeId choreId=$_choreId '
        'permanentlyDenied=${error.permanentlyDenied}',
        tag: 'FlowPhoto',
        error: error,
      );
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          isCameraPermissionPermanentlyDenied: error.permanentlyDenied,
          photoErrorMessage: 'permission',
          photoErrorTick: state.photoErrorTick + 1,
        ),
      );
    } on CameraCaptureCancelled {
      _logger.info(
        'Flow photo capture cancelled. homeId=$_homeId choreId=$_choreId',
        tag: 'FlowPhoto',
      );
      emit(state.copyWith(isUploadingPhoto: false));
    } catch (error) {
      _logger.error(
        'Flow photo capture failed. homeId=$_homeId choreId=$_choreId',
        tag: 'FlowPhoto',
        error: error,
      );
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          photoErrorMessage: error.toString(),
          photoErrorTick: state.photoErrorTick + 1,
        ),
      );
    }
  }

  Future<void> _onPhotoRecoveryRequested(
    FlowChorePhotoRecoveryRequested event,
    Emitter<FlowChoreState> emit,
  ) async {
    if (state.isUploadingPhoto) return;
    emit(
      state.copyWith(
        isUploadingPhoto: true,
        clearPhotoError: true,
        isCameraPermissionPermanentlyDenied: false,
      ),
    );
    try {
      final upload = await _expectationPhotoService.recoverLostAndUploadIfPending(
        homeId: _homeId,
        choreId: _choreId,
        rootSegment: 'flow',
        featureSegment: 'expectations',
      );
      if (upload == null) {
        emit(state.copyWith(isUploadingPhoto: false));
        return;
      }
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          form: state.form.copyWith(expectationPhotoPath: upload.storagePath),
          clearPhotoError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          photoErrorMessage: error.toString(),
          photoErrorTick: state.photoErrorTick + 1,
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    FlowChoreSubmitted event,
    Emitter<FlowChoreState> emit,
  ) async {
    final form = state.form;
    if (!_isFormValid(form)) {
      emit(state.copyWith(showValidationErrors: true));
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        isDeleting: false,
        clearSuccess: true,
        clearSubmissionError: true,
      ),
    );

    try {
      final savedChore = await _submitForm(form);
      emit(
        state.copyWith(
          isSubmitting: false,
          referenceForm: state.form,
          successChoreId: savedChore.id,
          successWasDelete: false,
          showValidationErrors: false,
        ),
      );
    } on ChoreException catch (error) {
      if (_handlePaywall(error, emit)) return;
      _emitSubmissionError(emit, code: error.code, message: error.message);
    } catch (error) {
      _emitSubmissionError(emit, message: error.toString());
    }
  }

  bool _isFormValid(FlowChoreForm form) {
    final requiresAssignee = _choreId != null;
    final hasValidAssignee = !requiresAssignee || form.assigneeUserId != null;
    final hasValidDate = form.isStartDateInRange(DateTime.now());
    final hasValidHowTo = form.isHowToUrlValid;
    final hasValidRecurrence = !form.isRecurring || form.isRecurrenceValid;
    return form.isTitleValid &&
        hasValidAssignee &&
        hasValidDate &&
        hasValidHowTo &&
        hasValidRecurrence;
  }

  Future<Chore> _submitForm(FlowChoreForm form) {
    final normalizedNotes = _normalizeOptional(form.notes);
    final normalizedHowTo = form.normalizedHowToUrl;
    final normalizedPhoto = _normalizeOptional(form.expectationPhotoPath);
    final recurrenceEvery = form.isRecurring ? form.recurrenceEvery : null;
    final recurrenceUnit = form.isRecurring ? form.recurrenceUnit : null;
    if (_choreId == null) {
      return _choresRepository.create(
        homeId: _homeId,
        name: form.title.trim(),
        assigneeUserId: form.assigneeUserId,
        startDate: form.startDate,
        recurrenceEvery: recurrenceEvery,
        recurrenceUnit: recurrenceUnit,
        notes: normalizedNotes,
        howToVideoUrl: normalizedHowTo,
        expectationPhotoPath: normalizedPhoto,
      );
    }
    return _choresRepository.update(
      choreId: _choreId,
      name: form.title.trim(),
      assigneeUserId: form.assigneeUserId!,
      startDate: form.startDate,
      recurrenceEvery: recurrenceEvery,
      recurrenceUnit: recurrenceUnit,
      notes: normalizedNotes,
      howToVideoUrl: normalizedHowTo,
      expectationPhotoPath: normalizedPhoto,
    );
  }

  bool _handlePaywall(ChoreException error, Emitter<FlowChoreState> emit) {
    if (error.code != ChoreErrorCode.paywallActiveCap &&
        error.code != ChoreErrorCode.paywallMediaCap) {
      return false;
    }
    final triggers = <PaywallTrigger>{
      if (error.code == ChoreErrorCode.paywallActiveCap)
        PaywallTrigger.flowActiveCap
      else
        PaywallTrigger.flowPhotosCap,
    };
    final hasPhotoIntent = state.form.expectationPhotoPath.trim().isNotEmpty;
    if (error.code == ChoreErrorCode.paywallActiveCap && hasPhotoIntent) {
      triggers.add(PaywallTrigger.flowPhotosCap);
    }
    final tick = state.paywallRequestTick + 1;
    emit(
      state.copyWith(
        isSubmitting: false,
        isDeleting: false,
        clearSuccess: true,
        clearSubmissionError: true,
        paywallAction: PaywallRetryAction.submit,
        paywallRequestTick: tick,
        paywallRequest: PaywallGateRequest(
          requestId: _uuid.v4(),
          homeId: _homeId,
          source:
              _choreId == null
                  ? PaywallSources.flowCreateChore
                  : PaywallSources.flowEditChore,
          action: PaywallRetryAction.submit,
          tick: tick,
          triggers: triggers,
        ),
        paywallInFlightRequestId: null,
      ),
    );
    return true;
  }

  void _emitSubmissionError(
    Emitter<FlowChoreState> emit, {
    ChoreErrorCode? code,
    required String message,
  }) {
    emit(
      state.copyWith(
        isSubmitting: false,
        isDeleting: false,
        clearSuccess: true,
        submissionErrorCode: code,
        submissionErrorMessage: message,
        submissionErrorTick: state.submissionErrorTick + 1,
      ),
    );
  }

  String? _normalizeOptional(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed;
  }

  Future<void> _onDeleted(
    FlowChoreDeleted event,
    Emitter<FlowChoreState> emit,
  ) async {
    if (_choreId == null) return;
    emit(
      state.copyWith(
        isDeleting: true,
        isSubmitting: false,
        clearSubmissionError: true,
        clearSuccess: true,
      ),
    );

    try {
      await _choresRepository.cancel(_choreId);
      emit(
        state.copyWith(
          isDeleting: false,
          successChoreId: _choreId,
          successWasDelete: true,
        ),
      );
    } on ChoreException catch (error) {
      emit(
        state.copyWith(
          isDeleting: false,
          clearSuccess: true,
          submissionErrorCode: error.code,
          submissionErrorMessage: error.message,
          submissionErrorTick: state.submissionErrorTick + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isDeleting: false,
          clearSuccess: true,
          submissionErrorCode: null,
          submissionErrorMessage: error.toString(),
          submissionErrorTick: state.submissionErrorTick + 1,
        ),
      );
    }
  }

  void _onPaywallOpened(
    FlowChorePaywallOpened event,
    Emitter<FlowChoreState> emit,
  ) {
    emit(state.copyWith(paywallInFlightRequestId: event.requestId));
  }

  void _onPaywallResolved(
    FlowChorePaywallResolved event,
    Emitter<FlowChoreState> emit,
  ) {
    emit(state.copyWith(paywallInFlightRequestId: null));

    if (event.outcome.status == PaywallGateStatus.granted &&
        event.outcome.action == PaywallRetryAction.submit) {
      add(const FlowChoreSubmitted());
    }
  }
}
