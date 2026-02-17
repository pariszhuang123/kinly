part of 'house_norm_capture_bloc.dart';

enum HouseNormCaptureStatus { idle, submitting, reflecting, success, failure }

class HouseNormCaptureState extends Equatable {
  static const int schemaVersionV1 = 1;

  const HouseNormCaptureState({
    required this.scenarios,
    required this.currentIndex,
    required this.responses,
    required this.status,
    required this.schemaVersion,
    required this.isDirty,
    required this.lastEditedAt,
    required this.reflectionId,
    this.generatedDocument,
    this.reflectiveMode,
    this.errorMessage,
  });

  final List<HouseNormScenarioDefinition> scenarios;
  final int currentIndex;
  final Map<String, int> responses;
  final HouseNormCaptureStatus status;
  final int schemaVersion;
  final bool isDirty;
  final DateTime? lastEditedAt;
  final HouseNormDocument? generatedDocument;
  final ReflectiveGenerationMode? reflectiveMode;
  final int reflectionId;
  final String? errorMessage;

  factory HouseNormCaptureState.initial(
    List<HouseNormScenarioDefinition> scenarios,
  ) {
    return HouseNormCaptureState(
      scenarios: scenarios,
      currentIndex: 0,
      responses: const {},
      status: HouseNormCaptureStatus.idle,
      schemaVersion: schemaVersionV1,
      isDirty: false,
      lastEditedAt: null,
      generatedDocument: null,
      reflectiveMode: null,
      reflectionId: 0,
    );
  }

  HouseNormCaptureState copyWith({
    int? currentIndex,
    Map<String, int>? responses,
    HouseNormCaptureStatus? status,
    String? errorMessage,
    bool? isDirty,
    DateTime? lastEditedAt,
    HouseNormDocument? generatedDocument,
    ReflectiveGenerationMode? reflectiveMode,
    int? reflectionId,
  }) {
    return HouseNormCaptureState(
      scenarios: scenarios,
      currentIndex: currentIndex ?? this.currentIndex,
      responses: responses ?? this.responses,
      status: status ?? this.status,
      errorMessage: errorMessage,
      schemaVersion: schemaVersion,
      isDirty: isDirty ?? this.isDirty,
      lastEditedAt: lastEditedAt ?? this.lastEditedAt,
      generatedDocument: generatedDocument ?? this.generatedDocument,
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
    generatedDocument,
    reflectiveMode,
    reflectionId,
    errorMessage,
  ];
}
