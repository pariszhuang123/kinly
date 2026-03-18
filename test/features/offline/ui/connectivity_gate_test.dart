import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/network/connectivity_monitor.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/offline/bloc/connectivity_cubit.dart';
import 'package:kinly/features/offline/ui/connectivity_gate.dart';
import 'package:kinly/features/offline/ui/offline_splash.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  late _FakeConnectivityMonitor monitor;
  late DateTime currentTime;

  setUp(() {
    monitor = _FakeConnectivityMonitor();
    currentTime = DateTime(2026, 3, 17, 9);
  });

  tearDown(() async {
    await monitor.dispose();
  });

  testWidgets(
    'ConnectivityGate keeps the child visible during the offline grace period',
    (tester) async {
      final cubit = ConnectivityCubit(
        monitor: monitor,
        now: () => currentTime,
        offlineFailureThreshold: 2,
        offlineGracePeriod: const Duration(seconds: 8),
      );
      addTearDown(cubit.close);

      await tester.pumpWidget(_buildHarness(cubit));

      expect(find.text('Online content'), findsOneWidget);
      expect(find.byType(OfflineSplash), findsNothing);

      monitor.emit(ConnectivityStatus.offline);
      await tester.pumpAndSettle();

      expect(find.text('Online content'), findsOneWidget);
      expect(find.byType(OfflineSplash), findsNothing);
    },
  );

  testWidgets(
    'ConnectivityGate shows OfflineSplash after repeated failures beyond the grace period',
    (tester) async {
      final cubit = ConnectivityCubit(
        monitor: monitor,
        now: () => currentTime,
        offlineFailureThreshold: 2,
        offlineGracePeriod: const Duration(seconds: 8),
      );
      addTearDown(cubit.close);

      await tester.pumpWidget(_buildHarness(cubit));

      monitor.emit(ConnectivityStatus.offline);
      await tester.pumpAndSettle();

      currentTime = currentTime.add(const Duration(seconds: 9));
      monitor.emit(ConnectivityStatus.offline);
      await tester.pumpAndSettle();

      expect(find.text('Online content'), findsNothing);
      expect(find.byType(OfflineSplash), findsOneWidget);
    },
  );

  testWidgets(
    'ConnectivityGate returns to the child immediately when connectivity recovers',
    (tester) async {
      final cubit = ConnectivityCubit(
        monitor: monitor,
        now: () => currentTime,
        offlineFailureThreshold: 2,
        offlineGracePeriod: const Duration(seconds: 8),
      );
      addTearDown(cubit.close);

      await tester.pumpWidget(_buildHarness(cubit));

      monitor.emit(ConnectivityStatus.offline);
      await tester.pumpAndSettle();
      currentTime = currentTime.add(const Duration(seconds: 9));
      monitor.emit(ConnectivityStatus.offline);
      await tester.pumpAndSettle();

      expect(find.byType(OfflineSplash), findsOneWidget);

      currentTime = currentTime.add(const Duration(seconds: 1));
      monitor.emit(ConnectivityStatus.online);
      await tester.pumpAndSettle();

      expect(find.byType(OfflineSplash), findsNothing);
      expect(find.text('Online content'), findsOneWidget);
    },
  );
}

Widget _buildHarness(ConnectivityCubit cubit) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: BlocProvider<ConnectivityCubit>.value(
      value: cubit,
      child: const ConnectivityGate(
        child: Scaffold(body: Text('Online content')),
      ),
    ),
  );
}

class _FakeConnectivityMonitor implements ConnectivityMonitor {
  final _controller = StreamController<ConnectivityStatus>.broadcast(sync: true);

  @override
  Stream<ConnectivityStatus> get onStatusChange => _controller.stream;

  void emit(ConnectivityStatus status) {
    _controller.add(status);
  }

  @override
  void initialize() {}

  @override
  Future<ConnectivityStatus> checkNow({bool force = false}) async {
    if (force) {
      emit(ConnectivityStatus.online);
    }
    return ConnectivityStatus.online;
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}
