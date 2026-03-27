part of 'fit_check_briefing_cubit.dart';

class FitCheckBriefingState extends Equatable {
  const FitCheckBriefingState({
    required this.status,
    this.briefing,
    this.errorMessage,
  });

  final FitCheckBriefingStatus status;
  final FitCheckOwnerBriefing? briefing;
  final String? errorMessage;

  factory FitCheckBriefingState.loading() {
    return const FitCheckBriefingState(status: FitCheckBriefingStatus.loading);
  }

  factory FitCheckBriefingState.ready(FitCheckOwnerBriefing briefing) {
    return FitCheckBriefingState(
      status: FitCheckBriefingStatus.ready,
      briefing: briefing,
    );
  }

  factory FitCheckBriefingState.failure(String message) {
    return FitCheckBriefingState(
      status: FitCheckBriefingStatus.failure,
      errorMessage: message,
    );
  }

  @override
  List<Object?> get props => [status, briefing, errorMessage];
}
