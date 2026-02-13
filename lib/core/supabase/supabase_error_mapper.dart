import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'enums/chore_error_code.dart';
import 'enums/expense_error_code.dart';
import 'enums/home_error_codes.dart';
import 'enums/mood_error_code.dart';
import 'enums/nps_submit_error_code.dart';
import 'enums/shopping_list_error_code.dart';

export 'enums/chore_error_code.dart';
export 'enums/expense_error_code.dart';
export 'enums/home_error_codes.dart';
export 'enums/mood_error_code.dart';
export 'enums/nps_submit_error_code.dart';
export 'enums/shopping_list_error_code.dart';

class HomeJoinException implements Exception {
  final JoinErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  HomeJoinException(this.code, this.message, {this.details});

  @override
  String toString() => 'HomeJoinException($code): $message';
}

class HomeCreateException implements Exception {
  final CreateHomeErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  HomeCreateException(this.code, this.message, {this.details});

  @override
  String toString() => 'HomeCreateException($code): $message';
}

class SupabaseErrorMapper {
  const SupabaseErrorMapper._();

  /// Map a PostgrestException thrown by Supabase RPC into a typed [HomeJoinException].
  static HomeJoinException mapJoin(Object error) =>
      _mapWithAuth<HomeJoinException, JoinErrorCode>(
        error: error,
        authFactory:
            (message) => HomeJoinException(JoinErrorCode.unauthorized, message),
        postgrestFactory:
            (parsed) => HomeJoinException(
              _joinCodeMap[parsed.code] ?? JoinErrorCode.unknown,
              parsed.message,
              details: parsed.details,
            ),
        fallbackFactory:
            (message) => HomeJoinException(JoinErrorCode.unknown, message),
      );

  /// Map Supabase errors for homes.create RPC.
  static HomeCreateException mapCreate(Object error) =>
      _mapWithAuth<HomeCreateException, CreateHomeErrorCode>(
        error: error,
        authFactory:
            (message) =>
                HomeCreateException(CreateHomeErrorCode.unauthorized, message),
        postgrestFactory:
            (parsed) => HomeCreateException(
              _createHomeCodeMap[parsed.code] ?? CreateHomeErrorCode.unknown,
              parsed.message,
              details: parsed.details,
            ),
        fallbackFactory:
            (message) =>
                HomeCreateException(CreateHomeErrorCode.unknown, message),
      );

  // ----- invites.rotate -----
  static InviteRotateException mapRotate(Object error) =>
      _mapWithAuth<InviteRotateException, RotateErrorCode>(
        error: error,
        authFactory:
            (message) =>
                InviteRotateException(RotateErrorCode.unauthorized, message),
        postgrestFactory:
            (parsed) => InviteRotateException(
              _rotateCodeMap[parsed.code] ?? RotateErrorCode.unknown,
              parsed.message,
              details: parsed.details,
            ),
        fallbackFactory:
            (message) =>
                InviteRotateException(RotateErrorCode.unknown, message),
      );

  // ----- invites.revoke -----
  static InviteRevokeException mapRevoke(Object error) =>
      _mapWithAuth<InviteRevokeException, RevokeErrorCode>(
        error: error,
        authFactory:
            (message) =>
                InviteRevokeException(RevokeErrorCode.unauthorized, message),
        postgrestFactory:
            (parsed) => InviteRevokeException(
              _revokeCodeMap[parsed.code] ?? RevokeErrorCode.unknown,
              parsed.message,
              details: parsed.details,
            ),
        fallbackFactory:
            (message) =>
                InviteRevokeException(RevokeErrorCode.unknown, message),
      );

  // ----- invites.get_or_create -----
  static InviteGetOrCreateException mapInviteGetOrCreate(Object error) =>
      _mapWithAuth<InviteGetOrCreateException, InviteGetOrCreateErrorCode>(
        error: error,
        authFactory:
            (message) => InviteGetOrCreateException(
              InviteGetOrCreateErrorCode.unauthorized,
              message,
            ),
        postgrestFactory: (parsed) {
          final mapped = _inviteGetOrCreateMap[parsed.code];
          final code =
              mapped ??
              ((parsed.message.toLowerCase().contains('inactive') ||
                      parsed.message.toLowerCase().contains('not found'))
                  ? InviteGetOrCreateErrorCode.inactiveHome
                  : InviteGetOrCreateErrorCode.unknown);
          return InviteGetOrCreateException(
            code,
            parsed.message,
            details: parsed.details,
          );
        },
        fallbackFactory:
            (message) => InviteGetOrCreateException(
              InviteGetOrCreateErrorCode.unknown,
              message,
            ),
      );

  // ----- homes.transfer_owner -----
  static TransferOwnerException mapTransfer(Object error) =>
      _mapWithAuth<TransferOwnerException, TransferErrorCode>(
        error: error,
        authFactory:
            (message) =>
                TransferOwnerException(TransferErrorCode.unauthorized, message),
        postgrestFactory:
            (parsed) => TransferOwnerException(
              _transferOwnerMap[parsed.code] ?? TransferErrorCode.unknown,
              parsed.message,
              details: parsed.details,
            ),
        fallbackFactory:
            (message) =>
                TransferOwnerException(TransferErrorCode.unknown, message),
      );

  // ----- homes.leave -----
  static LeaveException mapLeave(Object error) =>
      _mapWithAuth<LeaveException, LeaveErrorCode>(
        error: error,
        authFactory:
            (message) => LeaveException(LeaveErrorCode.unauthorized, message),
        postgrestFactory:
            (parsed) => LeaveException(
              _leaveMap[parsed.code] ?? LeaveErrorCode.unknown,
              parsed.message,
              details: parsed.details,
            ),
        fallbackFactory:
            (message) => LeaveException(LeaveErrorCode.unknown, message),
      );

  // ----- members.kick -----
  static KickMemberException mapKick(Object error) =>
      _mapWithAuth<KickMemberException, KickMemberErrorCode>(
        error: error,
        authFactory:
            (message) =>
                KickMemberException(KickMemberErrorCode.unauthorized, message),
        postgrestFactory:
            (parsed) => KickMemberException(
              _kickMap[parsed.code] ?? KickMemberErrorCode.unknown,
              parsed.message,
              details: parsed.details,
            ),
        fallbackFactory:
            (message) =>
                KickMemberException(KickMemberErrorCode.unknown, message),
      );

  // ----- mood.submit -----
  static MoodSubmitException mapMoodSubmit(Object error) =>
      _mapWithAuth<MoodSubmitException, MoodSubmitErrorCode>(
        error: error,
        authFactory:
            (message) =>
                MoodSubmitException(MoodSubmitErrorCode.unauthorized, message),
        postgrestFactory:
            (parsed) => MoodSubmitException(
              _moodSubmitMap[parsed.code] ?? MoodSubmitErrorCode.unknown,
              parsed.message,
              details: parsed.details,
            ),
        fallbackFactory:
            (message) =>
                MoodSubmitException(MoodSubmitErrorCode.unknown, message),
      );

  // ----- nps.submit -----
  static NpsSubmitException mapNpsSubmit(Object error) =>
      _mapWithAuth<NpsSubmitException, NpsSubmitErrorCode>(
        error: error,
        authFactory:
            (message) =>
                NpsSubmitException(NpsSubmitErrorCode.unauthorized, message),
        postgrestFactory:
            (parsed) => NpsSubmitException(
              _npsSubmitMap[parsed.code] ?? NpsSubmitErrorCode.unknown,
              parsed.message,
              details: parsed.details,
            ),
        fallbackFactory:
            (message) =>
                NpsSubmitException(NpsSubmitErrorCode.unknown, message),
      );

  // Internal helper to parse JSON (code/message/details) from RPC errors
  static _Parsed _parseErrorJson(String message) {
    try {
      final decoded = jsonDecode(message);
      if (decoded is Map<String, dynamic>) {
        return _Parsed(
          code: ((decoded['code'] as String?) ?? '').toUpperCase(),
          message: (decoded['message'] as String?) ?? message,
          details:
              decoded['details'] is Map<String, dynamic>
                  ? (decoded['details'] as Map<String, dynamic>)
                  : null,
        );
      }
    } catch (_) {}
    return _Parsed(code: '', message: message, details: null);
  }

  /// Map chore RPC errors into [ChoreException].
  static ChoreException mapChore(Object error) {
    if (error is AuthException) {
      return ChoreException(ChoreErrorCode.unauthorized, error.message);
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code = _choreCodeMap[parsed.code] ?? ChoreErrorCode.unknown;
      return ChoreException(code, parsed.message, details: parsed.details);
    }
    return ChoreException(ChoreErrorCode.unknown, error.toString());
  }

  /// Maps expenses RPC errors into [ExpenseException].
  static ExpenseException mapExpense(Object error) {
    if (error is AuthException) {
      return ExpenseException(ExpenseErrorCode.unauthorized, error.message);
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code = _expenseCodeMap[parsed.code] ?? ExpenseErrorCode.unknown;
      return ExpenseException(code, parsed.message, details: parsed.details);
    }
    return ExpenseException(ExpenseErrorCode.unknown, error.toString());
  }

  /// Maps shopping list RPC errors into [ShoppingListException].
  static ShoppingListException mapShoppingList(Object error) {
    if (error is AuthException) {
      return ShoppingListException(
        ShoppingListErrorCode.unauthorized,
        error.message,
      );
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code =
          _shoppingListCodeMap[parsed.code] ?? ShoppingListErrorCode.unknown;
      return ShoppingListException(code, parsed.message, details: parsed.details);
    }
    return ShoppingListException(ShoppingListErrorCode.unknown, error.toString());
  }
}

class _Parsed {
  final String code;
  final String message;
  final Map<String, dynamic>? details;
  _Parsed({required this.code, required this.message, required this.details});
}

T _mapWithAuth<T, C>({
  required Object error,
  required T Function(String message) authFactory,
  required T Function(_Parsed parsed) postgrestFactory,
  required T Function(String message) fallbackFactory,
}) {
  if (error is AuthException) {
    return authFactory(error.message);
  }
  if (error is PostgrestException) {
    final parsed = SupabaseErrorMapper._parseErrorJson(error.message);
    return postgrestFactory(parsed);
  }
  return fallbackFactory(error.toString());
}

const _choreCodeMap = <String, ChoreErrorCode>{
  'INVALID_INPUT': ChoreErrorCode.invalidInput,
  'INVALID_NAME': ChoreErrorCode.invalidInput,
  'INVALID_STATE': ChoreErrorCode.invalidState,
  'INVALID_MEDIA_PATH': ChoreErrorCode.invalidMediaPath,
  'ASSIGNEE_NOT_MEMBER': ChoreErrorCode.assigneeNotMember,
  'ALREADY_FINALIZED': ChoreErrorCode.alreadyFinalized,
  'PAYWALL_LIMIT_ACTIVE_CHORES': ChoreErrorCode.paywallActiveCap,
  'PAYWALL_LIMIT_CHORE_PHOTOS': ChoreErrorCode.paywallMediaCap,
  'INVALID_START': ChoreErrorCode.invalidStart,
  'NOT_FOUND': ChoreErrorCode.notFound,
  'CHORE_NOT_FOUND': ChoreErrorCode.notFound,
  'NOT_HOME_MEMBER': ChoreErrorCode.notHomeMember,
  'FORBIDDEN': ChoreErrorCode.forbidden,
  'UNAUTHORIZED': ChoreErrorCode.unauthorized,
};

const _expenseCodeMap = <String, ExpenseErrorCode>{
  'INVALID_HOME': ExpenseErrorCode.invalidHome,
  'INVALID_AMOUNT': ExpenseErrorCode.invalidAmount,
  'INVALID_DESCRIPTION': ExpenseErrorCode.invalidDescription,
  'INVALID_NOTES': ExpenseErrorCode.invalidNotes,
  'INVALID_RECURRENCE': ExpenseErrorCode.invalidRecurrence,
  'INVALID_RECURRENCE_DRAFT': ExpenseErrorCode.invalidRecurrenceDraft,
  'INVALID_START_DATE': ExpenseErrorCode.invalidStartDate,
  'INVALID_START_DATE_RANGE': ExpenseErrorCode.invalidStartDateRange,
  'NOT_HOME_MEMBER': ExpenseErrorCode.notHomeMember,
  'HOME_INACTIVE': ExpenseErrorCode.homeInactive,
  'INVALID_SPLIT': ExpenseErrorCode.invalidSplit,
  'SPLIT_MEMBERS_REQUIRED': ExpenseErrorCode.splitMembersRequired,
  'INVALID_DEBTOR': ExpenseErrorCode.invalidDebtor,
  'SPLIT_SUM_MISMATCH': ExpenseErrorCode.splitSumMismatch,
  'NOT_FOUND': ExpenseErrorCode.notFound,
  'NOT_CREATOR': ExpenseErrorCode.notCreator,
  'INVALID_STATE': ExpenseErrorCode.invalidState,
  'SPLIT_REQUIRED': ExpenseErrorCode.splitRequired,
  'EXPENSE_LOCKED_AFTER_PAYMENT': ExpenseErrorCode.lockedAfterPayment,
  'EDIT_NOT_ALLOWED': ExpenseErrorCode.editNotAllowed,
  'PAYWALL_LIMIT_ACTIVE_EXPENSES': ExpenseErrorCode.paywallActiveExpensesCap,
  'FORBIDDEN': ExpenseErrorCode.forbidden,
  'UNAUTHORIZED': ExpenseErrorCode.unauthorized,
};

const _shoppingListCodeMap = <String, ShoppingListErrorCode>{
  'INVALID_NAME': ShoppingListErrorCode.invalidName,
  'INVALID_REFERENCE_PHOTO_PATH': ShoppingListErrorCode.invalidReferencePhotoPath,
  'PHOTO_DELETE_NOT_ALLOWED': ShoppingListErrorCode.photoDeleteNotAllowed,
  'NOT_HOME_MEMBER': ShoppingListErrorCode.notHomeMember,
  'ITEM_NOT_FOUND': ShoppingListErrorCode.itemNotFound,
  'ITEM_ALREADY_COMPLETED_BY_OTHER':
      ShoppingListErrorCode.itemAlreadyCompletedByOther,
  'INVALID_EXPENSE': ShoppingListErrorCode.invalidExpense,
  'PAYWALL_LIMIT_SHOPPING_ITEM_PHOTOS':
      ShoppingListErrorCode.paywallShoppingItemPhotosCap,
  'FORBIDDEN': ShoppingListErrorCode.forbidden,
  'UNAUTHORIZED': ShoppingListErrorCode.unauthorized,
};

const _joinCodeMap = <String, JoinErrorCode>{
  'INVALID_CODE': JoinErrorCode.invalidCode,
  'INACTIVE_INVITE': JoinErrorCode.inactiveInvite,
  'PROFILE_DEACTIVATED': JoinErrorCode.profileDeactivated,
  'PAYWALL_LIMIT_ACTIVE_MEMBERS': JoinErrorCode.paywallLimitActiveMembers,
  'ALREADY_IN_OTHER_HOME': JoinErrorCode.alreadyInOtherHome,
  'FORBIDDEN': JoinErrorCode.forbidden,
  'UNAUTHORIZED': JoinErrorCode.unauthorized,
};

const _createHomeCodeMap = <String, CreateHomeErrorCode>{
  'PROFILE_DEACTIVATED': CreateHomeErrorCode.profileDeactivated,
  'ALREADY_IN_OTHER_HOME': CreateHomeErrorCode.alreadyInOtherHome,
  'FORBIDDEN': CreateHomeErrorCode.forbidden,
  'UNAUTHORIZED': CreateHomeErrorCode.unauthorized,
};

const _rotateCodeMap = <String, RotateErrorCode>{
  'FORBIDDEN': RotateErrorCode.forbidden,
  'UNAUTHORIZED': RotateErrorCode.unauthorized,
};

const _revokeCodeMap = <String, RevokeErrorCode>{
  'FORBIDDEN': RevokeErrorCode.forbidden,
  'UNAUTHORIZED': RevokeErrorCode.unauthorized,
};

const _inviteGetOrCreateMap = <String, InviteGetOrCreateErrorCode?>{
  'FORBIDDEN': InviteGetOrCreateErrorCode.forbidden,
  'UNAUTHORIZED': InviteGetOrCreateErrorCode.unauthorized,
};

const _transferOwnerMap = <String, TransferErrorCode>{
  'INVALID_NEW_OWNER': TransferErrorCode.invalidNewOwner,
  'NEW_OWNER_NOT_MEMBER': TransferErrorCode.newOwnerNotMember,
  'FORBIDDEN': TransferErrorCode.forbidden,
  'STATE_CHANGED_RETRY': TransferErrorCode.stateChangedRetry,
  'UNAUTHORIZED': TransferErrorCode.unauthorized,
};

const _leaveMap = <String, LeaveErrorCode>{
  'NOT_MEMBER': LeaveErrorCode.notMember,
  'OWNER_MUST_TRANSFER_FIRST': LeaveErrorCode.ownerMustTransferFirst,
  'STATE_CHANGED_RETRY': LeaveErrorCode.stateChangedRetry,
  'FORBIDDEN': LeaveErrorCode.forbidden,
  'UNAUTHORIZED': LeaveErrorCode.unauthorized,
};

const _kickMap = <String, KickMemberErrorCode>{
  'TARGET_NOT_MEMBER': KickMemberErrorCode.targetNotMember,
  'CANNOT_KICK_OWNER': KickMemberErrorCode.cannotKickOwner,
  'STATE_CHANGED_RETRY': KickMemberErrorCode.stateChangedRetry,
  'HOME_INACTIVE': KickMemberErrorCode.homeInactive,
  'HOME_NOT_FOUND': KickMemberErrorCode.homeInactive,
  'FORBIDDEN': KickMemberErrorCode.forbidden,
  'UNAUTHORIZED': KickMemberErrorCode.unauthorized,
};

const _moodSubmitMap = <String, MoodSubmitErrorCode>{
  'INVALID_HOME': MoodSubmitErrorCode.invalidHome,
  'INVALID_MOOD': MoodSubmitErrorCode.invalidMood,
  'NOT_POSITIVE_MOOD': MoodSubmitErrorCode.notPositiveMood,
  'MENTION_LIMIT_EXCEEDED': MoodSubmitErrorCode.mentionLimitExceeded,
  'DUPLICATE_MENTIONS_NOT_ALLOWED': MoodSubmitErrorCode.duplicateMentions,
  'SELF_MENTION_NOT_ALLOWED': MoodSubmitErrorCode.selfMentionNotAllowed,
  'MENTION_NOT_HOME_MEMBER': MoodSubmitErrorCode.mentionNotHomeMember,
  'INVALID_MENTION_USER': MoodSubmitErrorCode.invalidMentionUser,
  'COMMENT_REQUIRED_FOR_MENTION':
      MoodSubmitErrorCode.commentRequiredForMention,
  'SINGLE_MENTION_REQUIRED': MoodSubmitErrorCode.singleMentionRequired,
  'COMMENT_REQUIRED_FOR_PUBLIC_WALL':
      MoodSubmitErrorCode.commentRequiredForPublicWall,
  'COMPLAINT_TOO_SHORT': MoodSubmitErrorCode.complaintTooShort,
  'COMPLAINT_TOO_BRIEF': MoodSubmitErrorCode.complaintTooBrief,
  'COMPLAINT_NEEDS_SENTENCE': MoodSubmitErrorCode.complaintNeedsSentence,
  'MOOD_ALREADY_SUBMITTED': MoodSubmitErrorCode.moodAlreadySubmitted,
  'FORBIDDEN': MoodSubmitErrorCode.forbidden,
  'UNAUTHORIZED': MoodSubmitErrorCode.unauthorized,
};

const _npsSubmitMap = <String, NpsSubmitErrorCode>{
  'INVALID_NPS_SCORE': NpsSubmitErrorCode.invalidScore,
  'NPS_NOT_ELIGIBLE': NpsSubmitErrorCode.notEligible,
  'NPS_NOT_REQUIRED': NpsSubmitErrorCode.notRequired,
  'FORBIDDEN': NpsSubmitErrorCode.forbidden,
  'UNAUTHORIZED': NpsSubmitErrorCode.unauthorized,
};

class InviteRotateException implements Exception {
  final RotateErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  InviteRotateException(this.code, this.message, {this.details});
  @override
  String toString() => 'InviteRotateException($code): $message';
}

class InviteRevokeException implements Exception {
  final RevokeErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  InviteRevokeException(this.code, this.message, {this.details});
  @override
  String toString() => 'InviteRevokeException($code): $message';
}

class InviteGetOrCreateException implements Exception {
  final InviteGetOrCreateErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  InviteGetOrCreateException(this.code, this.message, {this.details});
  @override
  String toString() => 'InviteGetOrCreateException($code): $message';
}

class TransferOwnerException implements Exception {
  final TransferErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  TransferOwnerException(this.code, this.message, {this.details});
  @override
  String toString() => 'TransferOwnerException($code): $message';
}

class LeaveException implements Exception {
  final LeaveErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  LeaveException(this.code, this.message, {this.details});
  @override
  String toString() => 'LeaveException($code): $message';
}

class KickMemberException implements Exception {
  final KickMemberErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  KickMemberException(this.code, this.message, {this.details});
  @override
  String toString() => 'KickMemberException($code): $message';
}

class ChoreException implements Exception {
  final ChoreErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  const ChoreException(this.code, this.message, {this.details});

  @override
  String toString() => 'ChoreException($code): $message';
}

class ExpenseException implements Exception {
  final ExpenseErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  const ExpenseException(this.code, this.message, {this.details});

  @override
  String toString() => 'ExpenseException($code): $message';
}

class ShoppingListException implements Exception {
  final ShoppingListErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  const ShoppingListException(this.code, this.message, {this.details});

  @override
  String toString() => 'ShoppingListException($code): $message';
}
