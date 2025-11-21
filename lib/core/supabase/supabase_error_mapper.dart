import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'enums/chore_error_code.dart';
import 'enums/expense_error_code.dart';
import 'enums/home_error_codes.dart';

export 'enums/chore_error_code.dart';
export 'enums/expense_error_code.dart';
export 'enums/home_error_codes.dart';

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
      switch (parsed.code) {
        case 'ALREADY_IN_OTHER_HOME':
          return HomeCreateException(
            CreateHomeErrorCode.alreadyInOtherHome,
            parsed.message,
            details: parsed.details,
          );
        case 'FORBIDDEN':
          return HomeCreateException(
            CreateHomeErrorCode.forbidden,
            parsed.message,
            details: parsed.details,
          );
        case 'UNAUTHORIZED':
          return HomeCreateException(
            CreateHomeErrorCode.unauthorized,
            parsed.message,
            details: parsed.details,
          );
        default:
          return HomeCreateException(
            CreateHomeErrorCode.unknown,
            parsed.message,
            details: parsed.details,
          );
      }
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
      switch (parsed.code) {
        case 'FORBIDDEN':
          return InviteRotateException(
            RotateErrorCode.forbidden,
            parsed.message,
            details: parsed.details,
          );
        case 'UNAUTHORIZED':
          return InviteRotateException(
            RotateErrorCode.unauthorized,
            parsed.message,
            details: parsed.details,
          );
        default:
          return InviteRotateException(
            RotateErrorCode.unknown,
            parsed.message,
            details: parsed.details,
          );
      }
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
      switch (parsed.code) {
        case 'FORBIDDEN':
          return InviteRevokeException(
            RevokeErrorCode.forbidden,
            parsed.message,
            details: parsed.details,
          );
        case 'UNAUTHORIZED':
          return InviteRevokeException(
            RevokeErrorCode.unauthorized,
            parsed.message,
            details: parsed.details,
          );
        default:
          return InviteRevokeException(
            RevokeErrorCode.unknown,
            parsed.message,
            details: parsed.details,
          );
      }
    }
    return InviteRevokeException(RevokeErrorCode.unknown, error.toString());
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
      switch (parsed.code) {
        case 'INVALID_NEW_OWNER':
          return TransferOwnerException(
            TransferErrorCode.invalidNewOwner,
            parsed.message,
            details: parsed.details,
          );
        case 'NEW_OWNER_NOT_MEMBER':
          return TransferOwnerException(
            TransferErrorCode.newOwnerNotMember,
            parsed.message,
            details: parsed.details,
          );
        case 'FORBIDDEN':
          return TransferOwnerException(
            TransferErrorCode.forbidden,
            parsed.message,
            details: parsed.details,
          );
        case 'STATE_CHANGED_RETRY':
          return TransferOwnerException(
            TransferErrorCode.stateChangedRetry,
            parsed.message,
            details: parsed.details,
          );
        case 'UNAUTHORIZED':
          return TransferOwnerException(
            TransferErrorCode.unauthorized,
            parsed.message,
            details: parsed.details,
          );
        default:
          return TransferOwnerException(
            TransferErrorCode.unknown,
            parsed.message,
            details: parsed.details,
          );
      }
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
      switch (parsed.code) {
        case 'NOT_MEMBER':
          return LeaveException(
            LeaveErrorCode.notMember,
            parsed.message,
            details: parsed.details,
          );
        case 'OWNER_MUST_TRANSFER_FIRST':
          return LeaveException(
            LeaveErrorCode.ownerMustTransferFirst,
            parsed.message,
            details: parsed.details,
          );
        case 'STATE_CHANGED_RETRY':
          return LeaveException(
            LeaveErrorCode.stateChangedRetry,
            parsed.message,
            details: parsed.details,
          );
        case 'FORBIDDEN':
          return LeaveException(
            LeaveErrorCode.forbidden,
            parsed.message,
            details: parsed.details,
          );
        case 'UNAUTHORIZED':
          return LeaveException(
            LeaveErrorCode.unauthorized,
            parsed.message,
            details: parsed.details,
          );
        default:
          return LeaveException(
            LeaveErrorCode.unknown,
            parsed.message,
            details: parsed.details,
          );
      }
    }
    return LeaveException(LeaveErrorCode.unknown, error.toString());
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
      switch (parsed.code) {
        case 'INVALID_INPUT':
        case 'INVALID_NAME':
          return ChoreException(
            ChoreErrorCode.invalidInput,
            parsed.message,
            details: parsed.details,
          );
        case 'INVALID_STATE':
          return ChoreException(
            ChoreErrorCode.invalidState,
            parsed.message,
            details: parsed.details,
          );
        case 'INVALID_MEDIA_PATH':
          return ChoreException(
            ChoreErrorCode.invalidMediaPath,
            parsed.message,
            details: parsed.details,
          );
        case 'ASSIGNEE_NOT_MEMBER':
          return ChoreException(
            ChoreErrorCode.assigneeNotMember,
            parsed.message,
            details: parsed.details,
          );
        case 'ALREADY_FINALIZED':
          return ChoreException(
            ChoreErrorCode.alreadyFinalized,
            parsed.message,
            details: parsed.details,
          );
        case 'PAYWALL_LIMIT_ACTIVE_CHORES':
          return ChoreException(
            ChoreErrorCode.paywallActiveCap,
            parsed.message,
            details: parsed.details,
          );
        case 'PAYWALL_LIMIT_CHORE_PHOTOS':
          return ChoreException(
            ChoreErrorCode.paywallMediaCap,
            parsed.message,
            details: parsed.details,
          );
        case 'INVALID_START':
          return ChoreException(
            ChoreErrorCode.invalidStart,
            parsed.message,
            details: parsed.details,
          );
        case 'NOT_FOUND':
        case 'CHORE_NOT_FOUND':
          return ChoreException(
            ChoreErrorCode.notFound,
            parsed.message,
            details: parsed.details,
          );
        case 'NOT_HOME_MEMBER':
          return ChoreException(
            ChoreErrorCode.notHomeMember,
            parsed.message,
            details: parsed.details,
          );
        case 'FORBIDDEN':
          return ChoreException(
            ChoreErrorCode.forbidden,
            parsed.message,
            details: parsed.details,
          );
        case 'UNAUTHORIZED':
          return ChoreException(
            ChoreErrorCode.unauthorized,
            parsed.message,
            details: parsed.details,
          );
        default:
          return ChoreException(
            ChoreErrorCode.unknown,
            parsed.message,
            details: parsed.details,
          );
      }
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
      switch (parsed.code) {
        case 'INVALID_HOME':
          return ExpenseException(
            ExpenseErrorCode.invalidHome,
            parsed.message,
            details: parsed.details,
          );
        case 'INVALID_AMOUNT':
          return ExpenseException(
            ExpenseErrorCode.invalidAmount,
            parsed.message,
            details: parsed.details,
          );
        case 'INVALID_DESCRIPTION':
          return ExpenseException(
            ExpenseErrorCode.invalidDescription,
            parsed.message,
            details: parsed.details,
          );
        case 'INVALID_NOTES':
          return ExpenseException(
            ExpenseErrorCode.invalidNotes,
            parsed.message,
            details: parsed.details,
          );
        case 'NOT_HOME_MEMBER':
          return ExpenseException(
            ExpenseErrorCode.notHomeMember,
            parsed.message,
            details: parsed.details,
          );
        case 'HOME_INACTIVE':
          return ExpenseException(
            ExpenseErrorCode.homeInactive,
            parsed.message,
            details: parsed.details,
          );
        case 'INVALID_SPLIT':
          return ExpenseException(
            ExpenseErrorCode.invalidSplit,
            parsed.message,
            details: parsed.details,
          );
        case 'SPLIT_MEMBERS_REQUIRED':
          return ExpenseException(
            ExpenseErrorCode.splitMembersRequired,
            parsed.message,
            details: parsed.details,
          );
        case 'INVALID_DEBTOR':
          return ExpenseException(
            ExpenseErrorCode.invalidDebtor,
            parsed.message,
            details: parsed.details,
          );
        case 'SPLIT_SUM_MISMATCH':
          return ExpenseException(
            ExpenseErrorCode.splitSumMismatch,
            parsed.message,
            details: parsed.details,
          );
        case 'NOT_FOUND':
          return ExpenseException(
            ExpenseErrorCode.notFound,
            parsed.message,
            details: parsed.details,
          );
        case 'NOT_CREATOR':
          return ExpenseException(
            ExpenseErrorCode.notCreator,
            parsed.message,
            details: parsed.details,
          );
        case 'INVALID_STATE':
          return ExpenseException(
            ExpenseErrorCode.invalidState,
            parsed.message,
            details: parsed.details,
          );
        case 'SPLIT_REQUIRED':
          return ExpenseException(
            ExpenseErrorCode.splitRequired,
            parsed.message,
            details: parsed.details,
          );
        case 'EXPENSE_LOCKED_AFTER_PAYMENT':
          return ExpenseException(
            ExpenseErrorCode.lockedAfterPayment,
            parsed.message,
            details: parsed.details,
          );
        case 'EDIT_NOT_ALLOWED':
          return ExpenseException(
            ExpenseErrorCode.editNotAllowed,
            parsed.message,
            details: parsed.details,
          );
        case 'FORBIDDEN':
          return ExpenseException(
            ExpenseErrorCode.forbidden,
            parsed.message,
            details: parsed.details,
          );
        case 'UNAUTHORIZED':
          return ExpenseException(
            ExpenseErrorCode.unauthorized,
            parsed.message,
            details: parsed.details,
          );
        default:
          return ExpenseException(
            ExpenseErrorCode.unknown,
            parsed.message,
            details: parsed.details,
          );
      }
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
