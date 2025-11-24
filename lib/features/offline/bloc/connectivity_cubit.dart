import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/connectivity_monitor.dart';

class ConnectivityState extends Equatable {
  const ConnectivityState({
    this.status = ConnectivityStatus.unknown,
    this.lastCheckedAt,
  });

  final ConnectivityStatus status;
  final DateTime? lastCheckedAt;

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    DateTime? lastCheckedAt,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
    );
  }

  @override
  List<Object?> get props => [status, lastCheckedAt];
}

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit({required ConnectivityMonitor monitor})
    : _monitor = monitor,
      super(const ConnectivityState()) {
    _subscription = _monitor.onStatusChange.listen(_handleStatus);
  }

  final ConnectivityMonitor _monitor;
  StreamSubscription<ConnectivityStatus>? _subscription;

  Future<void> retry() async {
    await _monitor.checkNow(force: true);
  }

  void _handleStatus(ConnectivityStatus status) {
    emit(state.copyWith(status: status, lastCheckedAt: DateTime.now()));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
