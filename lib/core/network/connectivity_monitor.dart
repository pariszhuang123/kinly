import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'enums/connectivity_status.dart';

export 'enums/connectivity_status.dart';

class ConnectivityMonitor {
  ConnectivityMonitor({InternetConnection? connection})
    : _connection = connection ?? InternetConnection();

  final InternetConnection _connection;
  final _statusController = StreamController<ConnectivityStatus>.broadcast(
    sync: true,
  );

  ConnectivityStatus _lastStatus = ConnectivityStatus.unknown;
  StreamSubscription<InternetStatus>? _subscription;
  bool _initialized = false;

  Stream<ConnectivityStatus> get onStatusChange =>
      _statusController.stream.distinct();

  void initialize() {
    if (_initialized) return;
    _initialized = true;
    _subscription = _connection.onStatusChange.listen((internetStatus) {
      _emit(_mapStatus(internetStatus));
    });
    checkNow(force: true);
  }

  Future<ConnectivityStatus> checkNow({bool force = false}) async {
    final hasInternet = await _connection.hasInternetAccess;
    return _emit(
      hasInternet ? ConnectivityStatus.online : ConnectivityStatus.offline,
      forceEmit: force,
    );
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _statusController.close();
  }

  ConnectivityStatus _emit(
    ConnectivityStatus status, {
    bool forceEmit = false,
  }) {
    if (forceEmit || status != _lastStatus) {
      _lastStatus = status;
      if (!_statusController.isClosed) {
        _statusController.add(status);
      }
    }
    return status;
  }

  ConnectivityStatus _mapStatus(InternetStatus status) {
    return status == InternetStatus.connected
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline;
  }
}
