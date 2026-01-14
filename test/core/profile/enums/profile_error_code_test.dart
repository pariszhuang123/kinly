import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/profile/enums/profile_error_code.dart';

void main() {
  group('ProfileErrorCode', () {
    test('has 9 values', () {
      expect(ProfileErrorCode.values.length, 9);
    });

    test('usernameTaken is a value', () {
      expect(ProfileErrorCode.values, contains(ProfileErrorCode.usernameTaken));
    });

    test('avatarNotFound is a value', () {
      expect(
        ProfileErrorCode.values,
        contains(ProfileErrorCode.avatarNotFound),
      );
    });

    test('avatarNotAllowedForPlan is a value', () {
      expect(
        ProfileErrorCode.values,
        contains(ProfileErrorCode.avatarNotAllowedForPlan),
      );
    });

    test('avatarInUse is a value', () {
      expect(ProfileErrorCode.values, contains(ProfileErrorCode.avatarInUse));
    });

    test('invalidUsername is a value', () {
      expect(
        ProfileErrorCode.values,
        contains(ProfileErrorCode.invalidUsername),
      );
    });

    test('profileNotFound is a value', () {
      expect(
        ProfileErrorCode.values,
        contains(ProfileErrorCode.profileNotFound),
      );
    });

    test('unauthorized is a value', () {
      expect(ProfileErrorCode.values, contains(ProfileErrorCode.unauthorized));
    });

    test('forbidden is a value', () {
      expect(ProfileErrorCode.values, contains(ProfileErrorCode.forbidden));
    });

    test('unknown is a value', () {
      expect(ProfileErrorCode.values, contains(ProfileErrorCode.unknown));
    });
  });
}
