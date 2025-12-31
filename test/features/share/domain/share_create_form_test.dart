import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/features/share/domain/share_create_form.dart';

void main() {
  group('ShareCreateForm', () {
    test('initial startDate is date-only', () {
      final form = ShareCreateForm.initial();

      expect(form.startDate.hour, 0);
      expect(form.startDate.minute, 0);
      expect(form.startDate.second, 0);
      expect(form.startDate.millisecond, 0);
      expect(form.startDate.microsecond, 0);
    });

    test('copyWith normalizes startDate to date-only', () {
      final form = ShareCreateForm.initial();
      final updated = form.copyWith(
        startDate: DateTime(2025, 12, 31, 23, 59, 59),
      );

      expect(updated.startDate, DateTime(2025, 12, 31));
    });
  });
}
