import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/supabase/enums/chore_error_code.dart';

void main() {
  group('ChoreErrorCode', () {
    test('has 14 values', () {
      expect(ChoreErrorCode.values.length, 14);
    });

    test('contains input validation errors', () {
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.invalidInput));
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.invalidName));
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.invalidStart));
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.invalidState));
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.invalidMediaPath));
    });

    test('contains business rule errors', () {
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.assigneeNotMember));
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.alreadyFinalized));
    });

    test('contains paywall errors', () {
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.paywallActiveCap));
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.paywallMediaCap));
    });

    test('contains access errors', () {
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.notFound));
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.notHomeMember));
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.forbidden));
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.unauthorized));
      expect(ChoreErrorCode.values, contains(ChoreErrorCode.unknown));
    });
  });
}
