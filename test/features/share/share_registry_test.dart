import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/features/share/share.dart';

void main() {
  test('ShareCreatedListRegistry bootstrap registers list section', () {
    ShareCreatedListRegistry.clearForTest();
    ShareCreatedListRegistry.bootstrap();

    final ids = ShareCreatedListRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['list']));
  });

  test('ShareCreateRegistry bootstrap registers body section', () {
    ShareCreateRegistry.clearForTest();
    ShareCreateRegistry.bootstrap();

    final ids = ShareCreateRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['body']));
  });

  test('ShareOwedDetailRegistry bootstrap registers content section', () {
    ShareOwedDetailRegistry.clearForTest();
    ShareOwedDetailRegistry.bootstrap();

    final ids = ShareOwedDetailRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['content']));
  });

  test('SharePaidToMeDetailRegistry bootstrap registers content section', () {
    SharePaidToMeDetailRegistry.clearForTest();
    SharePaidToMeDetailRegistry.bootstrap();

    final ids =
        SharePaidToMeDetailRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['content']));
  });
}
