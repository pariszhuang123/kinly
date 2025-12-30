import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../core/chores/models.dart';
import '../../../core/media/expectation_photo_service.dart';
import '../../../core/media/supabase_media_repository.dart';
import '../../../core/paywall/enums/paywall_retry_action.dart';
import '../../../core/paywall/enums/paywall_gate_status.dart';
import '../../../core/paywall/enums/paywall_trigger.dart';
import '../../../core/paywall/paywall_sources.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import 'package:kinly/features/flow/flow.dart';
import '../../../data/repositories/home_repository.dart';
import 'package:kinly/features/paywall/paywall.dart';
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
  }) : _homeId = homeId,
       _choreId = choreId,
       _choresRepository = choresRepository,
       _homeRepository = homeRepository,
       _expectationPhotoService =
           expectationPhotoService ??
           ExpectationPhotoService(mediaRepository: SupabaseMediaRepository()),
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
    on<FlowChoreRecurrenceChanged>(_onRecurrenceChanged);
    on<FlowChoreNotesChanged>(_onNotesChanged);
    on<FlowChoreHowToChanged>(_onHowToChanged);
    on<FlowChorePhotoChanged>(_onPhotoChanged);
    on<FlowChorePhotoCaptureRequested>(_onPhotoCaptureRequested);
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

  void _onRecurrenceChanged(
    FlowChoreRecurrenceChanged event,
    Emitter<FlowChoreState> emit,
  ) {
    emit(
      state.copyWith(form: state.form.copyWith(recurrence: event.recurrence)),
    );
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
      );
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          form: state.form.copyWith(expectationPhotoPath: upload.storagePath),
          clearPhotoError: true,
        ),
      );
    } on CameraPermissionException catch (error) {
      emit(
        state.copyWith(
          isUploadingPhoto: false,
          isCameraPermissionPermanentlyDenied: error.permanentlyDenied,
          photoErrorMessage: 'permission',
          photoErrorTick: state.photoErrorTick + 1,
        ),
      );
    } on CameraCaptureCancelled {
      emit(state.copyWith(isUploadingPhoto: false));
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
    final requiresAssignee = _choreId != null;
    final hasValidAssignee = !requiresAssignee || form.assigneeUserId != null;
    final hasValidDate = form.isStartDateInRange(DateTime.now());
    final hasValidHowTo = form.isHowToUrlValid;
    if (!form.isTitleValid ||
        !hasValidAssignee ||
        !hasValidDate ||
        !hasValidHowTo) {
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
      final normalizedNotes = _normalizeOptional(form.notes);
      final normalizedHowTo = form.normalizedHowToUrl;
      final normalizedPhoto = _normalizeOptional(form.expectationPhotoPath);

      final savedChore =
          _choreId == null
              ? await _choresRepository.create(
                homeId: _homeId,
                name: form.title.trim(),
                assigneeUserId: form.assigneeUserId,
                startDate: form.startDate,
                recurrence: form.recurrence,
                notes: normalizedNotes,
                howToVideoUrl: normalizedHowTo,
                expectationPhotoPath: normalizedPhoto,
              )
              : await _choresRepository.update(
                choreId: _choreId,
                name: form.title.trim(),
                assigneeUserId: form.assigneeUserId!,
                startDate: form.startDate,
                recurrence: form.recurrence,
                notes: normalizedNotes,
                howToVideoUrl: normalizedHowTo,
                expectationPhotoPath: normalizedPhoto,
              );

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
      if (error.code == ChoreErrorCode.paywallActiveCap ||
          error.code == ChoreErrorCode.paywallMediaCap) {
        final triggers = <PaywallTrigger>{
          if (error.code == ChoreErrorCode.paywallActiveCap)
            PaywallTrigger.flowActiveCap
          else
            PaywallTrigger.flowPhotosCap,
        };
        final hasPhotoIntent =
            state.form.expectationPhotoPath.trim().isNotEmpty;
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
        return;
      }

      emit(
        state.copyWith(
          isSubmitting: false,
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
          isSubmitting: false,
          isDeleting: false,
          clearSuccess: true,
          submissionErrorCode: null,
          submissionErrorMessage: error.toString(),
          submissionErrorTick: state.submissionErrorTick + 1,
        ),
      );
    }
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
