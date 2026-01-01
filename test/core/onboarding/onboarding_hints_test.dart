import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/onboarding/onboarding.dart';

void main() {
  test('OnboardingHints parses member cap join requests', () {
    final hints = OnboardingHints.fromJson({
      'activeChoreCount': 2,
      'shouldPromptNotifications': false,
      'shouldPromptFlatmateInviteShare': false,
      'shouldPromptInviteShare': false,
      'memberCapJoinRequests': {
        'homeId': 'home-1',
        'pendingCount': 2,
        'joinerNames': ['Alex', 'Sam'],
        'requestIds': ['r1', 'r2'],
      },
      'memberCapJoinResolution': {
        'requestId': 'r2',
        'joinerName': 'Sam',
        'resolvedReason': 'joined',
      },
    });

    expect(hints.memberCapJoinRequests, isNotNull);
    expect(hints.memberCapJoinRequests!.homeId, 'home-1');
    expect(hints.memberCapJoinRequests!.pendingCount, 2);
    expect(hints.memberCapJoinRequests!.joinerNames, ['Alex', 'Sam']);
    expect(hints.memberCapJoinRequests!.requestIds, ['r1', 'r2']);
    expect(hints.memberCapJoinResolution, isNotNull);
    expect(hints.memberCapJoinResolution!.requestId, 'r2');
    expect(hints.memberCapJoinResolution!.joinerName, 'Sam');
    expect(hints.memberCapJoinResolution!.resolvedReason, 'joined');
  });
}
