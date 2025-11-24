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
      final parsed = _parseErrorJson(error.message);
      switch (parsed.code) {
        case 'USERNAME_TAKEN':
          return ProfileIdentityException(
            ProfileErrorCode.usernameTaken,
            parsed.message,
            details: parsed.details,
          );
        case 'AVATAR_NOT_FOUND':
          return ProfileIdentityException(
            ProfileErrorCode.avatarNotFound,
            parsed.message,
            details: parsed.details,
          );
        case 'AVATAR_NOT_ALLOWED_FOR_PLAN':
          return ProfileIdentityException(
            ProfileErrorCode.avatarNotAllowedForPlan,
            parsed.message,
            details: parsed.details,
          );
        case 'AVATAR_IN_USE':
          return ProfileIdentityException(
            ProfileErrorCode.avatarInUse,
            parsed.message,
            details: parsed.details,
          );
        case 'INVALID_USERNAME':
          return ProfileIdentityException(
            ProfileErrorCode.invalidUsername,
            parsed.message,
            details: parsed.details,
          );
        case 'PROFILE_NOT_FOUND':
          return ProfileIdentityException(
            ProfileErrorCode.profileNotFound,
            parsed.message,
            details: parsed.details,
          );
        case 'FORBIDDEN':
          return ProfileIdentityException(
            ProfileErrorCode.forbidden,
            parsed.message,
            details: parsed.details,
          );
        case 'UNAUTHORIZED':
          return ProfileIdentityException(
            ProfileErrorCode.unauthorized,
            parsed.message,
            details: parsed.details,
          );
        default:
          return ProfileIdentityException(
            ProfileErrorCode.unknown,
            parsed.message,
            details: parsed.details,
          );
      }
    }

    return ProfileIdentityException(ProfileErrorCode.unknown, error.toString());
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
