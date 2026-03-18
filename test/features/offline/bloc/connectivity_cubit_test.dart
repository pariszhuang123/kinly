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
  late DateTime currentTime;

  setUp(() {
    monitor = _MockConnectivityMonitor();
    statusController = StreamController<ConnectivityStatus>.broadcast();
    currentTime = DateTime(2026, 3, 17, 9);
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
    'does not go offline after the first failed connectivity signal',
    build:
        () => ConnectivityCubit(
          monitor: monitor,
          now: () => currentTime,
        ),
    act: (cubit) async {
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
    },
    expect: () => [
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.unknown)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            currentTime,
          ),
    ],
  );

  blocTest<ConnectivityCubit, ConnectivityState>(
    'emits offline only after repeated failures beyond the grace period',
    build:
        () => ConnectivityCubit(
          monitor: monitor,
          now: () => currentTime,
          offlineFailureThreshold: 2,
          offlineGracePeriod: const Duration(seconds: 8),
        ),
    act: (cubit) async {
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
      currentTime = currentTime.add(const Duration(seconds: 9));
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
    },
    expect: () => [
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.unknown)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9),
          ),
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.offline)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9, 0, 9),
          ),
    ],
  );

  blocTest<ConnectivityCubit, ConnectivityState>(
    'emits offline when repeated failures hit the exact grace-period boundary',
    build:
        () => ConnectivityCubit(
          monitor: monitor,
          now: () => currentTime,
          offlineFailureThreshold: 2,
          offlineGracePeriod: const Duration(seconds: 8),
        ),
    act: (cubit) async {
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
      currentTime = currentTime.add(const Duration(seconds: 8));
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
    },
    expect: () => [
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.unknown)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9),
          ),
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.offline)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9, 0, 8),
          ),
    ],
  );

  blocTest<ConnectivityCubit, ConnectivityState>(
    'does not emit offline when repeated failures stay within the grace period',
    build:
        () => ConnectivityCubit(
          monitor: monitor,
          now: () => currentTime,
          offlineFailureThreshold: 2,
          offlineGracePeriod: const Duration(seconds: 8),
        ),
    act: (cubit) async {
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
      currentTime = currentTime.add(const Duration(seconds: 3));
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
      currentTime = currentTime.add(const Duration(seconds: 3));
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
    },
    expect: () => [
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.unknown)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9),
          ),
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.unknown)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9, 0, 3),
          ),
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.unknown)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9, 0, 6),
          ),
    ],
  );

  blocTest<ConnectivityCubit, ConnectivityState>(
    'returns online immediately and resets any pending offline streak',
    build:
        () => ConnectivityCubit(
          monitor: monitor,
          now: () => currentTime,
          offlineFailureThreshold: 2,
          offlineGracePeriod: const Duration(seconds: 8),
        ),
    act: (cubit) async {
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
      currentTime = currentTime.add(const Duration(seconds: 3));
      statusController.add(ConnectivityStatus.online);
      await Future<void>.value();
      currentTime = currentTime.add(const Duration(seconds: 9));
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
    },
    expect: () => [
      isA<ConnectivityState>().having(
        (state) => state.status,
        'status',
        ConnectivityStatus.unknown,
      ),
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.online)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9, 0, 3),
          ),
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.online)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9, 0, 12),
          ),
    ],
  );

  blocTest<ConnectivityCubit, ConnectivityState>(
    'returns online immediately after the app is already offline',
    build:
        () => ConnectivityCubit(
          monitor: monitor,
          now: () => currentTime,
          offlineFailureThreshold: 2,
          offlineGracePeriod: const Duration(seconds: 8),
        ),
    act: (cubit) async {
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
      currentTime = currentTime.add(const Duration(seconds: 9));
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
      currentTime = currentTime.add(const Duration(seconds: 1));
      statusController.add(ConnectivityStatus.online);
      await Future<void>.value();
    },
    expect: () => [
      isA<ConnectivityState>().having(
        (state) => state.status,
        'status',
        ConnectivityStatus.unknown,
      ),
      isA<ConnectivityState>().having(
        (state) => state.status,
        'status',
        ConnectivityStatus.offline,
      ),
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.online)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9, 0, 10),
          ),
    ],
  );

  blocTest<ConnectivityCubit, ConnectivityState>(
    'retry success clears a pending offline streak before the grace period ends',
    build:
        () => ConnectivityCubit(
          monitor: monitor,
          now: () => currentTime,
          offlineFailureThreshold: 2,
          offlineGracePeriod: const Duration(seconds: 8),
        ),
    act: (cubit) async {
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
      currentTime = currentTime.add(const Duration(seconds: 2));
      await cubit.retry();
      statusController.add(ConnectivityStatus.online);
      await Future<void>.value();
      currentTime = currentTime.add(const Duration(seconds: 9));
      statusController.add(ConnectivityStatus.offline);
      await Future<void>.value();
    },
    expect: () => [
      isA<ConnectivityState>().having(
        (state) => state.status,
        'status',
        ConnectivityStatus.unknown,
      ),
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.online)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9, 0, 2),
          ),
      isA<ConnectivityState>()
          .having((state) => state.status, 'status', ConnectivityStatus.online)
          .having(
            (state) => state.lastCheckedAt,
            'lastCheckedAt',
            DateTime(2026, 3, 17, 9, 0, 11),
          ),
    ],
    verify: (_) {
      verify(() => monitor.checkNow(force: true)).called(1);
    },
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
