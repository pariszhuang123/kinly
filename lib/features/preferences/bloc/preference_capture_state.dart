part of 'preference_capture_bloc.dart';

enum PreferenceCaptureStatus { idle, submitting, reflecting, success, failure }

class PreferenceCaptureState extends Equatable {
  static const int schemaVersionV1 = 1;

  const PreferenceCaptureState({
    required this.scenarios,
    required this.currentIndex,
    required this.responses,
    required this.status,
    required this.schemaVersion,
    required this.isDirty,
    required this.lastEditedAt,
    required this.reflectionId,
    this.generatedReport,
    this.reflectiveMode,
    this.errorMessage,
  });

  final List<PreferenceScenarioDefinition> scenarios;
  final int currentIndex;
  final Map<String, int> responses;
  final PreferenceCaptureStatus status;
  final int schemaVersion;
  final bool isDirty;
  final DateTime? lastEditedAt;
  final PreferenceReport? generatedReport;
  final ReflectiveGenerationMode? reflectiveMode;
  final int reflectionId;
  final String? errorMessage;

  factory PreferenceCaptureState.initial(
    List<PreferenceScenarioDefinition> scenarios,
    {Map<String, int> initialResponses = const <String, int>{}}
  ) {
    final responses = Map<String, int>.unmodifiable(initialResponses);
    final currentIndex = _firstUnansweredIndex(
      scenarios: scenarios,
      responses: responses,
    );
    return PreferenceCaptureState(
      scenarios: scenarios,
      currentIndex: currentIndex,
      responses: responses,
      status: PreferenceCaptureStatus.idle,
      schemaVersion: schemaVersionV1,
      isDirty: responses.isNotEmpty,
      lastEditedAt: null,
      generatedReport: null,
      reflectiveMode: null,
      reflectionId: 0,
    );
  }

  PreferenceCaptureState copyWith({
    int? currentIndex,
    Map<String, int>? responses,
    PreferenceCaptureStatus? status,
    String? errorMessage,
    bool? isDirty,
    DateTime? lastEditedAt,
    PreferenceReport? generatedReport,
    ReflectiveGenerationMode? reflectiveMode,
    int? reflectionId,
  }) {
    return PreferenceCaptureState(
      scenarios: scenarios,
      currentIndex: currentIndex ?? this.currentIndex,
      responses: responses ?? this.responses,
      status: status ?? this.status,
      errorMessage: errorMessage,
      schemaVersion: schemaVersion,
      isDirty: isDirty ?? this.isDirty,
      lastEditedAt: lastEditedAt ?? this.lastEditedAt,
      generatedReport: generatedReport ?? this.generatedReport,
      reflectiveMode: reflectiveMode ?? this.reflectiveMode,
      reflectionId: reflectionId ?? this.reflectionId,
    );
  }

  bool get isComplete => responses.length == scenarios.length;

  @override
  List<Object?> get props => [
    scenarios,
    currentIndex,
    responses,
    status,
    schemaVersion,
    isDirty,
    lastEditedAt,
    generatedReport,
    reflectiveMode,
    reflectionId,
    errorMessage,
  ];
}

int _firstUnansweredIndex({
  required List<PreferenceScenarioDefinition> scenarios,
  required Map<String, int> responses,
}) {
  for (var index = 0; index < scenarios.length; index++) {
    if (!responses.containsKey(scenarios[index].id)) {
      return index;
    }
  }
  return scenarios.isEmpty ? 0 : scenarios.length - 1;
}
