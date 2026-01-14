import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/expenses/enums/expense_split_type.dart';

void main() {
  group('ExpenseSplitType', () {
    group('wireValue', () {
      test('equal has wireValue "equal"', () {
        expect(ExpenseSplitType.equal.wireValue, 'equal');
      });

      test('custom has wireValue "custom"', () {
        expect(ExpenseSplitType.custom.wireValue, 'custom');
      });
    });

    group('fromWire', () {
      test('parses "equal" to ExpenseSplitType.equal', () {
        expect(ExpenseSplitTypeWire.fromWire('equal'), ExpenseSplitType.equal);
      });

      test('parses "custom" to ExpenseSplitType.custom', () {
        expect(
          ExpenseSplitTypeWire.fromWire('custom'),
          ExpenseSplitType.custom,
        );
      });

      test('returns null for null', () {
        expect(ExpenseSplitTypeWire.fromWire(null), isNull);
      });

      test('returns default (equal) for unknown value', () {
        expect(
          ExpenseSplitTypeWire.fromWire('unknown'),
          ExpenseSplitType.equal,
        );
      });
    });

    group('round-trip', () {
      test('all values survive round-trip through wireValue and fromWire', () {
        for (final type in ExpenseSplitType.values) {
          final wireValue = type.wireValue;
          final parsed = ExpenseSplitTypeWire.fromWire(wireValue);
          expect(parsed, type);
        }
      });
    });
  });
}
