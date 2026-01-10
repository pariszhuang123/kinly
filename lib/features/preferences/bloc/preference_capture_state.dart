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
  ) {
    return PreferenceCaptureState(
      scenarios: scenarios,
      currentIndex: 0,
      responses: const {},
      status: PreferenceCaptureStatus.idle,
      schemaVersion: schemaVersionV1,
      isDirty: false,
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
