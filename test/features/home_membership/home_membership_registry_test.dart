import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/features/home_membership/home_membership.dart';

void main() {
  test('StartHomeRegistry bootstrap registers content section', () {
    StartHomeRegistry.clearForTest();
    StartHomeRegistry.bootstrap();

    final ids = StartHomeRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['content']));
  });

  test('JoinHomeRegistry bootstrap registers form section', () {
    JoinHomeRegistry.clearForTest();
    JoinHomeRegistry.bootstrap();

    final ids = JoinHomeRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['form']));
  });

  test('JoinHomeBlockedRegistry bootstrap registers content section', () {
    JoinHomeBlockedRegistry.clearForTest();
    JoinHomeBlockedRegistry.bootstrap();

    final ids = JoinHomeBlockedRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['content']));
  });
}
