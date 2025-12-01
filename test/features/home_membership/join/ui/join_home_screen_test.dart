import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/di/locator.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/home_membership/join/ui/join_home_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/theme/kinly_theme.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

class _FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthEvent());
    registerFallbackValue(_FakeAuthState());
  });

  late _MockHomeRepository homeRepository;
  late _MockAuthBloc authBloc;

  setUp(() async {
    await sl.reset();
    homeRepository = _MockHomeRepository();
    sl.registerLazySingleton<HomeRepository>(() => homeRepository);
    authBloc = _MockAuthBloc();
    when(
      () => authBloc.stream,
    ).thenAnswer((_) => const Stream<AuthState>.empty());
    when(() => authBloc.state).thenReturn(const AuthState());
  });

  tearDown(() async {
    await sl.reset();
  });

  Widget buildApp(Widget child) {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider<AuthBloc>.value(value: authBloc, child: child),
    );
  }

  testWidgets('submit button enables only after entering a code', (
    tester,
  ) async {
    when(() => homeRepository.join(any())).thenAnswer((_) async {});

    await tester.pumpWidget(buildApp(const JoinHomeScreen()));

    var button = tester.widget<KinlyFilledButton>(
      find.byType(KinlyFilledButton),
    );
    expect(button.onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'ABC123');
    await tester.pump();

    button = tester.widget<KinlyFilledButton>(find.byType(KinlyFilledButton));
    expect(button.onPressed, isNotNull);
  });
}
