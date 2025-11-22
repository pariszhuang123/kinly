import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/chores/models.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import '../../../data/repositories/chores_repository.dart';
import '../domain/flow_chore_form.dart';

part 'flow_chore_event.dart';
part 'flow_chore_state.dart';

class FlowChoreBloc extends Bloc<FlowChoreEvent, FlowChoreState> {
  FlowChoreBloc({
    required String homeId,
    String? choreId,
    required ChoresRepository choresRepository,
  }) : _homeId = homeId,
       _choreId = choreId,
       _choresRepository = choresRepository,
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
    on<FlowChoreSubmitted>(_onSubmitted);
    on<FlowChoreDeleted>(_onDeleted);
  }

  final String _homeId;
  final String? _choreId;
  final ChoresRepository _choresRepository;

  Future<void> _onStarted(
    FlowChoreStarted event,
    Emitter<FlowChoreState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearLoadError: true));
    try {
      final assignees = await _choresRepository.listAssigneesForHome(_homeId);
      FlowChoreForm form = state.form;

      if (_choreId != null) {
        final details = await _choresRepository.getForHome(
          homeId: _homeId,
          choreId: _choreId,
        );
        form = FlowChoreForm.fromChore(details.chore);
      }

      emit(
        state.copyWith(
          isLoading: false,
          assignees: assignees,
          form: form,
          referenceForm: form,
          clearLoadError: true,
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

  Future<void> _onSubmitted(
    FlowChoreSubmitted event,
    Emitter<FlowChoreState> emit,
  ) async {
    final form = state.form;
    final requiresAssignee = _choreId != null;
    final hasValidAssignee = !requiresAssignee || form.assigneeUserId != null;
    final hasValidDate = form.isStartDateInRange(DateTime.now());
    final hasValidHowTo = form.isHowToUrlValid;
    if (!form.isTitleValid || !hasValidAssignee || !hasValidDate || !hasValidHowTo) {
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
}
