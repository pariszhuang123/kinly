// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:kinly/core/auth/fake_auth_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/homes/fake_home_repository.dart';
import 'package:kinly/data/repositories/app_version_repository.dart';
import 'package:kinly/core/network/connectivity_monitor.dart';
import 'package:kinly/data/repositories/auth_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await sl.reset();
    PackageInfo.setMockInitialValues(
      appName: 'Kinly',
      packageName: 'com.kinly.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: 'test',
    );
    sl.registerLazySingleton<AuthRepository>(() => FakeAuthRepository());
    sl.registerLazySingleton<HomeRepository>(() => FakeHomeRepository());
    sl.registerLazySingleton<ConnectivityMonitor>(
      () => _FakeConnectivityMonitor()..initialize(),
    );
    sl.registerLazySingleton<AppVersionRepository>(
      () => _FakeAppVersionRepository(),
    );
  });

  testWidgets('App boots smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

class _FakeConnectivityMonitor implements ConnectivityMonitor {
  final _controller = StreamController<ConnectivityStatus>.broadcast(
    sync: true,
  );

  @override
  Stream<ConnectivityStatus> get onStatusChange => _controller.stream;

  @override
  void initialize() {
    _controller.add(ConnectivityStatus.online);
  }

  @override
  Future<ConnectivityStatus> checkNow({bool force = false}) async {
    if (force) {
      _controller.add(ConnectivityStatus.online);
    }
    return ConnectivityStatus.online;
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}

class _FakeAppVersionRepository implements AppVersionRepository {
  @override
  Future<AppVersionStatusResult> checkVersion({
    required String clientVersion,
  }) async {
    return AppVersionStatusResult(
      clientVersion: clientVersion,
      currentVersion: clientVersion,
      minSupportedVersion: clientVersion,
      hardBlocked: false,
      updateRecommended: false,
    );
  }
}
