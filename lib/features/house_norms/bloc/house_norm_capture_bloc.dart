import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/core/forms/form_draft_storage.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/ui/enums/reflective_generation_mode.dart';

part 'house_norm_capture_event.dart';
part 'house_norm_capture_state.dart';

class HouseNormCaptureBloc
    extends HydratedBloc<HouseNormCaptureEvent, HouseNormCaptureState> {
  HouseNormCaptureBloc({
    required HouseNormsRepository repository,
    required List<HouseNormScenarioDefinition> scenarios,
    required String homeId,
    required String locale,
    Logger? logger,
  }) : _repository = repository,
       _scenarios = scenarios,
       _homeId = homeId,
       _locale = locale,
       _logger = logger ?? const DebugLogger(),
       _storageKey = FormDraftStorage.houseNormsKey(homeId: homeId),
       _scopeHash = FormDraftStorage.hashScope(homeId),
       super(HouseNormCaptureState.initial(scenarios)) {
    on<HouseNormCaptureOptionSelected>(_onOptionSelected);
    on<HouseNormCapturePreviousRequested>(_onPreviousRequested);
    on<HouseNormCaptureSubmitted>(_onSubmitted);
    on<HouseNormCaptureReflectionCompleted>(_onReflectionCompleted);
  }

  static const _formType = 'house_norms';
  static const _logTag = 'FormDraft';

  final HouseNormsRepository _repository;
  final List<HouseNormScenarioDefinition> _scenarios;
  final String _homeId;
  final String _locale;
  final Logger _logger;
  final String _storageKey;
  final String _scopeHash;

  @override
  String get id => _storageKey;

  @override
  String get storagePrefix => '';

  @override
  HouseNormCaptureState? fromJson(Map<String, dynamic> json) {
    final storedVersion = _parseInt(json['schemaVersion']);
    if (storedVersion != HouseNormCaptureState.schemaVersionV1) {
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
    return HouseNormCaptureState(
      scenarios: _scenarios,
      currentIndex: currentIndex,
      responses: responses,
      status: HouseNormCaptureStatus.idle,
      errorMessage: null,
      schemaVersion: HouseNormCaptureState.schemaVersionV1,
      isDirty: true,
      lastEditedAt: _parseDate(json['lastEditedAt']),
      generatedDocument: null,
      reflectiveMode: null,
      reflectionId: 0,
    );
  }

  @override
  Map<String, dynamic>? toJson(HouseNormCaptureState state) {
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
    HouseNormCaptureOptionSelected event,
    Emitter<HouseNormCaptureState> emit,
  ) {
    final responses = Map<String, int>.from(state.responses);
    responses[event.scenarioId] = event.optionIndex;
    final isLast = state.currentIndex >= _scenarios.length - 1;
    final nextIndex = isLast ? state.currentIndex : state.currentIndex + 1;
    emit(
      state.copyWith(
        responses: responses,
        currentIndex: nextIndex,
        status: HouseNormCaptureStatus.idle,
        errorMessage: null,
        isDirty: true,
        lastEditedAt: DateTime.now().toUtc(),
      ),
    );
  }

  void _onPreviousRequested(
    HouseNormCapturePreviousRequested event,
    Emitter<HouseNormCaptureState> emit,
  ) {
    if (state.currentIndex == 0) return;
    emit(
      state.copyWith(
        currentIndex: state.currentIndex - 1,
        status: HouseNormCaptureStatus.idle,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    HouseNormCaptureSubmitted event,
    Emitter<HouseNormCaptureState> emit,
  ) async {
    if (!state.isComplete ||
        state.status == HouseNormCaptureStatus.submitting ||
        state.status == HouseNormCaptureStatus.reflecting) {
      return;
    }
    emit(
      state.copyWith(
        status: HouseNormCaptureStatus.submitting,
        errorMessage: null,
      ),
    );
    try {
      final document = await _repository.generateForHome(
        homeId: _homeId,
        locale: _locale,
        inputs: state.responses,
      );
      await _clearDraftOnSubmit();
      emit(
        HouseNormCaptureState.initial(_scenarios).copyWith(
          status: HouseNormCaptureStatus.reflecting,
          generatedDocument: document,
          reflectiveMode: ReflectiveGenerationMode.houseNorms,
          reflectionId: state.reflectionId + 1,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HouseNormCaptureStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onReflectionCompleted(
    HouseNormCaptureReflectionCompleted event,
    Emitter<HouseNormCaptureState> emit,
  ) {
    if (state.status != HouseNormCaptureStatus.reflecting) return;
    emit(state.copyWith(status: HouseNormCaptureStatus.success));
  }

  Future<void> _clearDraftOnSubmit() async {
    await FormDraftStorage.clearHouseNormsDraft(_homeId);
    _logDraftEvent('form_draft_cleared_on_submit');
  }

  void _logDraftEvent(String event, {int? storedSchemaVersion}) {
    final version = storedSchemaVersion ?? HouseNormCaptureState.schemaVersionV1;
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
    if (currentIndex < 0 || currentIndex >= _scenarios.length) return false;
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
}
