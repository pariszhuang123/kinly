import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/profile_settings/shared_unit_create/bloc/profile_shared_unit_create_bloc.dart';
import 'package:kinly/features/profile_settings/shared_unit_create/profile_shared_unit_create_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockProfileSharedUnitCreateBloc
    extends
        MockBloc<
          ProfileSharedUnitCreateEvent,
          ProfileSharedUnitCreateState
        >
    implements ProfileSharedUnitCreateBloc {}

class _FakeProfileSharedUnitCreateEvent extends Fake
    implements ProfileSharedUnitCreateEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeProfileSharedUnitCreateEvent());
  });

  group('ProfileSharedUnitCreateScreen', () {
    late _MockProfileSharedUnitCreateBloc bloc;

    setUp(() {
      bloc = _MockProfileSharedUnitCreateBloc();
      when(
        () => bloc.stream,
      ).thenAnswer((_) => const Stream<ProfileSharedUnitCreateState>.empty());
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
        home: BlocProvider<ProfileSharedUnitCreateBloc>.value(
          value: bloc,
          child: const ProfileSharedUnitCreateScreen(),
        ),
      );
    }

    testWidgets('renders eligible candidates', (tester) async {
      when(() => bloc.state).thenReturn(
        const ProfileSharedUnitCreateState(
          status: ProfileSharedUnitCreateStatus.ready,
          candidates: <HomeUnitMemberCandidate>[
            HomeUnitMemberCandidate(
              membershipId: 'membership-2',
              userId: 'user-2',
              displayName: 'Sam',
            ),
          ],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Create shared unit'), findsNWidgets(2));
      expect(find.text('Sam'), findsOneWidget);
    });
  });
}
