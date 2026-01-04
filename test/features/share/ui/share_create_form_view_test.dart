import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:kinly/contracts/expenses/enums/expense_recurrence_unit.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/features/share/bloc/share_create_bloc/share_create_bloc.dart';
import 'package:kinly/features/share/domain/share_create_form.dart';
import 'package:kinly/features/share/ui/widgets/share_create_form_view.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  group('ShareCreateFormView', () {
    Widget buildFormView(ShareCreateState state) {
      return MaterialApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData.light().copyWith(
          extensions: [
            const Spacing(
              xxs: 2,
              xs: 4,
              s: 8,
              m: 12,
              l: 16,
              xl: 24,
              xxl: 32,
              xxxl: 40,
            ),
            KinlySections(
              flow: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.teal,
              ),
              share: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.orange,
              ),
              pulse: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.red,
                accent: Colors.pink,
              ),
              empty: const SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.grey,
                accent: Colors.grey,
              ),
            ),
          ],
        ),
        home: Scaffold(
          body: ShareCreateFormView(
            state: state,
            shareColors: null,
            descriptionController: TextEditingController(),
            amountController: TextEditingController(),
            notesController: TextEditingController(),
            recurrenceEveryController: TextEditingController(),
            customControllers: <String, TextEditingController>{},
            allowDelete: false,
            onDeleteRequested: null,
          ),
        ),
      );
    }

    testWidgets('shows cycle period helper for recurring expenses', (tester) async {
      final startDate = DateTime(2026, 1, 1);
      final form = ShareCreateForm.initial().copyWith(
        recurrenceEvery: 1,
        recurrenceUnit: ExpenseRecurrenceUnit.week,
        startDate: startDate,
      );
      final state = ShareCreateState.initial().copyWith(
        isLoading: false,
        form: form,
        participants: const [],
      );

      await tester.pumpWidget(buildFormView(state));

      final expectedPeriod = DateFormat.MMMMd().format(startDate);
      final expectedEnd =
          DateFormat.d().format(startDate.add(const Duration(days: 6)));

      expect(
        find.text('Applies to $expectedPeriod - $expectedEnd, ${startDate.year}'),
        findsOneWidget,
      );
    });

    testWidgets('shows recurrence controls only when recurring', (tester) async {
      final baseState = ShareCreateState.initial().copyWith(
        isLoading: false,
        participants: const [],
      );

      await tester.pumpWidget(buildFormView(baseState));
      expect(find.text('Every'), findsNothing);

      final recurringState = baseState.copyWith(
        form: baseState.form.copyWith(
          recurrenceEvery: 1,
          recurrenceUnit: ExpenseRecurrenceUnit.week,
        ),
      );

      await tester.pumpWidget(buildFormView(recurringState));
      expect(find.text('Every'), findsOneWidget);
    });
  });
}
