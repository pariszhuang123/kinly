import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/harmony/ui/gratitude_wall/gratitude_wall_screen.dart';
import 'package:kinly/features/harmony/bloc/gratitude_wall_cubit.dart';
import 'package:kinly/features/harmony/bloc/personal_gratitude_cubit.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/opacity.dart';

class _MockGratitudeWallCubit extends Mock implements GratitudeWallCubit {}

class _MockPersonalGratitudeCubit extends Mock
    implements PersonalGratitudeCubit {}

const _testSpacing = Spacing(
  xxs: 2,
  xs: 4,
  s: 8,
  m: 12,
  l: 16,
  xl: 24,
  xxl: 32,
  xxxl: 40,
);
const _testOpacity = KinlyOpacity.defaults;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('personal tab triggers personal share logging', (tester) async {
    final houseCubit = _MockGratitudeWallCubit();
    final personalCubit = _MockPersonalGratitudeCubit();
    when(() => houseCubit.state).thenReturn(const GratitudeWallState.initial());
    when(
      () => personalCubit.state,
    ).thenReturn(const PersonalGratitudeState.initial());
    when(
      () => houseCubit.stream,
    ).thenAnswer((_) => const Stream<GratitudeWallState>.empty());
    when(
      () => personalCubit.stream,
    ).thenAnswer((_) => const Stream<PersonalGratitudeState>.empty());

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true).copyWith(
          extensions: const <ThemeExtension<dynamic>>[
            _testSpacing,
            _testOpacity,
          ],
        ),
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<GratitudeWallCubit>.value(value: houseCubit),
            BlocProvider<PersonalGratitudeCubit>.value(value: personalCubit),
          ],
          child: const GratitudeWallScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Switch to personal tab
    final context = tester.element(find.byType(GratitudeWallScreen));
    final strings = S.of(context);

    await tester.tap(find.text(strings.gratitudeWallPersonalTab));
    await tester.pump();

    await tester.tap(find.byTooltip(strings.gratitudeWallShareCta));
    await tester.pump();

    verify(() => personalCubit.logShareEvent()).called(1);
    verifyNever(() => houseCubit.logShareEvent());
  });

  testWidgets('opens personal tab when initialTab is personal', (tester) async {
    final houseCubit = _MockGratitudeWallCubit();
    final personalCubit = _MockPersonalGratitudeCubit();
    when(() => houseCubit.state).thenReturn(const GratitudeWallState.initial());
    when(
      () => personalCubit.state,
    ).thenReturn(const PersonalGratitudeState.initial());
    when(
      () => houseCubit.stream,
    ).thenAnswer((_) => const Stream<GratitudeWallState>.empty());
    when(
      () => personalCubit.stream,
    ).thenAnswer((_) => const Stream<PersonalGratitudeState>.empty());

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true).copyWith(
          extensions: const <ThemeExtension<dynamic>>[
            _testSpacing,
            _testOpacity,
          ],
        ),
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<GratitudeWallCubit>.value(value: houseCubit),
            BlocProvider<PersonalGratitudeCubit>.value(value: personalCubit),
          ],
          child: const GratitudeWallScreen(
            initialTab: GratitudeTab.personal,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final context = tester.element(find.byType(GratitudeWallScreen));
    final strings = S.of(context);
    expect(
      find.text(strings.gratitudeWallPersonalTab),
      findsOneWidget,
    );
  });
}
