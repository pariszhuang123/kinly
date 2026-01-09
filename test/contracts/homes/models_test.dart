import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/homes/models.dart';

void main() {
  group('LeaveResult.fromJson', () {
    test('parses HOME_DEACTIVATED code', () {
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

    test('parses LEFT_OK code', () {
      final json = {
        'code': 'LEFT_OK',
        'data': {
          'home_deactivated': false,
          'members_remaining': 2,
          'role_before': 'member',
        },
      };
      final result = LeaveResult.fromJson(json);

      expect(result.outcome, LeaveOutcome.leftOk);
      expect(result.homeDeactivated, false);
      expect(result.membersRemaining, 2);
      expect(result.roleBefore, 'member');
    });

    test('handles camelCase keys', () {
      final json = {
        'code': 'LEFT_OK',
        'data': {
          'homeDeactivated': false,
          'membersRemaining': 3,
          'roleBefore': 'member',
        },
      };
      final result = LeaveResult.fromJson(json);

      expect(result.homeDeactivated, false);
      expect(result.membersRemaining, 3);
      expect(result.roleBefore, 'member');
    });

    test('handles missing data gracefully', () {
      final json = {'code': 'LEFT_OK'};
      final result = LeaveResult.fromJson(json);

      expect(result.outcome, LeaveOutcome.leftOk);
      expect(result.homeDeactivated, false);
      expect(result.membersRemaining, 0);
      expect(result.roleBefore, isNull);
    });

    test('handles lowercase code', () {
      final json = {'code': 'home_deactivated', 'data': {}};
      final result = LeaveResult.fromJson(json);

      expect(result.outcome, LeaveOutcome.homeDeactivated);
    });
  });

  group('CurrentMembership.fromJson', () {
    test('parses complete membership', () {
      final json = {
        'user_id': 'user-123',
        'home_id': 'home-456',
        'role': 'owner',
        'valid_from': '2024-01-15T10:30:00Z',
      };
      final result = CurrentMembership.fromJson(json);

      expect(result.userId, 'user-123');
      expect(result.homeId, 'home-456');
      expect(result.role, 'owner');
      expect(result.validFrom.year, 2024);
      expect(result.validFrom.month, 1);
      expect(result.validFrom.day, 15);
    });

    test('handles null valid_from with fallback', () {
      final json = {
        'user_id': 'user-123',
        'home_id': 'home-456',
        'role': 'member',
        'valid_from': null,
      };
      final result = CurrentMembership.fromJson(json);

      expect(result.validFrom.millisecondsSinceEpoch, 0);
    });
  });

  group('HomeMemberSummary.fromJson', () {
    test('parses complete member summary', () {
      final json = {
        'user_id': 'user-123',
        'username': 'alice',
        'role': 'owner',
        'valid_from': '2024-01-15T10:30:00Z',
        'avatar_url': 'https://example.com/avatar.png',
        'can_transfer_to': true,
      };
      final result = HomeMemberSummary.fromJson(json);

      expect(result.userId, 'user-123');
      expect(result.username, 'alice');
      expect(result.role, 'owner');
      expect(result.isOwner, true);
      expect(result.avatarUrl, 'https://example.com/avatar.png');
      expect(result.canTransferTo, true);
    });

    test('derives isOwner from role', () {
      final json = {
        'user_id': 'user-123',
        'username': 'bob',
        'role': 'member',
        'valid_from': '2024-01-15T10:30:00Z',
      };
      final result = HomeMemberSummary.fromJson(json);

      expect(result.isOwner, false);
    });

    test('handles missing optional fields', () {
      final json = {
        'user_id': 'user-123',
        'valid_from': '2024-01-15T10:30:00Z',
      };
      final result = HomeMemberSummary.fromJson(json);

      expect(result.username, '');
      expect(result.role, 'member');
      expect(result.avatarUrl, isNull);
      expect(result.canTransferTo, false);
    });
  });

  group('HomeCreationResult.fromJson', () {
    test('parses nested home id', () {
      final json = {
        'home': {'id': 'home-123'},
      };
      final result = HomeCreationResult.fromJson(json);

      expect(result.homeId, 'home-123');
    });

    test('handles missing home object', () {
      final json = <String, dynamic>{};
      final result = HomeCreationResult.fromJson(json);

      expect(result.homeId, '');
    });

    test('handles missing id in home', () {
      final json = {'home': <String, dynamic>{}};
      final result = HomeCreationResult.fromJson(json);

      expect(result.homeId, '');
    });
  });

  group('HomeJoinResult.fromJson', () {
    test('parses success result', () {
      final json = {
        'status': 'success',
        'home_id': 'home-123',
        'membership': {
          'user_id': 'user-456',
          'home_id': 'home-123',
          'role': 'member',
          'valid_from': '2024-01-15T10:30:00Z',
        },
      };
      final result = HomeJoinResult.fromJson(json);

      expect(result.outcome, JoinOutcome.success);
      expect(result.homeId, 'home-123');
      expect(result.membership, isNotNull);
      expect(result.membership!.userId, 'user-456');
    });

    test('parses blocked result', () {
      final json = {
        'status': 'blocked',
        'home_id': 'home-123',
      };
      final result = HomeJoinResult.fromJson(json);

      expect(result.outcome, JoinOutcome.blocked);
      expect(result.homeId, 'home-123');
    });

    test('handles homeId key variant', () {
      final json = {
        'status': 'success',
        'homeId': 'home-123',
      };
      final result = HomeJoinResult.fromJson(json);

      expect(result.homeId, 'home-123');
    });

    test('handles home object with id', () {
      final json = {
        'status': 'success',
        'home': {'id': 'home-from-nested'},
      };
      final result = HomeJoinResult.fromJson(json);

      expect(result.homeId, 'home-from-nested');
    });

    test('handles current_membership key variant', () {
      final json = {
        'status': 'success',
        'home_id': 'home-123',
        'current_membership': {
          'user_id': 'user-456',
          'home_id': 'home-123',
          'role': 'member',
          'valid_from': '2024-01-15T10:30:00Z',
        },
      };
      final result = HomeJoinResult.fromJson(json);

      expect(result.membership, isNotNull);
    });

    test('handles missing status defaults to success', () {
      final json = {'home_id': 'home-123'};
      final result = HomeJoinResult.fromJson(json);

      expect(result.outcome, JoinOutcome.success);
    });
  });

  group('HomeInvite.fromJson', () {
    test('parses complete invite', () {
      final json = {
        'id': 'invite-123',
        'home_id': 'home-456',
        'code': 'ABC123',
        'created_by': 'user-789',
        'created_at': '2024-01-15T10:30:00Z',
        'updated_at': '2024-01-16T10:30:00Z',
        'revoked_at': null,
      };
      final result = HomeInvite.fromJson(json);

      expect(result.id, 'invite-123');
      expect(result.homeId, 'home-456');
      expect(result.code, 'ABC123');
      expect(result.createdBy, 'user-789');
      expect(result.createdAt.year, 2024);
      expect(result.updatedAt, isNotNull);
      expect(result.revokedAt, isNull);
    });

    test('parses revoked invite', () {
      final json = {
        'id': 'invite-123',
        'home_id': 'home-456',
        'code': 'ABC123',
        'created_by': 'user-789',
        'created_at': '2024-01-15T10:30:00Z',
        'revoked_at': '2024-01-20T10:30:00Z',
      };
      final result = HomeInvite.fromJson(json);

      expect(result.revokedAt, isNotNull);
      expect(result.revokedAt!.year, 2024);
      expect(result.revokedAt!.month, 1);
      expect(result.revokedAt!.day, 20);
    });

    test('handles missing optional fields', () {
      final json = {
        'created_at': '2024-01-15T10:30:00Z',
      };
      final result = HomeInvite.fromJson(json);

      expect(result.id, '');
      expect(result.homeId, '');
      expect(result.code, '');
      expect(result.createdBy, '');
    });
  });
}
