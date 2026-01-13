import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/expenses/enums/expense_status.dart';

void main() {
  group('ExpenseStatus', () {
    group('wireValue', () {
      test('draft has wireValue "draft"', () {
        expect(ExpenseStatus.draft.wireValue, 'draft');
      });

      test('active has wireValue "active"', () {
        expect(ExpenseStatus.active.wireValue, 'active');
      });

      test('cancelled has wireValue "cancelled"', () {
        expect(ExpenseStatus.cancelled.wireValue, 'cancelled');
      });
    });

    group('fromWire', () {
      test('parses "draft" to ExpenseStatus.draft', () {
        expect(ExpenseStatusWire.fromWire('draft'), ExpenseStatus.draft);
      });

      test('parses "active" to ExpenseStatus.active', () {
        expect(ExpenseStatusWire.fromWire('active'), ExpenseStatus.active);
      });

      test('parses "cancelled" to ExpenseStatus.cancelled', () {
        expect(
          ExpenseStatusWire.fromWire('cancelled'),
          ExpenseStatus.cancelled,
        );
      });

      test('returns draft for null', () {
        expect(ExpenseStatusWire.fromWire(null), ExpenseStatus.draft);
      });

      test('returns draft for unknown value', () {
        expect(ExpenseStatusWire.fromWire('unknown'), ExpenseStatus.draft);
      });
    });

    group('round-trip', () {
      test('all values survive round-trip through wireValue and fromWire', () {
        for (final status in ExpenseStatus.values) {
          final wireValue = status.wireValue;
          final parsed = ExpenseStatusWire.fromWire(wireValue);
          expect(parsed, status);
        }
      });
    });
  });
}
