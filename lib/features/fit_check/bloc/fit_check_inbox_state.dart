part of 'fit_check_inbox_cubit.dart';

class FitCheckInboxState extends Equatable {
  const FitCheckInboxState({
    required this.status,
    this.review,
    this.errorMessage,
  });

  final FitCheckInboxStatus status;
  final FitCheckOwnerReview? review;
  final String? errorMessage;

  factory FitCheckInboxState.loading() {
    return const FitCheckInboxState(status: FitCheckInboxStatus.loading);
  }

  factory FitCheckInboxState.ready(FitCheckOwnerReview review) {
    return FitCheckInboxState(
      status: FitCheckInboxStatus.ready,
      review: review,
    );
  }

  factory FitCheckInboxState.failure(String message) {
    return FitCheckInboxState(
      status: FitCheckInboxStatus.failure,
      errorMessage: message,
    );
  }

  @override
  List<Object?> get props => [status, review, errorMessage];
}
