part of 'start_home_bloc.dart';

enum StartHomeStatus { initial, loading, success, failure }

class StartHomeState {
  const StartHomeState({
    this.status = StartHomeStatus.initial,
    this.errorMessage,
    this.isProfileDeactivated = false,
  });

  final StartHomeStatus status;
  final String? errorMessage;
  final bool isProfileDeactivated;

  StartHomeState copyWith({
    StartHomeStatus? status,
    String? errorMessage,
    bool? isProfileDeactivated,
  }) {
    return StartHomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isProfileDeactivated:
          isProfileDeactivated ?? this.isProfileDeactivated,
    );
  }
}
