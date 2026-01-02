import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/features/paywall/paywall.dart';

void main() {
  test('PaywallRegistry bootstrap registers content section', () {
    PaywallRegistry.clearForTest();
    PaywallRegistry.bootstrap();

    final ids = PaywallRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['content']));
  });
}
