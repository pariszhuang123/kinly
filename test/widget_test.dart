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
import 'package:kinly/features/home/testing/fake_home_repository.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/time/iana_timezone_resolver.dart';
import 'package:kinly/contracts/app_version/ports/app_version_repository.dart';
import 'package:kinly/core/network/connectivity_monitor.dart';
import 'package:kinly/contracts/auth/ports/auth_repository.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/contracts/profile/models.dart';
import 'package:kinly/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await sl.reset();
    PackageInfo.setMockInitialValues(
      appName: 'Kinly',
      packageName: 'com.makinglifeeasie.kinly.dev',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: 'test',
    );
    sl.registerLazySingleton<AuthRepository>(() => FakeAuthRepository());
    sl.registerLazySingleton<HomeRepository>(() => FakeHomeRepository());
    sl.registerLazySingleton<ProfileRepository>(() => _FakeProfileRepository());
    sl.registerLazySingleton<ConnectivityMonitor>(
      () => _FakeConnectivityMonitor()..initialize(),
    );
    sl.registerLazySingleton<AppVersionRepository>(
      () => _FakeAppVersionRepository(),
    );
    sl.registerLazySingleton<IanaTimezoneResolver>(
      () => IanaTimezoneResolver(
        logger: const DebugLogger(),
        loader: () async => 'UTC',
      ),
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

class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile?> getCurrentProfile() async => null;

  @override
  Future<List<ProfileAvatar>> listAvailableAvatars(String homeId) async =>
      const [];

  @override
  Future<UserProfile> updateIdentity({
    required String username,
    required String avatarId,
  }) {
    throw UnimplementedError();
  }
}
