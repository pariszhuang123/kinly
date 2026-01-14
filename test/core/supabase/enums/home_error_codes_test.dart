import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/supabase/enums/home_error_codes.dart';

void main() {
  group('JoinErrorCode', () {
    test('has 8 values', () {
      expect(JoinErrorCode.values.length, 8);
    });

    test('contains expected error codes', () {
      expect(JoinErrorCode.values, contains(JoinErrorCode.invalidCode));
      expect(JoinErrorCode.values, contains(JoinErrorCode.inactiveInvite));
      expect(JoinErrorCode.values, contains(JoinErrorCode.profileDeactivated));
      expect(JoinErrorCode.values, contains(JoinErrorCode.alreadyInOtherHome));
      expect(
        JoinErrorCode.values,
        contains(JoinErrorCode.paywallLimitActiveMembers),
      );
      expect(JoinErrorCode.values, contains(JoinErrorCode.unauthorized));
      expect(JoinErrorCode.values, contains(JoinErrorCode.forbidden));
      expect(JoinErrorCode.values, contains(JoinErrorCode.unknown));
    });
  });

  group('CreateHomeErrorCode', () {
    test('has 5 values', () {
      expect(CreateHomeErrorCode.values.length, 5);
    });

    test('contains expected error codes', () {
      expect(
        CreateHomeErrorCode.values,
        contains(CreateHomeErrorCode.profileDeactivated),
      );
      expect(
        CreateHomeErrorCode.values,
        contains(CreateHomeErrorCode.alreadyInOtherHome),
      );
    });
  });

  group('TransferErrorCode', () {
    test('has 6 values', () {
      expect(TransferErrorCode.values.length, 6);
    });

    test('contains expected error codes', () {
      expect(
        TransferErrorCode.values,
        contains(TransferErrorCode.invalidNewOwner),
      );
      expect(
        TransferErrorCode.values,
        contains(TransferErrorCode.newOwnerNotMember),
      );
      expect(
        TransferErrorCode.values,
        contains(TransferErrorCode.stateChangedRetry),
      );
    });
  });

  group('LeaveErrorCode', () {
    test('has 6 values', () {
      expect(LeaveErrorCode.values.length, 6);
    });

    test('contains expected error codes', () {
      expect(LeaveErrorCode.values, contains(LeaveErrorCode.notMember));
      expect(
        LeaveErrorCode.values,
        contains(LeaveErrorCode.ownerMustTransferFirst),
      );
      expect(LeaveErrorCode.values, contains(LeaveErrorCode.stateChangedRetry));
    });
  });

  group('KickMemberErrorCode', () {
    test('has 7 values', () {
      expect(KickMemberErrorCode.values.length, 7);
    });

    test('contains expected error codes', () {
      expect(
        KickMemberErrorCode.values,
        contains(KickMemberErrorCode.targetNotMember),
      );
      expect(
        KickMemberErrorCode.values,
        contains(KickMemberErrorCode.cannotKickOwner),
      );
      expect(
        KickMemberErrorCode.values,
        contains(KickMemberErrorCode.homeInactive),
      );
    });
  });

  group('RotateErrorCode', () {
    test('has 3 values', () {
      expect(RotateErrorCode.values.length, 3);
    });
  });

  group('RevokeErrorCode', () {
    test('has 3 values', () {
      expect(RevokeErrorCode.values.length, 3);
    });
  });

  group('InviteGetOrCreateErrorCode', () {
    test('has 4 values', () {
      expect(InviteGetOrCreateErrorCode.values.length, 4);
    });

    test('contains inactiveHome', () {
      expect(
        InviteGetOrCreateErrorCode.values,
        contains(InviteGetOrCreateErrorCode.inactiveHome),
      );
    });
  });
}
