part of 'fit_check_claim_cubit.dart';

class FitCheckClaimState extends Equatable {
  const FitCheckClaimState({
    required this.status,
    this.result,
    this.errorMessage,
  });

  final FitCheckClaimStatus status;
  final FitCheckClaimResult? result;
  final String? errorMessage;

  factory FitCheckClaimState.loading() {
    return const FitCheckClaimState(status: FitCheckClaimStatus.loading);
  }

  factory FitCheckClaimState.ready(FitCheckClaimResult result) {
    return FitCheckClaimState(
      status: FitCheckClaimStatus.ready,
      result: result,
    );
  }

  factory FitCheckClaimState.failure(String message) {
    return FitCheckClaimState(
      status: FitCheckClaimStatus.failure,
      errorMessage: message,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
