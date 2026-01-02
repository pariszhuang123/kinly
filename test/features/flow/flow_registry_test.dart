import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/features/flow/flow.dart';

void main() {
  test('FlowRegistry bootstrap registers sections in order', () {
    FlowRegistry.clearForTest();
    FlowRegistry.bootstrap();

    final ids = FlowRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['list']));
  });
}
