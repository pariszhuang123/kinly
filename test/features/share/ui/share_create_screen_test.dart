import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/share/bloc/share_create_bloc/share_create_bloc.dart';
import 'package:kinly/features/share/domain/share_create_form.dart';
import 'package:kinly/features/share/domain/share_split_mode.dart';
import 'package:kinly/features/share/ui/share_create/share_create_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockShareCreateBloc extends MockBloc<ShareCreateEvent, ShareCreateState>
    implements ShareCreateBloc {}

class _FakeShareCreateEvent extends Fake implements ShareCreateEvent {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('en');
    registerFallbackValue(_FakeShareCreateEvent());
  });

  testWidgets(
    'shows detailed snackbar breakdown for splitSumMismatch submission error',
    (tester) async {
      final bloc = _MockShareCreateBloc();
      final form = ShareCreateForm.initial().copyWith(
        amountInput: '10.00',
        splitMode: ShareSplitMode.custom,
        selectedParticipantIds: {'member_a', 'member_b'},
        customAmountInputs: const {'member_a': '4.00', 'member_b': '3.00'},
      );
      final baseState = ShareCreateState.initial().copyWith(
        isLoading: false,
        form: form,
        participants: const [],
      );
      final errorState = baseState.copyWith(
        submissionErrorCode: ExpenseErrorCode.splitSumMismatch,
        submissionErrorTick: 1,
      );

      when(() => bloc.state).thenReturn(baseState);
      whenListen(
        bloc,
        Stream<ShareCreateState>.fromIterable([baseState, errorState]),
        initialState: baseState,
      );

      await tester.pumpWidget(_buildApp(bloc));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Total: \$10.00'), findsOneWidget);
      expect(find.textContaining('Included: \$7.00'), findsOneWidget);
      expect(find.textContaining('Difference: +\$3.00'), findsOneWidget);
    },
  );

  testWidgets(
    'maps splitMembersRequired to creator-only custom split message',
    (tester) async {
      final bloc = _MockShareCreateBloc();
      final form = ShareCreateForm.initial().copyWith(
        amountInput: '10.00',
        splitMode: ShareSplitMode.custom,
        selectedParticipantIds: {'member_self'},
        customAmountInputs: const {'member_self': '10.00'},
      );
      final baseState = ShareCreateState.initial().copyWith(
        isLoading: false,
        currentUserId: 'member_self',
        form: form,
        participants: const [],
      );
      final errorState = baseState.copyWith(
        submissionErrorCode: ExpenseErrorCode.splitMembersRequired,
        submissionErrorTick: 1,
      );

      when(() => bloc.state).thenReturn(baseState);
      whenListen(
        bloc,
        Stream<ShareCreateState>.fromIterable([baseState, errorState]),
        initialState: baseState,
      );

      await tester.pumpWidget(_buildApp(bloc));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final context = tester.element(find.byType(ShareCreateScreen));
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(S.of(context).shareCreateValidationCustomSinglePayer),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'maps splitMembersRequired to creator-only equal split message',
    (tester) async {
      final bloc = _MockShareCreateBloc();
      final form = ShareCreateForm.initial().copyWith(
        amountInput: '10.00',
        splitMode: ShareSplitMode.equal,
        selectedParticipantIds: {'member_self'},
      );
      final baseState = ShareCreateState.initial().copyWith(
        isLoading: false,
        currentUserId: 'member_self',
        form: form,
        participants: const [],
      );
      final errorState = baseState.copyWith(
        submissionErrorCode: ExpenseErrorCode.splitMembersRequired,
        submissionErrorTick: 1,
      );

      when(() => bloc.state).thenReturn(baseState);
      whenListen(
        bloc,
        Stream<ShareCreateState>.fromIterable([baseState, errorState]),
        initialState: baseState,
      );

      await tester.pumpWidget(_buildApp(bloc));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final context = tester.element(find.byType(ShareCreateScreen));
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(S.of(context).shareCreateValidationCustomSinglePayer),
        findsOneWidget,
      );
    },
  );
}

Widget _buildApp(ShareCreateBloc bloc) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: BlocProvider<ShareCreateBloc>.value(
      value: bloc,
      child: const ShareCreateScreen(homeId: 'home-1'),
    ),
  );
}
