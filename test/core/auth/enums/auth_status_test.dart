import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/auth/enums/auth_status.dart';

void main() {
  group('AuthStatus', () {
    test('has 3 values', () {
      expect(AuthStatus.values.length, 3);
    });

    test('unknown is a value', () {
      expect(AuthStatus.values, contains(AuthStatus.unknown));
    });

    test('unauthenticated is a value', () {
      expect(AuthStatus.values, contains(AuthStatus.unauthenticated));
    });

    test('authenticated is a value', () {
      expect(AuthStatus.values, contains(AuthStatus.authenticated));
    });

    test('unknown is first (index 0)', () {
      expect(AuthStatus.values[0], AuthStatus.unknown);
    });
  });

  group('AuthMembershipStatus', () {
    test('has 3 values', () {
      expect(AuthMembershipStatus.values.length, 3);
    });

    test('unknown is a value', () {
      expect(
        AuthMembershipStatus.values,
        contains(AuthMembershipStatus.unknown),
      );
    });

    test('none is a value', () {
      expect(AuthMembershipStatus.values, contains(AuthMembershipStatus.none));
    });

    test('active is a value', () {
      expect(
        AuthMembershipStatus.values,
        contains(AuthMembershipStatus.active),
      );
    });
  });
}
