import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'enums/chore_error_code.dart';
import 'enums/expense_error_code.dart';
import 'enums/home_error_codes.dart';
import 'enums/mood_error_code.dart';
import 'enums/nps_submit_error_code.dart';

export 'enums/chore_error_code.dart';
export 'enums/expense_error_code.dart';
export 'enums/home_error_codes.dart';
export 'enums/mood_error_code.dart';
export 'enums/nps_submit_error_code.dart';

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
  static HomeJoinException mapJoin(Object error) {
    // Unauthorized at transport/auth level
    if (error is AuthException) {
      return HomeJoinException(JoinErrorCode.unauthorized, error.message);
    }

    if (error is PostgrestException) {
      // We raised MESSAGE as a JSON string containing { code, message, details }
      String? machineCode;
      String humanMessage = error.message;
      Map<String, dynamic>? details;
      try {
        final decoded = jsonDecode(error.message);
        if (decoded is Map<String, dynamic>) {
          machineCode = decoded['code'] as String?;
          humanMessage = (decoded['message'] as String?) ?? humanMessage;
          final d = decoded['details'];
          if (d is Map<String, dynamic>) details = d;
        }
      } catch (_) {
        // ignore: message not JSON — keep defaults
      }

      switch ((machineCode ?? '').toUpperCase()) {
        case 'INVALID_CODE':
          return HomeJoinException(
            JoinErrorCode.invalidCode,
            humanMessage,
            details: details,
          );
        case 'INACTIVE_INVITE':
          return HomeJoinException(
            JoinErrorCode.inactiveInvite,
            humanMessage,
            details: details,
          );
        case 'PAYWALL_LIMIT_ACTIVE_MEMBERS':
          return HomeJoinException(
            JoinErrorCode.paywallLimitActiveMembers,
            humanMessage,
            details: details,
          );
        case 'ALREADY_IN_OTHER_HOME':
          return HomeJoinException(
            JoinErrorCode.alreadyInOtherHome,
            humanMessage,
            details: details,
          );
        case 'FORBIDDEN':
          return HomeJoinException(
            JoinErrorCode.forbidden,
            humanMessage,
            details: details,
          );
        case 'UNAUTHORIZED':
          return HomeJoinException(
            JoinErrorCode.unauthorized,
            humanMessage,
            details: details,
          );
        default:
          return HomeJoinException(
            JoinErrorCode.unknown,
            humanMessage,
            details: details,
          );
      }
    }

    // Fallback for unexpected errors
    return HomeJoinException(JoinErrorCode.unknown, error.toString());
  }

  /// Map Supabase errors for homes.create RPC.
  static HomeCreateException mapCreate(Object error) {
    if (error is AuthException) {
      return HomeCreateException(
        CreateHomeErrorCode.unauthorized,
        error.message,
      );
    }

    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code =
          _createHomeCodeMap[parsed.code] ?? CreateHomeErrorCode.unknown;
      return HomeCreateException(code, parsed.message, details: parsed.details);
    }

    return HomeCreateException(CreateHomeErrorCode.unknown, error.toString());
  }

  // ----- invites.rotate -----
  static InviteRotateException mapRotate(Object error) {
    if (error is AuthException) {
      return InviteRotateException(RotateErrorCode.unauthorized, error.message);
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code = _rotateCodeMap[parsed.code] ?? RotateErrorCode.unknown;
      return InviteRotateException(
        code,
        parsed.message,
        details: parsed.details,
      );
    }
    return InviteRotateException(RotateErrorCode.unknown, error.toString());
  }

  // ----- invites.revoke -----
  static InviteRevokeException mapRevoke(Object error) {
    if (error is AuthException) {
      return InviteRevokeException(RevokeErrorCode.unauthorized, error.message);
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code = _revokeCodeMap[parsed.code] ?? RevokeErrorCode.unknown;
      return InviteRevokeException(
        code,
        parsed.message,
        details: parsed.details,
      );
    }
    return InviteRevokeException(RevokeErrorCode.unknown, error.toString());
  }

  // ----- invites.get_or_create -----
  static InviteGetOrCreateException mapInviteGetOrCreate(Object error) {
    if (error is AuthException) {
      return InviteGetOrCreateException(
        InviteGetOrCreateErrorCode.unauthorized,
        error.message,
      );
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
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
    }
    return InviteGetOrCreateException(
      InviteGetOrCreateErrorCode.unknown,
      error.toString(),
    );
  }

  // ----- homes.transfer_owner -----
  static TransferOwnerException mapTransfer(Object error) {
    if (error is AuthException) {
      return TransferOwnerException(
        TransferErrorCode.unauthorized,
        error.message,
      );
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code = _transferOwnerMap[parsed.code] ?? TransferErrorCode.unknown;
      return TransferOwnerException(
        code,
        parsed.message,
        details: parsed.details,
      );
    }
    return TransferOwnerException(TransferErrorCode.unknown, error.toString());
  }

  // ----- homes.leave -----
  static LeaveException mapLeave(Object error) {
    if (error is AuthException) {
      return LeaveException(LeaveErrorCode.unauthorized, error.message);
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code = _leaveMap[parsed.code] ?? LeaveErrorCode.unknown;
      return LeaveException(code, parsed.message, details: parsed.details);
    }
    return LeaveException(LeaveErrorCode.unknown, error.toString());
  }

  // ----- members.kick -----
  static KickMemberException mapKick(Object error) {
    if (error is AuthException) {
      return KickMemberException(
        KickMemberErrorCode.unauthorized,
        error.message,
      );
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code = _kickMap[parsed.code] ?? KickMemberErrorCode.unknown;
      return KickMemberException(code, parsed.message, details: parsed.details);
    }
    return KickMemberException(KickMemberErrorCode.unknown, error.toString());
  }

  // ----- mood.submit -----
  static MoodSubmitException mapMoodSubmit(Object error) {
    if (error is AuthException) {
      return MoodSubmitException(
        MoodSubmitErrorCode.unauthorized,
        error.message,
      );
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code = _moodSubmitMap[parsed.code] ?? MoodSubmitErrorCode.unknown;
      return MoodSubmitException(code, parsed.message, details: parsed.details);
    }
    return MoodSubmitException(MoodSubmitErrorCode.unknown, error.toString());
  }

  // ----- nps.submit -----
  static NpsSubmitException mapNpsSubmit(Object error) {
    if (error is AuthException) {
      return NpsSubmitException(NpsSubmitErrorCode.unauthorized, error.message);
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      final code = _npsSubmitMap[parsed.code] ?? NpsSubmitErrorCode.unknown;
      return NpsSubmitException(code, parsed.message, details: parsed.details);
    }
    return NpsSubmitException(NpsSubmitErrorCode.unknown, error.toString());
  }

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
}

class _Parsed {
  final String code;
  final String message;
  final Map<String, dynamic>? details;
  _Parsed({required this.code, required this.message, required this.details});
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

const _createHomeCodeMap = <String, CreateHomeErrorCode>{
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
