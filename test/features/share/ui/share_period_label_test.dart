import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:kinly/contracts/expenses/enums/expense_recurrence_unit.dart';
import 'package:kinly/features/share/ui/share_period_label.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  test('formats weekly period range', () async {
    final strings = await S.delegate.load(const Locale('en'));
    final label = sharePeriodLabel(
      recurrenceEvery: 1,
      recurrenceUnit: ExpenseRecurrenceUnit.week,
      startDate: DateTime(2024, 1, 1),
      strings: strings,
    );

    expect(label, 'Applies to January 1 - 7, 2024');
  });

  test('returns one-time label for non-recurring', () async {
    final strings = await S.delegate.load(const Locale('en'));
    final label = sharePeriodLabel(
      recurrenceEvery: null,
      recurrenceUnit: null,
      startDate: DateTime(2024, 1, 1),
      strings: strings,
    );

    expect(label, 'One time');
  });
}
