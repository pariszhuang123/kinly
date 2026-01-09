part of 'preference_capture_bloc.dart';

enum PreferenceCaptureStatus { idle, submitting, success, failure }

class PreferenceCaptureState extends Equatable {
  const PreferenceCaptureState({
    required this.scenarios,
    required this.currentIndex,
    required this.responses,
    required this.status,
    this.errorMessage,
  });

  final List<PreferenceScenarioDefinition> scenarios;
  final int currentIndex;
  final Map<String, int> responses;
  final PreferenceCaptureStatus status;
  final String? errorMessage;

  factory PreferenceCaptureState.initial(
    List<PreferenceScenarioDefinition> scenarios,
  ) {
    return PreferenceCaptureState(
      scenarios: scenarios,
      currentIndex: 0,
      responses: const {},
      status: PreferenceCaptureStatus.idle,
    );
  }

  PreferenceCaptureState copyWith({
    int? currentIndex,
    Map<String, int>? responses,
    PreferenceCaptureStatus? status,
    String? errorMessage,
  }) {
    return PreferenceCaptureState(
      scenarios: scenarios,
      currentIndex: currentIndex ?? this.currentIndex,
      responses: responses ?? this.responses,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  bool get isComplete => responses.length == scenarios.length;

  @override
  List<Object?> get props => [
    scenarios,
    currentIndex,
    responses,
    status,
    errorMessage,
  ];
}
