import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:kinly/contracts/share/share_create_route_args.dart';
import 'package:kinly/contracts/expenses/enums/expense_recurrence_unit.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/features/share/bloc/share_create_bloc/share_create_bloc.dart';
import 'package:kinly/features/share/domain/share_create_form.dart';
import 'package:kinly/features/share/domain/share_participant.dart';
import 'package:kinly/features/share/domain/share_split_mode.dart';
import 'package:kinly/features/share/ui/widgets/share_create_form_view.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  group('ShareCreateFormView', () {
    Widget buildFormView(
      ShareCreateState state, {
      Map<String, TextEditingController>? customControllers,
      String? evidencePhotoUrl,
      ShareCreatePresentationMode presentationMode =
          ShareCreatePresentationMode.standard,
    }) {
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
            KinlyOpacity.defaults,
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
              preference: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.teal,
              ),
              shopping: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.blue,
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
            customControllers:
                customControllers ?? <String, TextEditingController>{},
            evidencePhotoUrl: evidencePhotoUrl,
            isUploadingEvidencePhoto: false,
            onEvidencePhotoCapture: () {},
            allowDelete: false,
            onDeleteRequested: null,
            presentationMode: presentationMode,
          ),
        ),
      );
    }

    Future<TextField> fieldByLabel(WidgetTester tester, String label) async {
      final finder = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == label,
      );
      if (finder.evaluate().isEmpty) {
        await tester.scrollUntilVisible(
          finder,
          300,
          scrollable: find.byType(Scrollable).first,
        );
      }
      expect(finder, findsOneWidget);
      return tester.widget<TextField>(finder);
    }

    Future<void> expandOptionalSection(WidgetTester tester) async {
      final s = S.of(tester.element(find.byType(ShareCreateFormView)));
      final titleFinder = find.text(s.flowChoreDetailMoreInfoTitle);
      if (titleFinder.evaluate().isEmpty) return;
      await tester.tap(titleFinder.first);
      await tester.pumpAndSettle();
    }

    testWidgets('shows cycle period helper for recurring expenses', (
      tester,
    ) async {
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
      final expectedEnd = DateFormat.d().format(
        startDate.add(const Duration(days: 6)),
      );

      expect(
        find.text(
          'Applies to $expectedPeriod - $expectedEnd, ${startDate.year}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows recurrence controls only when recurring', (
      tester,
    ) async {
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

    testWidgets(
      'disables description and context when editing is disabled',
      (tester) async {
        final state = ShareCreateState.initial(
          isEditing: true,
          editingExpenseId: 'expense-1',
          canEdit: false,
          editDisabledReason: 'RECURRING_CYCLE_IMMUTABLE',
        ).copyWith(
          isLoading: false,
          participants: const [],
        );

        await tester.pumpWidget(buildFormView(state));

        final s = S.of(tester.element(find.byType(ShareCreateFormView)));
        expect(
          (await fieldByLabel(tester, s.shareCreateDescriptionLabel)).enabled,
          isFalse,
        );
        await expandOptionalSection(tester);
        expect(
          (await fieldByLabel(tester, s.shareCreateNotesLabel)).enabled,
          isFalse,
        );
      },
    );

    testWidgets(
      'keeps description and context editable for amount-locked edits',
      (tester) async {
        final form = ShareCreateForm.initial().copyWith(
          splitMode: ShareSplitMode.equal,
          selectedParticipantIds: {'member_a', 'member_b'},
        );
        final state = ShareCreateState.initial(
          isEditing: true,
          editingExpenseId: 'expense-1',
          isAmountLocked: true,
          canEdit: true,
        ).copyWith(
          isLoading: false,
          participants: const [],
          form: form,
        );

        await tester.pumpWidget(buildFormView(state));

        final s = S.of(tester.element(find.byType(ShareCreateFormView)));
        expect(
          (await fieldByLabel(tester, s.shareCreateDescriptionLabel)).enabled,
          isTrue,
        );
        await expandOptionalSection(tester);
        expect(
          (await fieldByLabel(tester, s.shareCreateNotesLabel)).enabled,
          isTrue,
        );
        expect(
          (await fieldByLabel(tester, s.shareCreateAmountLabel)).enabled,
          isFalse,
        );
      },
    );

    testWidgets('keeps all fields editable in create mode', (tester) async {
      final state = ShareCreateState.initial(
        isEditing: false,
        isAmountLocked: true,
        canEdit: false,
      ).copyWith(
        isLoading: false,
        participants: const [],
      );

      await tester.pumpWidget(buildFormView(state));

      final s = S.of(tester.element(find.byType(ShareCreateFormView)));
      expect(
        (await fieldByLabel(tester, s.shareCreateDescriptionLabel)).enabled,
        isTrue,
      );
      await expandOptionalSection(tester);
      expect((await fieldByLabel(tester, s.shareCreateNotesLabel)).enabled, isTrue);
      expect((await fieldByLabel(tester, s.shareCreateAmountLabel)).enabled, isTrue);
    });

    testWidgets('shows custom split mismatch breakdown with positive difference', (
      tester,
    ) async {
      final form = ShareCreateForm.initial().copyWith(
        amountInput: '10.00',
        splitMode: ShareSplitMode.custom,
        selectedParticipantIds: {'member_a', 'member_b'},
        customAmountInputs: const {'member_a': '4.00', 'member_b': '3.00'},
      );
      final state = ShareCreateState.initial().copyWith(
        isLoading: false,
        showValidationErrors: true,
        participants: const [
          ShareParticipant(userId: 'member_a', displayName: 'Alice'),
          ShareParticipant(userId: 'member_b', displayName: 'Bob'),
        ],
        form: form,
      );

      await tester.pumpWidget(
        buildFormView(
          state,
          customControllers: {
            'member_a': TextEditingController(text: '4.00'),
            'member_b': TextEditingController(text: '3.00'),
          },
        ),
      );

      expect(find.textContaining('Total: \$10.00'), findsOneWidget);
      expect(find.textContaining('Included: \$7.00'), findsOneWidget);
      expect(find.textContaining('Difference: +\$3.00'), findsOneWidget);
    });

    testWidgets('shows custom split mismatch breakdown with negative difference', (
      tester,
    ) async {
      final form = ShareCreateForm.initial().copyWith(
        amountInput: '10.00',
        splitMode: ShareSplitMode.custom,
        selectedParticipantIds: {'member_a', 'member_b'},
        customAmountInputs: const {'member_a': '6.00', 'member_b': '6.00'},
      );
      final state = ShareCreateState.initial().copyWith(
        isLoading: false,
        showValidationErrors: true,
        participants: const [
          ShareParticipant(userId: 'member_a', displayName: 'Alice'),
          ShareParticipant(userId: 'member_b', displayName: 'Bob'),
        ],
        form: form,
      );

      await tester.pumpWidget(
        buildFormView(
          state,
          customControllers: {
            'member_a': TextEditingController(text: '6.00'),
            'member_b': TextEditingController(text: '6.00'),
          },
        ),
      );

      expect(find.textContaining('Total: \$10.00'), findsOneWidget);
      expect(find.textContaining('Included: \$12.00'), findsOneWidget);
      expect(find.textContaining('Difference: -\$2.00'), findsOneWidget);
    });

    testWidgets('shows creator-only validation for custom split', (
      tester,
    ) async {
      final form = ShareCreateForm.initial().copyWith(
        amountInput: '10.00',
        splitMode: ShareSplitMode.custom,
        selectedParticipantIds: {'member_self'},
        customAmountInputs: const {'member_self': '10.00'},
      );
      final state = ShareCreateState.initial().copyWith(
        isLoading: false,
        showValidationErrors: true,
        currentUserId: 'member_self',
        participants: const [
          ShareParticipant(userId: 'member_self', displayName: 'Taylor'),
        ],
        form: form,
      );

      await tester.pumpWidget(
        buildFormView(
          state,
          customControllers: {
            'member_self': TextEditingController(text: '10.00'),
          },
        ),
      );

      final s = S.of(tester.element(find.byType(ShareCreateFormView)));
      expect(find.text(s.shareCreateValidationCustomSinglePayer), findsOneWidget);
    });

    testWidgets('shows creator-only validation for equal split', (
      tester,
    ) async {
      final form = ShareCreateForm.initial().copyWith(
        amountInput: '10.00',
        splitMode: ShareSplitMode.equal,
        selectedParticipantIds: {'member_self'},
      );
      final state = ShareCreateState.initial().copyWith(
        isLoading: false,
        showValidationErrors: true,
        currentUserId: 'member_self',
        participants: const [
          ShareParticipant(userId: 'member_a', displayName: 'Alice'),
          ShareParticipant(userId: 'member_self', displayName: 'Taylor'),
        ],
        form: form,
      );

      await tester.pumpWidget(buildFormView(state));

      final s = S.of(tester.element(find.byType(ShareCreateFormView)));
      expect(find.text(s.shareCreateValidationCustomSinglePayer), findsOneWidget);
    });

    testWidgets('does not render a delete control for evidence photo', (
      tester,
    ) async {
      final form = ShareCreateForm.initial().copyWith(
        evidencePhotoPath: 'households/home-1/share/expenses/photo.jpg',
      );
      final state = ShareCreateState.initial(
        isEditing: true,
        editingExpenseId: 'expense-1',
      ).copyWith(
        isLoading: false,
        participants: const [],
        form: form,
      );

      await tester.pumpWidget(
        buildFormView(
          state,
          evidencePhotoUrl: 'https://example.com/photo.jpg',
        ),
      );

      final s = S.of(tester.element(find.byType(ShareCreateFormView)));
      expect(find.text(s.shareEditDeleteButton), findsNothing);
    });

    testWidgets('shopping quick create mode hides non-essential fields', (
      tester,
    ) async {
      final state = ShareCreateState.initial().copyWith(
        isLoading: false,
        participants: const [
          ShareParticipant(userId: 'member_a', displayName: 'Alice'),
          ShareParticipant(userId: 'member_b', displayName: 'Bob'),
        ],
        form: ShareCreateForm.initial().copyWith(
          amountInput: '42.00',
          splitMode: ShareSplitMode.equal,
          selectedParticipantIds: {'member_a', 'member_b'},
        ),
      );

      await tester.pumpWidget(
        buildFormView(
          state,
          presentationMode: ShareCreatePresentationMode.shoppingQuickCreate,
        ),
      );

      final s = S.of(tester.element(find.byType(ShareCreateFormView)));
      expect(find.text(s.shareCreateDescriptionLabel), findsNothing);
      expect(find.text(s.shareCreateStartLabel), findsNothing);
      expect(find.text(s.shareCreateRecurrenceLabel), findsNothing);
      expect(find.text(s.flowChoreDetailMoreInfoTitle), findsNothing);
      expect(find.text(s.shareCreateAmountLabel), findsOneWidget);
      expect(find.text(s.shareCreateSplitLabel), findsOneWidget);
    });
  });
}
