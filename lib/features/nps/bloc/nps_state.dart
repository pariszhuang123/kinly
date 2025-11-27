part of 'nps_cubit.dart';

class NpsState extends Equatable {
  final bool isSubmitting;
  final int submitSuccessTick;
  final String? submitError;
  final int? lastSubmittedScore;

  const NpsState({
    this.isSubmitting = false,
    this.submitSuccessTick = 0,
    this.submitError,
    this.lastSubmittedScore,
  });

  NpsState copyWith({
    bool? isSubmitting,
    int? submitSuccessTick,
    String? submitError,
    int? lastSubmittedScore,
  }) {
    return NpsState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccessTick: submitSuccessTick ?? this.submitSuccessTick,
      submitError: submitError,
      lastSubmittedScore: lastSubmittedScore ?? this.lastSubmittedScore,
    );
  }

  @override
  List<Object?> get props => [
    isSubmitting,
    submitSuccessTick,
    submitError,
    lastSubmittedScore,
  ];
}
