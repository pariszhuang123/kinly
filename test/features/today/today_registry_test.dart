import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/foundation/surfaces/today/today_registry.dart';

void main() {
  test('TodayRegistry bootstrap registers sections in order', () {
    TodayRegistry.clearForTest();
    TodayRegistry.bootstrap();

    final ids = TodayRegistry.bodySections.map((e) => e.id).toList();
    expect(
      ids,
      equals([
        'member_cap',
        'house_norms',
        'invite',
        'house_pulse',
        'house_directory_reminders',
        'flow',
        'bank_account',
        'share',
        'shopping',
        'preferences',
        'gratitude',
      ]),
    );
  });
}
