import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/connectivity_monitor.dart';

typedef DateTimeNow = DateTime Function();

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
  ConnectivityCubit({
    required ConnectivityMonitor monitor,
    int offlineFailureThreshold = 2,
    Duration offlineGracePeriod = const Duration(seconds: 8),
    DateTimeNow now = DateTime.now,
  }) : _monitor = monitor,
       _offlineFailureThreshold = offlineFailureThreshold,
       _offlineGracePeriod = offlineGracePeriod,
       _now = now,
      super(const ConnectivityState()) {
    _subscription = _monitor.onStatusChange.listen(_handleStatus);
  }

  final ConnectivityMonitor _monitor;
  final int _offlineFailureThreshold;
  final Duration _offlineGracePeriod;
  final DateTimeNow _now;
  StreamSubscription<ConnectivityStatus>? _subscription;
  int _consecutiveOfflineSignals = 0;
  DateTime? _firstOfflineSignalAt;

  Future<void> retry() async {
    await _monitor.checkNow(force: true);
  }

  void _handleStatus(ConnectivityStatus status) {
    final checkedAt = _now();
    if (status == ConnectivityStatus.online) {
      _consecutiveOfflineSignals = 0;
      _firstOfflineSignalAt = null;
      emit(state.copyWith(status: status, lastCheckedAt: checkedAt));
      return;
    }
    if (status == ConnectivityStatus.unknown) {
      emit(state.copyWith(status: status, lastCheckedAt: checkedAt));
      return;
    }

    _consecutiveOfflineSignals += 1;
    _firstOfflineSignalAt ??= checkedAt;
    final offlineWindow = checkedAt.difference(_firstOfflineSignalAt!);
    final shouldEmitOffline =
        _consecutiveOfflineSignals >= _offlineFailureThreshold &&
        offlineWindow >= _offlineGracePeriod;

    if (shouldEmitOffline) {
      emit(
        state.copyWith(
          status: ConnectivityStatus.offline,
          lastCheckedAt: checkedAt,
        ),
      );
      return;
    }

    emit(state.copyWith(lastCheckedAt: checkedAt));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
