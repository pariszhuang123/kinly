import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/foundation/surfaces/explore/explore_registry.dart';

void main() {
  test('ExploreRegistry bootstrap registers sections in order', () {
    ExploreRegistry.clearForTest();
    ExploreRegistry.bootstrap();

    final ids = ExploreRegistry.bodySections.map((e) => e.id).toList();
    expect(ids, equals(['intro', 'flow_tile', 'share_tile', 'shopping_tile']));
  });
}
