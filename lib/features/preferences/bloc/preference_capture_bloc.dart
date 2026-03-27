import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/forms/form_draft_storage.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/ui/enums/reflective_generation_mode.dart';
import '../domain/preference_scenarios.dart';

part 'preference_capture_event.dart';
part 'preference_capture_state.dart';

class PreferenceCaptureBloc
    extends HydratedBloc<PreferenceCaptureEvent, PreferenceCaptureState> {
  PreferenceCaptureBloc({
    required PreferenceReportsRepository repository,
    required List<PreferenceScenarioDefinition> scenarios,
    required String userId,
    String? homeId,
    Map<String, int> initialResponses = const <String, int>{},
    Logger? logger,
  }) : _repository = repository,
       _scenarios = scenarios,
       _userId = userId,
       _homeId = homeId,
       _logger = logger ?? const DebugLogger(),
       _storageKey = FormDraftStorage.personalPreferencesKey(userId: userId),
       _scopeHash = FormDraftStorage.hashScope(userId),
       super(
         PreferenceCaptureState.initial(
           scenarios,
           initialResponses: _sanitizeInitialResponses(
             scenarios: scenarios,
             responses: initialResponses,
           ),
         ),
       ) {
    on<PreferenceCaptureOptionSelected>(_onOptionSelected);
    on<PreferenceCapturePreviousRequested>(_onPreviousRequested);
    on<PreferenceCaptureSubmitted>(_onSubmitted);
    on<PreferenceCaptureReflectionCompleted>(_onReflectionCompleted);
  }

  static const _formType = 'personal_preferences';
  static const _logTag = 'FormDraft';
  static const missingReportErrorCode = 'preference_report_missing';

  final PreferenceReportsRepository _repository;
  final List<PreferenceScenarioDefinition> _scenarios;
  final String _userId;
  final String? _homeId;
  final Logger _logger;
  final String _storageKey;
  final String _scopeHash;

  @override
  String get id => _storageKey;

  @override
  String get storagePrefix => '';

  @override
  PreferenceCaptureState? fromJson(Map<String, dynamic> json) {
    final storedVersion = _parseInt(json['schemaVersion']);
    if (storedVersion != PreferenceCaptureState.schemaVersionV1) {
      _logDraftEvent(
        'form_draft_schema_reset',
        storedSchemaVersion: storedVersion,
      );
      return null;
    }

    final isDirty = json['isDirty'] == true;
    if (!isDirty) return null;

    final currentIndex = _parseInt(json['currentStep']);
    final responses = _parseResponses(json['responses']);
    if (currentIndex == null || responses == null) {
      _logDraftEvent(
        'form_draft_schema_reset',
        storedSchemaVersion: storedVersion,
      );
      return null;
    }
    if (!_isValidState(currentIndex, responses)) {
      _logDraftEvent(
        'form_draft_schema_reset',
        storedSchemaVersion: storedVersion,
      );
      return null;
    }

    _logDraftEvent('form_draft_restored', storedSchemaVersion: storedVersion);
    return PreferenceCaptureState(
      scenarios: _scenarios,
      currentIndex: currentIndex,
      responses: responses,
      status: PreferenceCaptureStatus.idle,
      errorMessage: null,
      schemaVersion: PreferenceCaptureState.schemaVersionV1,
      isDirty: true,
      lastEditedAt: _parseDate(json['lastEditedAt']),
      generatedReport: null,
      reflectiveMode: null,
      reflectionId: 0,
    );
  }

  @override
  Map<String, dynamic>? toJson(PreferenceCaptureState state) {
    if (!state.isDirty) return null;
    return {
      'schemaVersion': state.schemaVersion,
      'currentStep': state.currentIndex,
      'responses': state.responses,
      'isDirty': state.isDirty,
      'lastEditedAt': state.lastEditedAt?.toIso8601String(),
    };
  }

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
        isDirty: true,
        lastEditedAt: DateTime.now().toUtc(),
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
    if (!state.isComplete ||
        state.status == PreferenceCaptureStatus.submitting ||
        state.status == PreferenceCaptureStatus.reflecting) {
      return;
    }
    emit(
      state.copyWith(
        status: PreferenceCaptureStatus.submitting,
        errorMessage: null,
      ),
    );
    try {
      await _repository.submitResponses(state.responses);
      final resolution = await _repository.getTemplateResolution();
      await _repository.generateReport(locale: resolution.resolvedLocale);
      final homeId = _homeId;
      final report =
          homeId == null
              ? await _repository.getPersonalReport(
                locale: resolution.resolvedLocale,
              )
              : await _repository.getReportForHome(
                homeId: homeId,
                subjectUserId: _userId,
                locale: resolution.resolvedLocale,
              );
      if (report == null) {
        await _clearDraftOnSubmit();
        emit(
          PreferenceCaptureState.initial(_scenarios).copyWith(
            status: PreferenceCaptureStatus.failure,
            errorMessage: missingReportErrorCode,
          ),
        );
        return;
      }
      await _clearDraftOnSubmit();
      emit(
        PreferenceCaptureState.initial(_scenarios).copyWith(
          status: PreferenceCaptureStatus.reflecting,
          generatedReport: report,
          reflectiveMode: ReflectiveGenerationMode.personalPreferences,
          reflectionId: state.reflectionId + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PreferenceCaptureStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onReflectionCompleted(
    PreferenceCaptureReflectionCompleted event,
    Emitter<PreferenceCaptureState> emit,
  ) {
    if (state.status != PreferenceCaptureStatus.reflecting) return;
    emit(state.copyWith(status: PreferenceCaptureStatus.success));
  }

  Future<void> _clearDraftOnSubmit() async {
    await FormDraftStorage.clearPersonalPreferencesDraft(_userId);
    _logDraftEvent('form_draft_cleared_on_submit');
  }

  void _logDraftEvent(String event, {int? storedSchemaVersion}) {
    final version =
        storedSchemaVersion ?? PreferenceCaptureState.schemaVersionV1;
    _logger.info(
      '$event form=$_formType scope=$_scopeHash schemaVersion=$version',
      tag: _logTag,
    );
  }

  int? _parseInt(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return null;
  }

  Map<String, int>? _parseResponses(Object? raw) {
    if (raw is! Map) return null;
    final responses = <String, int>{};
    for (final entry in raw.entries) {
      final key = entry.key;
      if (key is! String) return null;
      final index = _parseInt(entry.value);
      if (index == null) return null;
      responses[key] = index;
    }
    return responses;
  }

  bool _isValidState(int currentIndex, Map<String, int> responses) {
    if (currentIndex < 0 || currentIndex >= _scenarios.length) {
      return false;
    }
    if (responses.length > _scenarios.length) return false;
    final scenarioLengths = <String, int>{
      for (final scenario in _scenarios) scenario.id: scenario.options.length,
    };
    for (final entry in responses.entries) {
      final length = scenarioLengths[entry.key];
      if (length == null) return false;
      if (entry.value < 0 || entry.value >= length) return false;
    }
    return true;
  }

  DateTime? _parseDate(Object? raw) {
    if (raw is! String) return null;
    return DateTime.tryParse(raw);
  }

  static Map<String, int> _sanitizeInitialResponses({
    required List<PreferenceScenarioDefinition> scenarios,
    required Map<String, int> responses,
  }) {
    final optionLengths = <String, int>{
      for (final scenario in scenarios) scenario.id: scenario.options.length,
    };
    final sanitized = <String, int>{};
    for (final entry in responses.entries) {
      final length = optionLengths[entry.key];
      if (length == null) continue;
      final value = entry.value;
      if (value < 0 || value >= length) continue;
      sanitized[entry.key] = value;
    }
    return sanitized;
  }
}
