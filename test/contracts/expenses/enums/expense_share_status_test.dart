import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/expenses/enums/expense_share_status.dart';

void main() {
  group('ExpenseShareStatus', () {
    group('wireValue', () {
      test('unpaid has wireValue "unpaid"', () {
        expect(ExpenseShareStatus.unpaid.wireValue, 'unpaid');
      });

      test('paid has wireValue "paid"', () {
        expect(ExpenseShareStatus.paid.wireValue, 'paid');
      });
    });

    group('fromWire', () {
      test('parses "unpaid" to ExpenseShareStatus.unpaid', () {
        expect(
          ExpenseShareStatusWire.fromWire('unpaid'),
          ExpenseShareStatus.unpaid,
        );
      });

      test('parses "paid" to ExpenseShareStatus.paid', () {
        expect(
          ExpenseShareStatusWire.fromWire('paid'),
          ExpenseShareStatus.paid,
        );
      });

      test('returns unpaid for null', () {
        expect(
          ExpenseShareStatusWire.fromWire(null),
          ExpenseShareStatus.unpaid,
        );
      });

      test('returns unpaid for unknown value', () {
        expect(
          ExpenseShareStatusWire.fromWire('unknown'),
          ExpenseShareStatus.unpaid,
        );
      });
    });

    group('round-trip', () {
      test('all values survive round-trip through wireValue and fromWire', () {
        for (final status in ExpenseShareStatus.values) {
          final wireValue = status.wireValue;
          final parsed = ExpenseShareStatusWire.fromWire(wireValue);
          expect(parsed, status);
        }
      });
    });
  });
}
