import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/features/flow/domain/flow_chore_form.dart';

void main() {
  group('FlowChoreForm', () {
    test('normalizes initial startDate to date-only', () {
      final start = DateTime(2025, 1, 31, 23, 45, 12);

      final form = FlowChoreForm.initial(startDate: start);

      expect(form.startDate, DateTime(2025, 1, 31));
    });

    test('normalizes copyWith startDate to date-only', () {
      final form = FlowChoreForm.initial(
        startDate: DateTime(2025, 1, 30, 8, 15, 0),
      );
      final updated = form.copyWith(
        startDate: DateTime(2026, 2, 1, 15, 30, 0),
      );

      expect(updated.startDate, DateTime(2026, 2, 1));
    });
  });
}
