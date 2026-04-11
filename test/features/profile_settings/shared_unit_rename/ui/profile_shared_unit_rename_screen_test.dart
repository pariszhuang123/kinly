import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/profile_settings/shared_unit_rename/bloc/profile_shared_unit_rename_bloc.dart';
import 'package:kinly/features/profile_settings/shared_unit_rename/profile_shared_unit_rename_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockProfileSharedUnitRenameBloc
    extends MockBloc<ProfileSharedUnitRenameEvent, ProfileSharedUnitRenameState>
    implements ProfileSharedUnitRenameBloc {}

class _FakeProfileSharedUnitRenameEvent extends Fake
    implements ProfileSharedUnitRenameEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeProfileSharedUnitRenameEvent());
  });

  group('ProfileSharedUnitRenameScreen', () {
    late _MockProfileSharedUnitRenameBloc bloc;

    setUp(() {
      bloc = _MockProfileSharedUnitRenameBloc();
      when(
        () => bloc.stream,
      ).thenAnswer((_) => const Stream<ProfileSharedUnitRenameState>.empty());
    });

    Widget buildApp() {
      return MaterialApp(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider<ProfileSharedUnitRenameBloc>.value(
          value: bloc,
          child: const ProfileSharedUnitRenameScreen(),
        ),
      );
    }

    testWidgets('renders current shared unit name', (tester) async {
      when(() => bloc.state).thenReturn(
        const ProfileSharedUnitRenameState(name: 'Alex + Sam'),
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Rename shared unit'), findsOneWidget);
      expect(find.text('Alex + Sam'), findsOneWidget);
    });

    testWidgets('does not submit whitespace-only names', (tester) async {
      when(() => bloc.state).thenReturn(
        const ProfileSharedUnitRenameState(name: '   '),
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save name'));
      await tester.pump();

      verifyNever(() => bloc.add(const ProfileSharedUnitRenameSubmitted()));
    });
  });
}
