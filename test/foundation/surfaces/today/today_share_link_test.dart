import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/foundation/surfaces/today/today_surface.dart';

void main() {
  test(
    'invite link falls back to go.makinglifeeasie.com when inviteHost is empty',
    () {
      final invite = HomeInvite.fromJson({
        'id': 'invite-id',
        'home_id': 'home-id',
        'code': 'ABC123',
        'created_by': 'user-id',
        'created_at': '2024-01-01T00:00:00Z',
      });

      final link = buildInviteLinkForTest(invite);

      expect(link, 'https://go.makinglifeeasie.com/kinly/join/ABC123');
    },
  );
}
