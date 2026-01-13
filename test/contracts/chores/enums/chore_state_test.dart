import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/chores/enums/chore_state.dart';

void main() {
  group('ChoreState', () {
    group('wireValue', () {
      test('draft has wireValue "draft"', () {
        expect(ChoreState.draft.wireValue, 'draft');
      });

      test('active has wireValue "active"', () {
        expect(ChoreState.active.wireValue, 'active');
      });

      test('completed has wireValue "completed"', () {
        expect(ChoreState.completed.wireValue, 'completed');
      });

      test('cancelled has wireValue "cancelled"', () {
        expect(ChoreState.cancelled.wireValue, 'cancelled');
      });
    });

    group('fromWire', () {
      test('parses "draft" to ChoreState.draft', () {
        expect(ChoreStateWire.fromWire('draft'), ChoreState.draft);
      });

      test('parses "active" to ChoreState.active', () {
        expect(ChoreStateWire.fromWire('active'), ChoreState.active);
      });

      test('parses "completed" to ChoreState.completed', () {
        expect(ChoreStateWire.fromWire('completed'), ChoreState.completed);
      });

      test('parses "cancelled" to ChoreState.cancelled', () {
        expect(ChoreStateWire.fromWire('cancelled'), ChoreState.cancelled);
      });

      test('returns draft for null', () {
        expect(ChoreStateWire.fromWire(null), ChoreState.draft);
      });

      test('returns draft for unknown value', () {
        expect(ChoreStateWire.fromWire('unknown'), ChoreState.draft);
      });
    });

    group('round-trip', () {
      test('all values survive round-trip through wireValue and fromWire', () {
        for (final state in ChoreState.values) {
          final wireValue = state.wireValue;
          final parsed = ChoreStateWire.fromWire(wireValue);
          expect(parsed, state);
        }
      });
    });
  });
}
