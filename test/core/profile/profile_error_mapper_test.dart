import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/core/profile/enums/profile_error_code.dart';
import 'package:kinly/core/profile/profile_error_mapper.dart';

void main() {
  group('ProfileErrorMapper', () {
    group('map', () {
      test('returns same exception if already ProfileIdentityException', () {
        final original = ProfileIdentityException(
          ProfileErrorCode.usernameTaken,
          'Username taken',
        );

        final result = ProfileErrorMapper.map(original);

        expect(identical(result, original), isTrue);
      });

      test('maps AuthException to unauthorized', () {
        final error = AuthException('Session expired');

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.unauthorized);
        expect(result.message, 'Session expired');
      });

      test('maps PostgrestException with USERNAME_TAKEN code', () {
        final error = PostgrestException(
          message: jsonEncode({
            'code': 'USERNAME_TAKEN',
            'message': 'This username is already in use',
          }),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.usernameTaken);
        expect(result.message, 'This username is already in use');
      });

      test('maps PostgrestException with AVATAR_NOT_FOUND code', () {
        final error = PostgrestException(
          message: jsonEncode({
            'code': 'AVATAR_NOT_FOUND',
            'message': 'Avatar does not exist',
          }),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.avatarNotFound);
        expect(result.message, 'Avatar does not exist');
      });

      test('maps PostgrestException with AVATAR_NOT_ALLOWED_FOR_PLAN code', () {
        final error = PostgrestException(
          message: jsonEncode({
            'code': 'AVATAR_NOT_ALLOWED_FOR_PLAN',
            'message': 'Upgrade to use this avatar',
          }),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.avatarNotAllowedForPlan);
        expect(result.message, 'Upgrade to use this avatar');
      });

      test('maps PostgrestException with AVATAR_IN_USE code', () {
        final error = PostgrestException(
          message: jsonEncode({
            'code': 'AVATAR_IN_USE',
            'message': 'Avatar is being used by another member',
          }),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.avatarInUse);
        expect(result.message, 'Avatar is being used by another member');
      });

      test('maps PostgrestException with INVALID_USERNAME code', () {
        final error = PostgrestException(
          message: jsonEncode({
            'code': 'INVALID_USERNAME',
            'message': 'Username contains invalid characters',
          }),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.invalidUsername);
        expect(result.message, 'Username contains invalid characters');
      });

      test('maps PostgrestException with PROFILE_NOT_FOUND code', () {
        final error = PostgrestException(
          message: jsonEncode({
            'code': 'PROFILE_NOT_FOUND',
            'message': 'Profile does not exist',
          }),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.profileNotFound);
        expect(result.message, 'Profile does not exist');
      });

      test('maps PostgrestException with FORBIDDEN code', () {
        final error = PostgrestException(
          message: jsonEncode({
            'code': 'FORBIDDEN',
            'message': 'Access denied',
          }),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.forbidden);
        expect(result.message, 'Access denied');
      });

      test('maps PostgrestException with UNAUTHORIZED code', () {
        final error = PostgrestException(
          message: jsonEncode({
            'code': 'UNAUTHORIZED',
            'message': 'Not authenticated',
          }),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.unauthorized);
        expect(result.message, 'Not authenticated');
      });

      test('maps PostgrestException with unknown code to unknown', () {
        final error = PostgrestException(
          message: jsonEncode({
            'code': 'SOME_NEW_ERROR',
            'message': 'Something unexpected',
          }),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.unknown);
        expect(result.message, 'Something unexpected');
      });

      test('maps PostgrestException with lowercase code', () {
        final error = PostgrestException(
          message: jsonEncode({'code': 'username_taken', 'message': 'Taken'}),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.usernameTaken);
      });

      test('maps PostgrestException with details', () {
        final error = PostgrestException(
          message: jsonEncode({
            'code': 'INVALID_USERNAME',
            'message': 'Invalid username',
            'details': {'field': 'username', 'reason': 'too_short'},
          }),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.invalidUsername);
        expect(result.details, {'field': 'username', 'reason': 'too_short'});
      });

      test('handles PostgrestException with non-JSON message', () {
        final error = PostgrestException(message: 'Plain text error');

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.unknown);
        expect(result.message, 'Plain text error');
      });

      test('handles PostgrestException with malformed JSON', () {
        final error = PostgrestException(message: '{invalid json');

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.unknown);
        expect(result.message, '{invalid json');
      });

      test('handles PostgrestException with null code in JSON', () {
        final error = PostgrestException(
          message: jsonEncode({'message': 'Error without code'}),
        );

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.unknown);
        expect(result.message, 'Error without code');
      });

      test('maps generic exception to unknown', () {
        final error = Exception('Something went wrong');

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.unknown);
        expect(result.message, contains('Something went wrong'));
      });

      test('maps string error to unknown', () {
        const error = 'String error';

        final result = ProfileErrorMapper.map(error);

        expect(result.code, ProfileErrorCode.unknown);
        expect(result.message, 'String error');
      });
    });
  });

  group('ProfileIdentityException', () {
    test('toString includes code and message', () {
      final exception = ProfileIdentityException(
        ProfileErrorCode.usernameTaken,
        'Username already taken',
      );

      final result = exception.toString();

      expect(result, contains('ProfileIdentityException'));
      expect(result, contains('usernameTaken'));
      expect(result, contains('Username already taken'));
    });

    test('stores details when provided', () {
      final exception = ProfileIdentityException(
        ProfileErrorCode.invalidUsername,
        'Invalid',
        details: {'field': 'username'},
      );

      expect(exception.details, {'field': 'username'});
    });

    test('details is null when not provided', () {
      final exception = ProfileIdentityException(
        ProfileErrorCode.unknown,
        'Error',
      );

      expect(exception.details, isNull);
    });
  });
}
