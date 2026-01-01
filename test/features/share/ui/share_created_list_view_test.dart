import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/expenses/enums/expense_recurrence_interval.dart';
import 'package:kinly/core/expenses/enums/expense_status.dart';
import 'package:kinly/features/share/bloc/share_created_list_bloc/share_created_list_bloc.dart';
import 'package:kinly/features/share/ui/widgets/share_created_list_view.dart';
import 'package:kinly/features/share/ui/share_period_label.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  group('ShareCreatedListView', () {
    testWidgets('shows empty state with copy and CTA', (tester) async {
      var tappedCreate = false;
      const shareColors = SectionColors(
        background: Colors.white,
        card: Colors.white,
        icon: Colors.blueGrey,
        accent: Colors.orange,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [S.delegate],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData.light().copyWith(
            extensions: const [
              Spacing(
                xxs: 2,
                xs: 4,
                s: 8,
                m: 12,
                l: 16,
                xl: 24,
                xxl: 32,
                xxxl: 40,
              ),
              KinlyOpacity.defaults,
              KinlySections(
                flow: shareColors,
                share: shareColors,
                pulse: shareColors,
                empty: shareColors,
              ),
            ],
          ),
          home: Scaffold(
            body: ShareCreatedListView(
              state: const ShareCreatedListState(
                status: ShareCreatedListStatus.success,
                entries: [],
              ),
              shareColors: shareColors,
              onRefreshRequested: () async {},
              onCreateTap: () => tappedCreate = true,
              onEntryTap: (_) {},
            ),
          ),
        ),
      );

      final s = await S.delegate.load(const Locale('en'));
      expect(find.text(s.shareCreatedListEmptyTitle), findsOneWidget);
      expect(find.text(s.shareCreatedListEmptySubtitle), findsOneWidget);
      expect(find.text(s.shareCreateSubmit), findsOneWidget);

      await tester.tap(find.text(s.shareCreateSubmit));
      await tester.pump();

      expect(tappedCreate, isTrue);
    });

    testWidgets('shows recurring period in subtitle', (tester) async {
      const shareColors = SectionColors(
        background: Colors.white,
        card: Colors.white,
        icon: Colors.blueGrey,
        accent: Colors.orange,
      );
      final s = await S.delegate.load(const Locale('en'));
      final startDate = DateTime(2026, 1, 6);
      final periodLabel = sharePeriodLabel(
        recurrence: ExpenseRecurrenceInterval.monthly,
        startDate: startDate,
        strings: s,
      );
      final progressLabel = s.shareCreatedListActiveSubtitle(1, 4);
      final subtitle = '$periodLabel\n$progressLabel';

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [S.delegate],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData.light().copyWith(
            extensions: const [
              Spacing(
                xxs: 2,
                xs: 4,
                s: 8,
                m: 12,
                l: 16,
                xl: 24,
                xxl: 32,
                xxxl: 40,
              ),
              KinlyOpacity.defaults,
              KinlySections(
                flow: shareColors,
                share: shareColors,
                pulse: shareColors,
                empty: shareColors,
              ),
            ],
          ),
          home: Scaffold(
            body: ShareCreatedListView(
              state: ShareCreatedListState(
                status: ShareCreatedListStatus.success,
                entries: [
                  ShareCreatedListEntry(
                    expenseId: 'expense-1',
                    description: 'Rent',
                    amountCents: 250000,
                    totalShares: 4,
                    paidShares: 1,
                    paidAmountCents: 62500,
                    status: ExpenseStatus.active,
                    createdAt: startDate,
                    recurrenceInterval: ExpenseRecurrenceInterval.monthly,
                    startDate: startDate,
                  ),
                ],
              ),
              shareColors: shareColors,
              onRefreshRequested: () async {},
              onCreateTap: () {},
              onEntryTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.text(subtitle), findsOneWidget);
      expect(find.text(progressLabel), findsNothing);
    });

    testWidgets('omits period label for non-recurring entries', (tester) async {
      const shareColors = SectionColors(
        background: Colors.white,
        card: Colors.white,
        icon: Colors.blueGrey,
        accent: Colors.orange,
      );
      final s = await S.delegate.load(const Locale('en'));
      final startDate = DateTime(2026, 1, 6);
      final progressLabel = s.shareCreatedListActiveSubtitle(1, 2);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [S.delegate],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData.light().copyWith(
            extensions: const [
              Spacing(
                xxs: 2,
                xs: 4,
                s: 8,
                m: 12,
                l: 16,
                xl: 24,
                xxl: 32,
                xxxl: 40,
              ),
              KinlyOpacity.defaults,
              KinlySections(
                flow: shareColors,
                share: shareColors,
                pulse: shareColors,
                empty: shareColors,
              ),
            ],
          ),
          home: Scaffold(
            body: ShareCreatedListView(
              state: ShareCreatedListState(
                status: ShareCreatedListStatus.success,
                entries: [
                  ShareCreatedListEntry(
                    expenseId: 'expense-2',
                    description: 'One-off fee',
                    amountCents: 5000,
                    totalShares: 2,
                    paidShares: 1,
                    paidAmountCents: 2500,
                    status: ExpenseStatus.active,
                    createdAt: startDate,
                    recurrenceInterval: ExpenseRecurrenceInterval.none,
                    startDate: startDate,
                  ),
                ],
              ),
              shareColors: shareColors,
              onRefreshRequested: () async {},
              onCreateTap: () {},
              onEntryTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.text(progressLabel), findsOneWidget);
      expect(find.textContaining(s.shareCreateCyclePeriod('')), findsNothing);
    });
  });
}
