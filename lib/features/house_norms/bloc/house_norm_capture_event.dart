part of 'house_norm_capture_bloc.dart';

abstract class HouseNormCaptureEvent extends Equatable {
  const HouseNormCaptureEvent();

  @override
  List<Object?> get props => [];
}

class HouseNormCaptureOptionSelected extends HouseNormCaptureEvent {
  const HouseNormCaptureOptionSelected({
    required this.scenarioId,
    required this.optionIndex,
  });

  final String scenarioId;
  final int optionIndex;

  @override
  List<Object?> get props => [scenarioId, optionIndex];
}

class HouseNormCapturePreviousRequested extends HouseNormCaptureEvent {
  const HouseNormCapturePreviousRequested();
}

class HouseNormCaptureSubmitted extends HouseNormCaptureEvent {
  const HouseNormCaptureSubmitted();
}

class HouseNormCaptureReflectionCompleted extends HouseNormCaptureEvent {
  const HouseNormCaptureReflectionCompleted();
}
