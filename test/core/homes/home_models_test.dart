import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/homes/models.dart';

void main() {
  test('LeaveResult maps home deactivated outcome', () {
    final json = {
      'code': 'HOME_DEACTIVATED',
      'data': {
        'home_deactivated': true,
        'members_remaining': 0,
        'role_before': 'owner',
      },
    };
    final result = LeaveResult.fromJson(json);
    expect(result.outcome, LeaveOutcome.homeDeactivated);
    expect(result.homeDeactivated, true);
    expect(result.membersRemaining, 0);
    expect(result.roleBefore, 'owner');
  });

  test('LeaveResult defaults to leftOk outcome', () {
    final result = LeaveResult.fromJson({'code': 'LEFT', 'data': {}});
    expect(result.outcome, LeaveOutcome.leftOk);
  });

  test('HomeCreationResult parses id from nested home object', () {
    final result = HomeCreationResult.fromJson({
      'home': {'id': 'home-123'}
    });
    expect(result.homeId, 'home-123');
  });
}
