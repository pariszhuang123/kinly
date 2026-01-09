import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/core/supabase/supabase_error_mapper.dart';

/// Creates a PostgrestException with JSON-encoded message matching RPC error format.
PostgrestException _postgrestError(String code, String message, {Map<String, dynamic>? details}) {
  final json = jsonEncode({
    'code': code,
    'message': message,
    if (details != null) 'details': details,
  });
  return PostgrestException(message: json, code: 'PGRST');
}

/// Creates a PostgrestException with plain text message.
PostgrestException _postgrestPlainError(String message) {
  return PostgrestException(message: message, code: 'PGRST');
}

void main() {
  group('SupabaseErrorMapper.mapJoin', () {
    test('maps INVALID_CODE to invalidCode', () {
      final error = _postgrestError('INVALID_CODE', 'Invalid invite code');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result, isA<HomeJoinException>());
      expect(result.code, JoinErrorCode.invalidCode);
      expect(result.message, 'Invalid invite code');
    });

    test('maps INACTIVE_INVITE to inactiveInvite', () {
      final error = _postgrestError('INACTIVE_INVITE', 'Invite is no longer active');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.inactiveInvite);
    });

    test('maps PROFILE_DEACTIVATED to profileDeactivated', () {
      final error = _postgrestError('PROFILE_DEACTIVATED', 'Your profile is deactivated');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.profileDeactivated);
    });

    test('maps PAYWALL_LIMIT_ACTIVE_MEMBERS to paywallLimitActiveMembers', () {
      final error = _postgrestError('PAYWALL_LIMIT_ACTIVE_MEMBERS', 'Member limit reached');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.paywallLimitActiveMembers);
    });

    test('maps ALREADY_IN_OTHER_HOME to alreadyInOtherHome', () {
      final error = _postgrestError('ALREADY_IN_OTHER_HOME', 'You are already in another home');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.alreadyInOtherHome);
    });

    test('maps FORBIDDEN to forbidden', () {
      final error = _postgrestError('FORBIDDEN', 'Access denied');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.forbidden);
    });

    test('maps AuthException to unauthorized', () {
      final error = AuthException('Not authenticated');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.unauthorized);
      expect(result.message, 'Not authenticated');
    });

    test('maps unknown error code to unknown', () {
      final error = _postgrestError('SOME_NEW_ERROR', 'Unknown error');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.unknown);
    });

    test('maps generic exception to unknown', () {
      final error = Exception('Network error');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.unknown);
      expect(result.message, contains('Network error'));
    });

    test('preserves details from error', () {
      final error = _postgrestError(
        'INVALID_CODE',
        'Invalid code',
        details: {'code': 'ABC123'},
      );
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.details, {'code': 'ABC123'});
    });
  });

  group('SupabaseErrorMapper.mapCreate', () {
    test('maps PROFILE_DEACTIVATED to profileDeactivated', () {
      final error = _postgrestError('PROFILE_DEACTIVATED', 'Profile deactivated');
      final result = SupabaseErrorMapper.mapCreate(error);

      expect(result, isA<HomeCreateException>());
      expect(result.code, CreateHomeErrorCode.profileDeactivated);
    });

    test('maps ALREADY_IN_OTHER_HOME to alreadyInOtherHome', () {
      final error = _postgrestError('ALREADY_IN_OTHER_HOME', 'Already in home');
      final result = SupabaseErrorMapper.mapCreate(error);

      expect(result.code, CreateHomeErrorCode.alreadyInOtherHome);
    });

    test('maps AuthException to unauthorized', () {
      final error = AuthException('Session expired');
      final result = SupabaseErrorMapper.mapCreate(error);

      expect(result.code, CreateHomeErrorCode.unauthorized);
    });
  });

  group('SupabaseErrorMapper.mapLeave', () {
    test('maps NOT_MEMBER to notMember', () {
      final error = _postgrestError('NOT_MEMBER', 'You are not a member');
      final result = SupabaseErrorMapper.mapLeave(error);

      expect(result, isA<LeaveException>());
      expect(result.code, LeaveErrorCode.notMember);
    });

    test('maps OWNER_MUST_TRANSFER_FIRST to ownerMustTransferFirst', () {
      final error = _postgrestError('OWNER_MUST_TRANSFER_FIRST', 'Transfer ownership first');
      final result = SupabaseErrorMapper.mapLeave(error);

      expect(result.code, LeaveErrorCode.ownerMustTransferFirst);
    });

    test('maps STATE_CHANGED_RETRY to stateChangedRetry', () {
      final error = _postgrestError('STATE_CHANGED_RETRY', 'State changed, retry');
      final result = SupabaseErrorMapper.mapLeave(error);

      expect(result.code, LeaveErrorCode.stateChangedRetry);
    });
  });

  group('SupabaseErrorMapper.mapTransfer', () {
    test('maps INVALID_NEW_OWNER to invalidNewOwner', () {
      final error = _postgrestError('INVALID_NEW_OWNER', 'Invalid owner');
      final result = SupabaseErrorMapper.mapTransfer(error);

      expect(result, isA<TransferOwnerException>());
      expect(result.code, TransferErrorCode.invalidNewOwner);
    });

    test('maps NEW_OWNER_NOT_MEMBER to newOwnerNotMember', () {
      final error = _postgrestError('NEW_OWNER_NOT_MEMBER', 'Not a member');
      final result = SupabaseErrorMapper.mapTransfer(error);

      expect(result.code, TransferErrorCode.newOwnerNotMember);
    });
  });

  group('SupabaseErrorMapper.mapKick', () {
    test('maps TARGET_NOT_MEMBER to targetNotMember', () {
      final error = _postgrestError('TARGET_NOT_MEMBER', 'Target not member');
      final result = SupabaseErrorMapper.mapKick(error);

      expect(result, isA<KickMemberException>());
      expect(result.code, KickMemberErrorCode.targetNotMember);
    });

    test('maps CANNOT_KICK_OWNER to cannotKickOwner', () {
      final error = _postgrestError('CANNOT_KICK_OWNER', 'Cannot kick owner');
      final result = SupabaseErrorMapper.mapKick(error);

      expect(result.code, KickMemberErrorCode.cannotKickOwner);
    });

    test('maps HOME_INACTIVE to homeInactive', () {
      final error = _postgrestError('HOME_INACTIVE', 'Home is inactive');
      final result = SupabaseErrorMapper.mapKick(error);

      expect(result.code, KickMemberErrorCode.homeInactive);
    });

    test('maps HOME_NOT_FOUND to homeInactive', () {
      final error = _postgrestError('HOME_NOT_FOUND', 'Home not found');
      final result = SupabaseErrorMapper.mapKick(error);

      expect(result.code, KickMemberErrorCode.homeInactive);
    });
  });

  group('SupabaseErrorMapper.mapChore', () {
    test('maps INVALID_INPUT to invalidInput', () {
      final error = _postgrestError('INVALID_INPUT', 'Invalid input');
      final result = SupabaseErrorMapper.mapChore(error);

      expect(result, isA<ChoreException>());
      expect(result.code, ChoreErrorCode.invalidInput);
    });

    test('maps INVALID_NAME to invalidInput', () {
      final error = _postgrestError('INVALID_NAME', 'Name is required');
      final result = SupabaseErrorMapper.mapChore(error);

      expect(result.code, ChoreErrorCode.invalidInput);
    });

    test('maps ASSIGNEE_NOT_MEMBER to assigneeNotMember', () {
      final error = _postgrestError('ASSIGNEE_NOT_MEMBER', 'Assignee not member');
      final result = SupabaseErrorMapper.mapChore(error);

      expect(result.code, ChoreErrorCode.assigneeNotMember);
    });

    test('maps PAYWALL_LIMIT_ACTIVE_CHORES to paywallActiveCap', () {
      final error = _postgrestError('PAYWALL_LIMIT_ACTIVE_CHORES', 'Chore limit reached');
      final result = SupabaseErrorMapper.mapChore(error);

      expect(result.code, ChoreErrorCode.paywallActiveCap);
    });

    test('maps PAYWALL_LIMIT_CHORE_PHOTOS to paywallMediaCap', () {
      final error = _postgrestError('PAYWALL_LIMIT_CHORE_PHOTOS', 'Photo limit reached');
      final result = SupabaseErrorMapper.mapChore(error);

      expect(result.code, ChoreErrorCode.paywallMediaCap);
    });

    test('maps NOT_FOUND to notFound', () {
      final error = _postgrestError('NOT_FOUND', 'Chore not found');
      final result = SupabaseErrorMapper.mapChore(error);

      expect(result.code, ChoreErrorCode.notFound);
    });

    test('maps CHORE_NOT_FOUND to notFound', () {
      final error = _postgrestError('CHORE_NOT_FOUND', 'Chore not found');
      final result = SupabaseErrorMapper.mapChore(error);

      expect(result.code, ChoreErrorCode.notFound);
    });

    test('maps AuthException to unauthorized', () {
      final error = AuthException('Token expired');
      final result = SupabaseErrorMapper.mapChore(error);

      expect(result.code, ChoreErrorCode.unauthorized);
    });
  });

  group('SupabaseErrorMapper.mapExpense', () {
    test('maps INVALID_AMOUNT to invalidAmount', () {
      final error = _postgrestError('INVALID_AMOUNT', 'Amount must be positive');
      final result = SupabaseErrorMapper.mapExpense(error);

      expect(result, isA<ExpenseException>());
      expect(result.code, ExpenseErrorCode.invalidAmount);
    });

    test('maps INVALID_DESCRIPTION to invalidDescription', () {
      final error = _postgrestError('INVALID_DESCRIPTION', 'Description required');
      final result = SupabaseErrorMapper.mapExpense(error);

      expect(result.code, ExpenseErrorCode.invalidDescription);
    });

    test('maps SPLIT_SUM_MISMATCH to splitSumMismatch', () {
      final error = _postgrestError('SPLIT_SUM_MISMATCH', 'Splits do not sum to total');
      final result = SupabaseErrorMapper.mapExpense(error);

      expect(result.code, ExpenseErrorCode.splitSumMismatch);
    });

    test('maps EXPENSE_LOCKED_AFTER_PAYMENT to lockedAfterPayment', () {
      final error = _postgrestError('EXPENSE_LOCKED_AFTER_PAYMENT', 'Cannot edit after payment');
      final result = SupabaseErrorMapper.mapExpense(error);

      expect(result.code, ExpenseErrorCode.lockedAfterPayment);
    });

    test('maps PAYWALL_LIMIT_ACTIVE_EXPENSES to paywallActiveExpensesCap', () {
      final error = _postgrestError('PAYWALL_LIMIT_ACTIVE_EXPENSES', 'Expense limit');
      final result = SupabaseErrorMapper.mapExpense(error);

      expect(result.code, ExpenseErrorCode.paywallActiveExpensesCap);
    });

    test('maps NOT_CREATOR to notCreator', () {
      final error = _postgrestError('NOT_CREATOR', 'Only creator can edit');
      final result = SupabaseErrorMapper.mapExpense(error);

      expect(result.code, ExpenseErrorCode.notCreator);
    });

    test('maps AuthException to unauthorized', () {
      final error = AuthException('Not logged in');
      final result = SupabaseErrorMapper.mapExpense(error);

      expect(result.code, ExpenseErrorCode.unauthorized);
    });
  });

  group('SupabaseErrorMapper.mapMoodSubmit', () {
    test('maps INVALID_MOOD to invalidMood', () {
      final error = _postgrestError('INVALID_MOOD', 'Invalid mood value');
      final result = SupabaseErrorMapper.mapMoodSubmit(error);

      expect(result, isA<MoodSubmitException>());
      expect(result.code, MoodSubmitErrorCode.invalidMood);
    });

    test('maps MOOD_ALREADY_SUBMITTED to moodAlreadySubmitted', () {
      final error = _postgrestError('MOOD_ALREADY_SUBMITTED', 'Already submitted');
      final result = SupabaseErrorMapper.mapMoodSubmit(error);

      expect(result.code, MoodSubmitErrorCode.moodAlreadySubmitted);
    });
  });

  group('SupabaseErrorMapper.mapNpsSubmit', () {
    test('maps INVALID_NPS_SCORE to invalidScore', () {
      final error = _postgrestError('INVALID_NPS_SCORE', 'Score must be 0-10');
      final result = SupabaseErrorMapper.mapNpsSubmit(error);

      expect(result, isA<NpsSubmitException>());
      expect(result.code, NpsSubmitErrorCode.invalidScore);
    });

    test('maps NPS_NOT_ELIGIBLE to notEligible', () {
      final error = _postgrestError('NPS_NOT_ELIGIBLE', 'Not eligible for NPS');
      final result = SupabaseErrorMapper.mapNpsSubmit(error);

      expect(result.code, NpsSubmitErrorCode.notEligible);
    });

    test('maps NPS_NOT_REQUIRED to notRequired', () {
      final error = _postgrestError('NPS_NOT_REQUIRED', 'NPS not required');
      final result = SupabaseErrorMapper.mapNpsSubmit(error);

      expect(result.code, NpsSubmitErrorCode.notRequired);
    });
  });

  group('SupabaseErrorMapper.mapRotate', () {
    test('maps FORBIDDEN to forbidden', () {
      final error = _postgrestError('FORBIDDEN', 'Not allowed');
      final result = SupabaseErrorMapper.mapRotate(error);

      expect(result, isA<InviteRotateException>());
      expect(result.code, RotateErrorCode.forbidden);
    });

    test('maps AuthException to unauthorized', () {
      final error = AuthException('Not authenticated');
      final result = SupabaseErrorMapper.mapRotate(error);

      expect(result.code, RotateErrorCode.unauthorized);
    });
  });

  group('SupabaseErrorMapper.mapRevoke', () {
    test('maps FORBIDDEN to forbidden', () {
      final error = _postgrestError('FORBIDDEN', 'Not allowed');
      final result = SupabaseErrorMapper.mapRevoke(error);

      expect(result, isA<InviteRevokeException>());
      expect(result.code, RevokeErrorCode.forbidden);
    });
  });

  group('SupabaseErrorMapper.mapInviteGetOrCreate', () {
    test('maps FORBIDDEN to forbidden', () {
      final error = _postgrestError('FORBIDDEN', 'Not allowed');
      final result = SupabaseErrorMapper.mapInviteGetOrCreate(error);

      expect(result, isA<InviteGetOrCreateException>());
      expect(result.code, InviteGetOrCreateErrorCode.forbidden);
    });

    test('infers inactiveHome from message containing inactive', () {
      final error = _postgrestPlainError('{"code": "UNKNOWN", "message": "Home is inactive"}');
      final result = SupabaseErrorMapper.mapInviteGetOrCreate(error);

      expect(result.code, InviteGetOrCreateErrorCode.inactiveHome);
    });

    test('infers inactiveHome from message containing not found', () {
      final error = _postgrestPlainError('{"code": "UNKNOWN", "message": "Home not found"}');
      final result = SupabaseErrorMapper.mapInviteGetOrCreate(error);

      expect(result.code, InviteGetOrCreateErrorCode.inactiveHome);
    });
  });

  group('Error JSON parsing', () {
    test('handles malformed JSON gracefully', () {
      final error = _postgrestPlainError('Not valid JSON');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.unknown);
      expect(result.message, 'Not valid JSON');
    });

    test('handles empty message', () {
      final error = _postgrestPlainError('');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.unknown);
    });

    test('handles lowercase error codes', () {
      final error = _postgrestPlainError('{"code": "invalid_code", "message": "Bad code"}');
      final result = SupabaseErrorMapper.mapJoin(error);

      expect(result.code, JoinErrorCode.invalidCode);
    });
  });

  group('Exception toString', () {
    test('HomeJoinException formats correctly', () {
      final exception = HomeJoinException(JoinErrorCode.invalidCode, 'Bad code');
      expect(exception.toString(), 'HomeJoinException(JoinErrorCode.invalidCode): Bad code');
    });

    test('ChoreException formats correctly', () {
      final exception = ChoreException(ChoreErrorCode.notFound, 'Not found');
      expect(exception.toString(), 'ChoreException(ChoreErrorCode.notFound): Not found');
    });

    test('ExpenseException formats correctly', () {
      final exception = ExpenseException(ExpenseErrorCode.invalidAmount, 'Invalid');
      expect(exception.toString(), 'ExpenseException(ExpenseErrorCode.invalidAmount): Invalid');
    });
  });
}
