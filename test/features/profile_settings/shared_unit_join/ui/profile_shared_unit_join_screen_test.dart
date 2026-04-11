import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/profile_settings/shared_unit_join/bloc/profile_shared_unit_join_bloc.dart';
import 'package:kinly/features/profile_settings/shared_unit_join/profile_shared_unit_join_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockProfileSharedUnitJoinBloc
    extends MockBloc<ProfileSharedUnitJoinEvent, ProfileSharedUnitJoinState>
    implements ProfileSharedUnitJoinBloc {}

class _FakeProfileSharedUnitJoinEvent extends Fake
    implements ProfileSharedUnitJoinEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeProfileSharedUnitJoinEvent());
  });

  group('ProfileSharedUnitJoinScreen', () {
    late _MockProfileSharedUnitJoinBloc bloc;

    setUp(() {
      bloc = _MockProfileSharedUnitJoinBloc();
      when(
        () => bloc.stream,
      ).thenAnswer((_) => const Stream<ProfileSharedUnitJoinState>.empty());
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
        home: BlocProvider<ProfileSharedUnitJoinBloc>.value(
          value: bloc,
          child: const ProfileSharedUnitJoinScreen(),
        ),
      );
    }

    testWidgets('renders joinable shared units', (tester) async {
      when(() => bloc.state).thenReturn(
        const ProfileSharedUnitJoinState(
          status: ProfileSharedUnitJoinStatus.ready,
          units: <HomeUnitSummary>[
            HomeUnitSummary(
              unitId: 'unit-shared',
              homeId: 'home-1',
              name: 'Alex + Sam',
              unitType: HomeUnitType.shared,
              memberUserIds: <String>['user-1', 'user-2'],
            ),
          ],
          selectedUnitId: 'unit-shared',
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Join shared unit'), findsNWidgets(2));
      expect(find.text('Alex + Sam'), findsOneWidget);
    });

    testWidgets('renders empty state when no joinable units exist', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const ProfileSharedUnitJoinState(
          status: ProfileSharedUnitJoinStatus.ready,
          units: <HomeUnitSummary>[],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(
        find.text('No joinable shared units are available right now.'),
        findsOneWidget,
      );
    });

    testWidgets('retry dispatches started event from blocking error state', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const ProfileSharedUnitJoinState(
          status: ProfileSharedUnitJoinStatus.failure,
          errorMessage: 'Exception: load failed',
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Try again'));
      await tester.pump();

      verify(() => bloc.add(const ProfileSharedUnitJoinStarted())).called(1);
    });
  });
}
