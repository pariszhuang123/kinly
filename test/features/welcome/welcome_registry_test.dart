import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/features/welcome/welcome.dart';

void main() {
  test('WelcomeRegistry bootstrap registers content section', () {
    WelcomeRegistry.clearForTest();
    WelcomeRegistry.bootstrap();

    final ids = WelcomeRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['content']));
  });
}
