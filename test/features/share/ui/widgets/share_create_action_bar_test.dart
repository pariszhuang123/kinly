import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/features/share/bloc/share_create_bloc/share_create_bloc.dart';
import 'package:kinly/features/share/ui/widgets/share_create_action_bar.dart';
import 'package:kinly/generated/l10n.dart';

import 'package:kinly/renderer/material/theme/spacing.dart';

void main() {
  const spacing = Spacing(
    xxs: 2,
    xs: 4,
    s: 8,
    m: 12,
    l: 16,
    xl: 24,
    xxl: 32,
    xxxl: 40,
  );

  Widget buildSubject({
    required ShareCreateState state,
    bool showTerminatePlan = false,
    bool isTerminatingPlan = false,
    bool allowDelete = false,
  }) {
    return MaterialApp(
      theme: ThemeData(extensions: const [spacing]),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        body: ShareCreateActionBar(
          state: state,
          allowDelete: allowDelete,
          onDeleteRequested: () {},
          onSubmit: () {},
          showTerminatePlan: showTerminatePlan,
          isTerminatingPlan: isTerminatingPlan,
          onTerminatePlan: () {},
          onPaywallOpened: () {},
        ),
      ),
    );
  }

  group('ShareCreateActionBar', () {
    final defaultState = ShareCreateState.initial();

    testWidgets(
      'shows Update button and hides Terminate button when showTerminatePlan is false',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(state: defaultState, showTerminatePlan: false),
        );
        await tester.pumpAndSettle();

        final s = S.of(tester.element(find.byType(ShareCreateActionBar)));
        expect(find.text(s.shareCreateSubmit), findsOneWidget);
        expect(find.text(s.shareEditTerminatePlan), findsNothing);
      },
    );

    testWidgets(
      'shows Terminate button and hides Update button when showTerminatePlan is true',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(state: defaultState, showTerminatePlan: true),
        );
        await tester.pumpAndSettle();

        final s = S.of(tester.element(find.byType(ShareCreateActionBar)));
        expect(find.text(s.shareEditTerminatePlan), findsOneWidget);
        expect(find.text(s.shareCreateSubmit), findsNothing);
        expect(find.text(s.shareEditSubmit), findsNothing);
      },
    );

    testWidgets(
      'shows busy state for Terminate button when isTerminatingPlan is true',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(
            state: defaultState,
            showTerminatePlan: true,
            isTerminatingPlan: true,
          ),
        );
        await tester.pumpAndSettle();

        final s = S.of(tester.element(find.byType(ShareCreateActionBar)));
        expect(find.text(s.shareEditTerminatePlanBusy), findsOneWidget);
        expect(find.text(s.shareCreateSubmit), findsNothing);
      },
    );

    testWidgets(
      'shows Delete for pristine amount-locked edit when no one else has paid',
      (tester) async {
        final state = ShareCreateState.initial(
          isEditing: true,
          editingExpenseId: 'expense-1',
          isAmountLocked: true,
          canEdit: true,
        ).copyWith(
          allPaid: false,
          paidByOther: false,
          hasUserEdits: false,
        );

        await tester.pumpWidget(
          buildSubject(state: state, allowDelete: true),
        );
        await tester.pumpAndSettle();

        final s = S.of(tester.element(find.byType(ShareCreateActionBar)));
        expect(find.text(s.shareEditDeleteButton), findsOneWidget);
        expect(find.text(s.shareEditSubmit), findsNothing);
      },
    );

    testWidgets(
      'keeps Update when another member has already paid',
      (tester) async {
        final state = ShareCreateState.initial(
          isEditing: true,
          editingExpenseId: 'expense-1',
          isAmountLocked: true,
          canEdit: true,
        ).copyWith(
          paidByOther: true,
          hasUserEdits: false,
        );

        await tester.pumpWidget(
          buildSubject(state: state, allowDelete: true),
        );
        await tester.pumpAndSettle();

        final s = S.of(tester.element(find.byType(ShareCreateActionBar)));
        expect(find.text(s.shareEditDeleteButton), findsNothing);
        expect(find.text(s.shareEditSubmit), findsOneWidget);
      },
    );
  });
}
