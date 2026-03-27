part of 'fit_check_attach_cubit.dart';

class FitCheckAttachState extends Equatable {
  const FitCheckAttachState({
    required this.status,
    this.result,
    this.errorMessage,
  });

  final FitCheckAttachStatus status;
  final FitCheckAttachResult? result;
  final String? errorMessage;

  factory FitCheckAttachState.ready() {
    return const FitCheckAttachState(status: FitCheckAttachStatus.ready);
  }

  factory FitCheckAttachState.loading() {
    return const FitCheckAttachState(status: FitCheckAttachStatus.loading);
  }

  factory FitCheckAttachState.success(FitCheckAttachResult result) {
    return FitCheckAttachState(
      status: FitCheckAttachStatus.success,
      result: result,
    );
  }

  factory FitCheckAttachState.failure(String message) {
    return FitCheckAttachState(
      status: FitCheckAttachStatus.failure,
      errorMessage: message,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
