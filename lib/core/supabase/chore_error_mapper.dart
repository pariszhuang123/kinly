import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'enums/chore_error_code.dart';

class ChoreException implements Exception {
  const ChoreException(this.code, this.message, {this.details});

  final ChoreErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  @override
  String toString() => 'ChoreException($code): $message';
}

ChoreException mapChoreError(Object error) {
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

_Parsed _parseErrorJson(String message) {
  try {
    final decoded = jsonDecode(message);
    if (decoded is Map<String, dynamic>) {
      return _Parsed(
        code: ((decoded['code'] as String?) ?? '').toUpperCase(),
        message: (decoded['message'] as String?) ?? message,
        details:
            decoded['details'] is Map<String, dynamic>
                ? decoded['details'] as Map<String, dynamic>
                : null,
      );
    }
  } catch (_) {}
  return _Parsed(code: '', message: message, details: null);
}

class _Parsed {
  const _Parsed({
    required this.code,
    required this.message,
    required this.details,
  });

  final String code;
  final String message;
  final Map<String, dynamic>? details;
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
