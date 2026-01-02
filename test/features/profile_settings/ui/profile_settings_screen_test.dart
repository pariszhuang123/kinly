import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/foundation/surfaces/profile/bloc/profile_settings_bloc.dart';
import 'package:kinly/foundation/surfaces/profile/profile_surface.dart';
import 'package:kinly/generated/l10n.dart';

class _MockProfileSettingsBloc
    extends MockBloc<ProfileSettingsEvent, ProfileSettingsState>
    implements ProfileSettingsBloc {}

class _FakeProfileSettingsEvent extends Fake
    implements ProfileSettingsEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeProfileSettingsEvent());
  });

  group('ProfileSettingsScreen', () {
    late _MockProfileSettingsBloc profileSettingsBloc;
    bool didSignOut = false;

    setUp(() {
      profileSettingsBloc = _MockProfileSettingsBloc();
      when(() => profileSettingsBloc.stream).thenAnswer(
        (_) => const Stream<ProfileSettingsState>.empty(),
      );
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
  });
}
