import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/flow/flow_chore_outcome.dart';

void main() {
  group('FlowChoreOutcome', () {
    test('constructs with all required fields', () {
      const outcome = FlowChoreOutcome(
        choreId: 'chore-123',
        isUpdate: true,
      );

      expect(outcome.choreId, 'chore-123');
      expect(outcome.isUpdate, true);
      expect(outcome.isDeleted, false);
      expect(outcome.isCompleted, false);
    });

    test('constructs with optional fields', () {
      const outcome = FlowChoreOutcome(
        choreId: 'chore-456',
        isUpdate: false,
        isDeleted: true,
        isCompleted: true,
      );

      expect(outcome.choreId, 'chore-456');
      expect(outcome.isUpdate, false);
      expect(outcome.isDeleted, true);
      expect(outcome.isCompleted, true);
    });
  });
}
