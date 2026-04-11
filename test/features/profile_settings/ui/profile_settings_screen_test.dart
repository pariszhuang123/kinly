import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/foundation/surfaces/profile/bloc/profile_settings_bloc.dart';
import 'package:kinly/foundation/surfaces/profile/profile_surface.dart';
import 'package:kinly/generated/l10n.dart';

class _MockProfileSettingsBloc
    extends MockBloc<ProfileSettingsEvent, ProfileSettingsState>
    implements ProfileSettingsBloc {}

class _FakeProfileSettingsEvent extends Fake implements ProfileSettingsEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeProfileSettingsEvent());
  });

  group('ProfileSettingsScreen', () {
    late _MockProfileSettingsBloc profileSettingsBloc;
    bool didSignOut = false;

    setUp(() {
      profileSettingsBloc = _MockProfileSettingsBloc();
      when(
        () => profileSettingsBloc.stream,
      ).thenAnswer((_) => const Stream<ProfileSettingsState>.empty());
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
        home: BlocProvider<ProfileSettingsBloc>.value(
          value: profileSettingsBloc,
          child: ProfileSettingsScreen(
            onMembershipRefresh: () {},
            onSignOut: () {
              didSignOut = true;
            },
          ),
        ),
      );
    }

    testWidgets('tapping logout dispatches sign out with no dialog', (
      tester,
    ) async {
      when(() => profileSettingsBloc.state).thenReturn(
        ProfileSettingsState.initial(
          user: const ProfileSettingsUser(displayName: 'Alex'),
        ),
      );
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pump();

      expect(didSignOut, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('shows create shared unit CTA when eligible', (tester) async {
      when(() => profileSettingsBloc.state).thenReturn(
        ProfileSettingsState.initial(
          user: const ProfileSettingsUser(displayName: 'Alex'),
        ).copyWith(
          membership: CurrentMembership(
            membershipId: 'membership-1',
            userId: 'user-1',
            homeId: 'home-1',
            role: 'member',
            validFrom: DateTime(2024, 1, 1),
          ),
          homeUnitContext: HomeUnitContext(
            personalUnit: const HomeUnitSummary(
              unitId: 'unit-1',
              homeId: 'home-1',
              name: 'Personal',
              unitType: HomeUnitType.personal,
              memberUserIds: <String>['user-1'],
            ),
            activeSharedUnit: null,
            allowedShoppingScopes: const <ShoppingItemScopeType>[],
          ),
          sharedUnitCreateCandidates: const <HomeUnitMemberCandidate>[
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

      expect(find.text('Create shared unit'), findsOneWidget);
    });

    testWidgets('shows join CTA when joinable units exist', (tester) async {
      when(() => profileSettingsBloc.state).thenReturn(
        ProfileSettingsState.initial(
          user: const ProfileSettingsUser(displayName: 'Alex'),
        ).copyWith(
          homeUnitContext: HomeUnitContext(
            personalUnit: const HomeUnitSummary(
              unitId: 'unit-1',
              homeId: 'home-1',
              name: 'Personal',
              unitType: HomeUnitType.personal,
              memberUserIds: <String>['user-1'],
            ),
            activeSharedUnit: null,
            allowedShoppingScopes: const <ShoppingItemScopeType>[],
          ),
          joinableSharedUnits: const <HomeUnitSummary>[
            HomeUnitSummary(
              unitId: 'unit-shared',
              homeId: 'home-1',
              name: 'Alex + Sam',
              unitType: HomeUnitType.shared,
              memberUserIds: <String>['user-2', 'user-3'],
            ),
          ],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Join existing shared unit'), findsOneWidget);
      expect(find.text('Create shared unit'), findsNothing);
    });

    testWidgets('hides shared unit section when no actions are available', (
      tester,
    ) async {
      when(() => profileSettingsBloc.state).thenReturn(
        ProfileSettingsState.initial(
          user: const ProfileSettingsUser(displayName: 'Alex'),
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Shared unit'), findsNothing);
      expect(find.text('Create shared unit'), findsNothing);
      expect(find.text('Join existing shared unit'), findsNothing);
    });

    testWidgets('shows shared unit actions when active', (tester) async {
      when(() => profileSettingsBloc.state).thenReturn(
        ProfileSettingsState.initial(
          user: const ProfileSettingsUser(displayName: 'Alex'),
        ).copyWith(
          homeUnitContext: HomeUnitContext(
            personalUnit: const HomeUnitSummary(
              unitId: 'unit-1',
              homeId: 'home-1',
              name: 'Personal',
              unitType: HomeUnitType.personal,
              memberUserIds: <String>['user-1'],
            ),
            activeSharedUnit: const HomeUnitSummary(
              unitId: 'unit-shared',
              homeId: 'home-1',
              name: 'Alex + Sam',
              unitType: HomeUnitType.shared,
              memberUserIds: <String>['user-1', 'user-2'],
            ),
            allowedShoppingScopes: const <ShoppingItemScopeType>[],
          ),
          activeMembers: [
            HomeMemberSummary(
              userId: 'user-1',
              username: 'Alex',
              role: 'member',
              validFrom: DateTime(2024, 1, 1),
            ),
            HomeMemberSummary(
              userId: 'user-2',
              username: 'Sam',
              role: 'member',
              validFrom: DateTime(2024, 1, 1),
            ),
          ],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Rename shared unit'), findsOneWidget);
      expect(find.text('Leave shared unit'), findsOneWidget);
      expect(find.text('Sam'), findsOneWidget);
    });
  });
}
