import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/home_membership/start/bloc/start_home_bloc.dart';
import 'package:kinly/features/home_membership/start/ui/start_home_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/theme/spacing.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _FakeHomeRepository implements HomeRepository {
  @override
  Future<HomeCreationResult> create() async =>
      const HomeCreationResult(homeId: 'home-1');

  @override
  Future<void> join(String code) {
    throw UnimplementedError();
  }

  @override
  Future<void> revokeInvite(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<String> rotateInvite(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<HomeInvite> getActiveInvite(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<HomeInvite> getOrCreateInvite(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<void> transferOwner(String homeId, String newOwnerId) {
    throw UnimplementedError();
  }

  @override
  Future<LeaveResult> leave(String homeId) {
    throw UnimplementedError();
  }

  @override
  Future<void> kickMember(String homeId, String userId) {
    throw UnimplementedError();
  }

  @override
  Future<List<HomeMemberSummary>> listActiveMembers(
    String homeId, {
    bool excludeSelf = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<CurrentMembership?> getCurrentMembership() {
    throw UnimplementedError();
  }

  @override
  Future<void> logShareEvent({
    required String feature,
    required String channel,
    String? homeId,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  late _MockAuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(const AuthProfileDeactivatedDetected());
    registerFallbackValue(const StartHomeCreateRequested());
  });

  setUp(() {
    authBloc = _MockAuthBloc();
    final authState = const AuthState(
      status: AuthStatus.authenticated,
      membershipStatus: AuthMembershipStatus.none,
      isProfileDeactivated: true,
    );
    when(() => authBloc.state).thenReturn(authState);
    whenListen<AuthState>(
      authBloc,
      Stream<AuthState>.value(authState),
      initialState: authState,
    );
  });

  Widget app(Widget child, StartHomeBloc startHomeBloc) {
    final theme = ThemeData(
      useMaterial3: true,
      extensions: const [
        Spacing(
          xxs: 2,
          xs: 4,
          s: 8,
          m: 12,
          l: 16,
          xl: 24,
          xxl: 32,
          xxxl: 40,
        ),
      ],
    );

    return MaterialApp(
      theme: theme,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<StartHomeBloc>.value(value: startHomeBloc),
        ],
        child: child,
      ),
    );
  }

  testWidgets(
    'disables create/join buttons when profile is deactivated',
    (tester) async {
      final startBloc = StartHomeBloc(
        _FakeHomeRepository(),
        onProfileDeactivated: () {},
      );

      await tester.pumpWidget(app(const StartHomeScreen(), startBloc));
      await tester.pumpAndSettle();

      final buttons = tester.widgetList<KinlyFilledButton>(
        find.byType(KinlyFilledButton),
      );
      expect(buttons, hasLength(2));
      for (final btn in buttons) {
        expect(btn.onPressed, isNull);
      }
    },
  );
}
