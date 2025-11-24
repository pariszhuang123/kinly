import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/network/connectivity_monitor.dart';
import 'package:kinly/features/offline/bloc/connectivity_cubit.dart';

class _MockConnectivityMonitor extends Mock implements ConnectivityMonitor {}

void main() {
  late _MockConnectivityMonitor monitor;
  late StreamController<ConnectivityStatus> statusController;

  setUp(() {
    monitor = _MockConnectivityMonitor();
    statusController = StreamController<ConnectivityStatus>.broadcast();
    when(
      () => monitor.onStatusChange,
    ).thenAnswer((_) => statusController.stream);
    when(
      () => monitor.checkNow(force: any(named: 'force')),
    ).thenAnswer((_) async => ConnectivityStatus.online);
  });

  tearDown(() async {
    await statusController.close();
  });

  blocTest<ConnectivityCubit, ConnectivityState>(
    'emits state updates when monitor notifies status changes',
    build: () => ConnectivityCubit(monitor: monitor),
    act: (cubit) async {
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
    },
    expect:
        () => [
          isA<ConnectivityState>().having(
            (state) => state.status,
            'status',
            ConnectivityStatus.offline,
          ),
        ],
  );

  blocTest<ConnectivityCubit, ConnectivityState>(
    'invokes monitor retry when requested',
    build: () => ConnectivityCubit(monitor: monitor),
    act: (cubit) => cubit.retry(),
    verify: (_) {
      verify(() => monitor.checkNow(force: true)).called(1);
    },
  );
}
