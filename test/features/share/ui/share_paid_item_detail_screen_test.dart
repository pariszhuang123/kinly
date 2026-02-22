import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/share/ui/share_paid_item_detail_screen.dart';
import 'package:kinly/features/share/ui/share_paid_to_me_detail_models.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('en');
  });

  Widget buildSubject(TodaySharePaidItem item) {
    return MaterialApp(
      localizationsDelegates: const [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      theme: buildKinlyTheme(Brightness.light),
      home: SharePaidItemDetailScreen(item: item),
    );
  }

  testWidgets('hides comments and photo sections when data is absent', (
    tester,
  ) async {
    final item = TodaySharePaidItem(
      expenseId: 'exp-1',
      description: 'Internet',
      amountCents: 3200,
      markedPaidAt: DateTime(2024, 1, 1),
      recurrenceEvery: null,
      recurrenceUnit: null,
      startDate: DateTime(2024, 1, 1),
      notes: null,
      evidencePhotoPath: null,
    );

    await tester.pumpWidget(buildSubject(item));
    await tester.pumpAndSettle();

    final s = S.of(tester.element(find.byType(SharePaidItemDetailScreen)));
    expect(find.text(item.description), findsOneWidget);
    expect(find.text(s.shareCreateNotesLabel), findsNothing);
    expect(find.text(s.shoppingPhotoLabel), findsNothing);
  });

  testWidgets('shows comments and photo sections when data exists', (
    tester,
  ) async {
    final item = TodaySharePaidItem(
      expenseId: 'exp-2',
      description: 'Groceries',
      amountCents: 5400,
      markedPaidAt: DateTime(2024, 1, 1),
      recurrenceEvery: 1,
      recurrenceUnit: ExpenseRecurrenceUnit.week,
      startDate: DateTime(2024, 1, 1),
      notes: 'Paid after checkout',
      evidencePhotoPath: 'https://example.com/photo.jpg',
    );

    await tester.pumpWidget(buildSubject(item));
    await tester.pumpAndSettle();

    final s = S.of(tester.element(find.byType(SharePaidItemDetailScreen)));
    expect(find.text(item.notes!), findsOneWidget);
    expect(find.text(s.shareCreateNotesLabel), findsOneWidget);
    expect(find.text(s.shoppingPhotoLabel), findsOneWidget);
  });
}
