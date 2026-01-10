import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'enums/profile_error_code.dart';

class ProfileIdentityException implements Exception {
  final ProfileErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  const ProfileIdentityException(this.code, this.message, {this.details});

  @override
  String toString() => 'ProfileIdentityException($code): $message';
}

class ProfileErrorMapper {
  const ProfileErrorMapper._();

  /// Maps Supabase RPC errors for profile identity updates into typed codes.
  static ProfileIdentityException map(Object error) {
    if (error is ProfileIdentityException) return error;

    if (error is AuthException) {
      return ProfileIdentityException(
        ProfileErrorCode.unauthorized,
        error.message,
      );
    }

    if (error is PostgrestException) {
      return _mapPostgrestError(error.message);
    }

    return ProfileIdentityException(ProfileErrorCode.unknown, error.toString());
  }

  static ProfileIdentityException _mapPostgrestError(String message) {
    final parsed = _parseErrorJson(message);
    const codeMap = {
      'USERNAME_TAKEN': ProfileErrorCode.usernameTaken,
      'AVATAR_NOT_FOUND': ProfileErrorCode.avatarNotFound,
      'AVATAR_NOT_ALLOWED_FOR_PLAN': ProfileErrorCode.avatarNotAllowedForPlan,
      'AVATAR_IN_USE': ProfileErrorCode.avatarInUse,
      'INVALID_USERNAME': ProfileErrorCode.invalidUsername,
      'PROFILE_NOT_FOUND': ProfileErrorCode.profileNotFound,
      'FORBIDDEN': ProfileErrorCode.forbidden,
      'UNAUTHORIZED': ProfileErrorCode.unauthorized,
    };
    final code = codeMap[parsed.code] ?? ProfileErrorCode.unknown;

    return ProfileIdentityException(
      code,
      parsed.message,
      details: parsed.details,
    );
  }

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
}

class _Parsed {
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  _Parsed({required this.code, required this.message, required this.details});
}
