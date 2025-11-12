import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Error codes emitted by database RPCs via public.api_error/api_assert.
/// Keep these in sync with SQL migrations.
enum JoinErrorCode {
  invalidCode,
  inactiveInvite,
  alreadyInOtherHome,
  unauthorized,
  forbidden,
  unknown,
}

class HomeJoinException implements Exception {
  final JoinErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  HomeJoinException(this.code, this.message, {this.details});

  @override
  String toString() => 'HomeJoinException($code): $message';
}

class SupabaseErrorMapper {
  const SupabaseErrorMapper._();

  /// Map a PostgrestException thrown by Supabase RPC into a typed [HomeJoinException].
  static HomeJoinException mapJoin(Object error) {
    // Unauthorized at transport/auth level
    if (error is AuthException) {
      return HomeJoinException(
        JoinErrorCode.unauthorized,
        error.message,
      );
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
          return HomeJoinException(JoinErrorCode.invalidCode, humanMessage, details: details);
        case 'INACTIVE_INVITE':
          return HomeJoinException(JoinErrorCode.inactiveInvite, humanMessage, details: details);
        case 'ALREADY_IN_OTHER_HOME':
          return HomeJoinException(JoinErrorCode.alreadyInOtherHome, humanMessage, details: details);
        case 'FORBIDDEN':
          return HomeJoinException(JoinErrorCode.forbidden, humanMessage, details: details);
        case 'UNAUTHORIZED':
          return HomeJoinException(JoinErrorCode.unauthorized, humanMessage, details: details);
        default:
          return HomeJoinException(JoinErrorCode.unknown, humanMessage, details: details);
      }
    }

    // Fallback for unexpected errors
    return HomeJoinException(JoinErrorCode.unknown, error.toString());
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
          return InviteRotateException(RotateErrorCode.forbidden, parsed.message, details: parsed.details);
        case 'UNAUTHORIZED':
          return InviteRotateException(RotateErrorCode.unauthorized, parsed.message, details: parsed.details);
        default:
          return InviteRotateException(RotateErrorCode.unknown, parsed.message, details: parsed.details);
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
          return InviteRevokeException(RevokeErrorCode.forbidden, parsed.message, details: parsed.details);
        case 'UNAUTHORIZED':
          return InviteRevokeException(RevokeErrorCode.unauthorized, parsed.message, details: parsed.details);
        default:
          return InviteRevokeException(RevokeErrorCode.unknown, parsed.message, details: parsed.details);
      }
    }
    return InviteRevokeException(RevokeErrorCode.unknown, error.toString());
  }

  // ----- homes.transfer_owner -----
  static TransferOwnerException mapTransfer(Object error) {
    if (error is AuthException) {
      return TransferOwnerException(TransferErrorCode.unauthorized, error.message);
    }
    if (error is PostgrestException) {
      final parsed = _parseErrorJson(error.message);
      switch (parsed.code) {
        case 'INVALID_NEW_OWNER':
          return TransferOwnerException(TransferErrorCode.invalidNewOwner, parsed.message, details: parsed.details);
        case 'NEW_OWNER_NOT_MEMBER':
          return TransferOwnerException(TransferErrorCode.newOwnerNotMember, parsed.message, details: parsed.details);
        case 'FORBIDDEN':
          return TransferOwnerException(TransferErrorCode.forbidden, parsed.message, details: parsed.details);
        case 'UNAUTHORIZED':
          return TransferOwnerException(TransferErrorCode.unauthorized, parsed.message, details: parsed.details);
        default:
          return TransferOwnerException(TransferErrorCode.unknown, parsed.message, details: parsed.details);
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
          return LeaveException(LeaveErrorCode.notMember, parsed.message, details: parsed.details);
        case 'OWNER_MUST_TRANSFER_FIRST':
          return LeaveException(LeaveErrorCode.ownerMustTransferFirst, parsed.message, details: parsed.details);
        case 'STATE_CHANGED_RETRY':
          return LeaveException(LeaveErrorCode.stateChangedRetry, parsed.message, details: parsed.details);
        case 'FORBIDDEN':
          return LeaveException(LeaveErrorCode.forbidden, parsed.message, details: parsed.details);
        case 'UNAUTHORIZED':
          return LeaveException(LeaveErrorCode.unauthorized, parsed.message, details: parsed.details);
        default:
          return LeaveException(LeaveErrorCode.unknown, parsed.message, details: parsed.details);
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
          details: decoded['details'] is Map<String, dynamic> ? (decoded['details'] as Map<String, dynamic>) : null,
        );
      }
    } catch (_) {}
    return _Parsed(code: '', message: message, details: null);
  }
}

class _Parsed {
  final String code;
  final String message;
  final Map<String, dynamic>? details;
  _Parsed({required this.code, required this.message, required this.details});
}

// Rotate
enum RotateErrorCode { forbidden, unauthorized, unknown }

class InviteRotateException implements Exception {
  final RotateErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  InviteRotateException(this.code, this.message, {this.details});
  @override
  String toString() => 'InviteRotateException($code): $message';
}

// Revoke
enum RevokeErrorCode { forbidden, unauthorized, unknown }

class InviteRevokeException implements Exception {
  final RevokeErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  InviteRevokeException(this.code, this.message, {this.details});
  @override
  String toString() => 'InviteRevokeException($code): $message';
}

// Transfer
enum TransferErrorCode { invalidNewOwner, newOwnerNotMember, forbidden, unauthorized, unknown }

class TransferOwnerException implements Exception {
  final TransferErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  TransferOwnerException(this.code, this.message, {this.details});
  @override
  String toString() => 'TransferOwnerException($code): $message';
}

// Leave
enum LeaveErrorCode { notMember, ownerMustTransferFirst, stateChangedRetry, forbidden, unauthorized, unknown }

class LeaveException implements Exception {
  final LeaveErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
  LeaveException(this.code, this.message, {this.details});
  @override
  String toString() => 'LeaveException($code): $message';
}
