// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/auth/fake_auth_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/homes/fake_home_repository.dart';
import 'package:kinly/data/repositories/auth_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await sl.reset();
    sl.registerLazySingleton<AuthRepository>(() => FakeAuthRepository());
    sl.registerLazySingleton<HomeRepository>(() => FakeHomeRepository());
  });

  testWidgets('App boots smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
