import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import '../domain/preference_scenarios.dart';

part 'preference_capture_event.dart';
part 'preference_capture_state.dart';

class PreferenceCaptureBloc
    extends Bloc<PreferenceCaptureEvent, PreferenceCaptureState> {
  PreferenceCaptureBloc({
    required PreferenceReportsRepository repository,
    required List<PreferenceScenarioDefinition> scenarios,
  }) : _repository = repository,
       _scenarios = scenarios,
       super(PreferenceCaptureState.initial(scenarios)) {
    on<PreferenceCaptureOptionSelected>(_onOptionSelected);
    on<PreferenceCapturePreviousRequested>(_onPreviousRequested);
    on<PreferenceCaptureSubmitted>(_onSubmitted);
  }

  final PreferenceReportsRepository _repository;
  final List<PreferenceScenarioDefinition> _scenarios;

  void _onOptionSelected(
    PreferenceCaptureOptionSelected event,
    Emitter<PreferenceCaptureState> emit,
  ) {
    final responses = Map<String, int>.from(state.responses);
    responses[event.preferenceId] = event.optionIndex;
    final isLast = state.currentIndex >= _scenarios.length - 1;
    final nextIndex = isLast ? state.currentIndex : state.currentIndex + 1;
    emit(
      state.copyWith(
        responses: responses,
        currentIndex: nextIndex,
        status: PreferenceCaptureStatus.idle,
        errorMessage: null,
      ),
    );
  }

  void _onPreviousRequested(
    PreferenceCapturePreviousRequested event,
    Emitter<PreferenceCaptureState> emit,
  ) {
    if (state.currentIndex == 0) return;
    emit(
      state.copyWith(
        currentIndex: state.currentIndex - 1,
        status: PreferenceCaptureStatus.idle,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    PreferenceCaptureSubmitted event,
    Emitter<PreferenceCaptureState> emit,
  ) async {
    if (!state.isComplete || state.status == PreferenceCaptureStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: PreferenceCaptureStatus.submitting));
    try {
      await _repository.submitResponses(state.responses);
      final resolution = await _repository.getTemplateResolution();
      await _repository.generateReport(locale: resolution.resolvedLocale);
      emit(state.copyWith(status: PreferenceCaptureStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: PreferenceCaptureStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
