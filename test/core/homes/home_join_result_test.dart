import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/homes/models.dart';

void main() {
  group('HomeJoinResult.fromJson', () {
    test('maps blocked payload', () {
      final result = HomeJoinResult.fromJson({
        'status': 'blocked',
        'code': 'member_cap',
        'home_id': 'hid',
      });

      expect(result.homeId, 'hid');
      expect(result.outcome, JoinOutcome.blocked);
      expect(result.code, 'member_cap');
      expect(result.membership, isNull);
    });

    test('maps legacy success payload', () {
      final result = HomeJoinResult.fromJson({'home_id': 'hid'});

      expect(result.homeId, 'hid');
      expect(result.outcome, JoinOutcome.success);
      expect(result.membership, isNull);
    });
  });
}
