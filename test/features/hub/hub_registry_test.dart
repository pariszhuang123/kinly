import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/foundation/surfaces/hub/hub_registry.dart';

void main() {
  test('HubRegistry bootstrap registers sections in order', () {
    HubRegistry.clearForTest();
    HubRegistry.bootstrap();

    final ids = HubRegistry.bodySections.map((e) => e.id).toList();
    expect(
      ids,
      equals(['members', 'qr', 'preferences', 'house_norms', 'gratitude']),
    );
  });
}
