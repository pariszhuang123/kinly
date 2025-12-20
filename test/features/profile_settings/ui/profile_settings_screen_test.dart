import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/profile_settings/bloc/profile_settings_bloc.dart';
import 'package:kinly/features/profile_settings/ui/profile_settings_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockProfileSettingsBloc
    extends MockBloc<ProfileSettingsEvent, ProfileSettingsState>
    implements ProfileSettingsBloc {}

class _FakeProfileSettingsEvent extends Fake
    implements ProfileSettingsEvent {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeProfileSettingsEvent());
    registerFallbackValue(_FakeAuthEvent());
  });

  group('ProfileSettingsScreen', () {
    late _MockProfileSettingsBloc profileSettingsBloc;
    late _MockAuthBloc authBloc;

    setUp(() {
      profileSettingsBloc = _MockProfileSettingsBloc();
      authBloc = _MockAuthBloc();

      when(() => profileSettingsBloc.stream).thenAnswer(
        (_) => const Stream<ProfileSettingsState>.empty(),
      );
      when(() => authBloc.stream).thenAnswer(
        (_) => const Stream<AuthState>.empty(),
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
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<ProfileSettingsBloc>.value(
              value: profileSettingsBloc,
            ),
          ],
          child: const ProfileSettingsScreen(),
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
      when(() => authBloc.state).thenReturn(const AuthState());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pump();

      verify(() => authBloc.add(const AuthSignOutRequested())).called(1);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
