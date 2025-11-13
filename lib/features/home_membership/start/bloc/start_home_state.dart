part of 'start_home_bloc.dart';

enum StartHomeStatus { initial, loading, success, failure }

class StartHomeState {
  const StartHomeState({
    this.status = StartHomeStatus.initial,
    this.errorMessage,
  });

  final StartHomeStatus status;
  final String? errorMessage;

  StartHomeState copyWith({StartHomeStatus? status, String? errorMessage}) {
    return StartHomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
