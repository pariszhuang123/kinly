part of 'preference_capture_bloc.dart';

abstract class PreferenceCaptureEvent extends Equatable {
  const PreferenceCaptureEvent();

  @override
  List<Object?> get props => [];
}

class PreferenceCaptureOptionSelected extends PreferenceCaptureEvent {
  const PreferenceCaptureOptionSelected({
    required this.preferenceId,
    required this.optionIndex,
  });

  final String preferenceId;
  final int optionIndex;

  @override
  List<Object?> get props => [preferenceId, optionIndex];
}

class PreferenceCapturePreviousRequested extends PreferenceCaptureEvent {
  const PreferenceCapturePreviousRequested();
}

class PreferenceCaptureSubmitted extends PreferenceCaptureEvent {
  const PreferenceCaptureSubmitted();
}

class PreferenceCaptureReflectionCompleted extends PreferenceCaptureEvent {
  const PreferenceCaptureReflectionCompleted();
}
