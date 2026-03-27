part of 'start_home_bloc.dart';

enum StartHomeStatus { initial, loading, success, failure }

class StartHomeState {
  const StartHomeState({
    this.status = StartHomeStatus.initial,
    this.errorMessage,
    this.isProfileDeactivated = false,
    this.createdHomeId,
  });

  final StartHomeStatus status;
  final String? errorMessage;
  final bool isProfileDeactivated;
  final String? createdHomeId;

  StartHomeState copyWith({
    StartHomeStatus? status,
    Object? errorMessage = _unset,
    bool? isProfileDeactivated,
    Object? createdHomeId = _unset,
  }) {
    return StartHomeState(
      status: status ?? this.status,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      isProfileDeactivated: isProfileDeactivated ?? this.isProfileDeactivated,
      createdHomeId:
          createdHomeId == _unset ? this.createdHomeId : createdHomeId as String?,
    );
  }

  static const _unset = Object();
}
