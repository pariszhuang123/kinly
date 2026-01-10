import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/ui/enums/reflective_generation_mode.dart';
import 'package:kinly/core/ui/reflective_generation/reflective_generation_overlay.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/generated/l10n.dart';

Widget _buildOverlayApp({
  required ReflectiveGenerationMode mode,
  required VoidCallback onCompleted,
  Duration ack = const Duration(milliseconds: 900),
  Duration pause = const Duration(milliseconds: 700),
}) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: ReflectiveGenerationOverlay(
      mode: mode,
      onCompleted: onCompleted,
      acknowledgementDuration: ack,
      pauseDuration: pause,
    ),
  );
}

void main() {
  testWidgets('blocks back navigation via PopScope', (tester) async {
    var completed = false;
    await tester.pumpWidget(
      _buildOverlayApp(
        mode: ReflectiveGenerationMode.personalPreferences,
        onCompleted: () => completed = true,
      ),
    );
    await tester.pump();

    final popScope = tester.widget<PopScope>(find.byType(PopScope));
    expect(popScope.canPop, isFalse);
    expect(completed, isFalse);
  });

  testWidgets('shows secondary copy after delay and completes', (tester) async {
    var completed = false;
    await tester.pumpWidget(
      _buildOverlayApp(
        mode: ReflectiveGenerationMode.personalPreferences,
        onCompleted: () => completed = true,
        ack: const Duration(milliseconds: 900),
        pause: const Duration(milliseconds: 700),
      ),
    );

    // Ack phase
    expect(find.text(S.current.reflectiveAcknowledgementTitle), findsOneWidget);
    expect(find.text(S.current.reflectivePersonalSecondary), findsNothing);

    await tester.pump(const Duration(milliseconds: 950));

    // Pause phase with secondary visible
    expect(find.text(S.current.reflectivePersonalPrimary), findsOneWidget);
    expect(find.text(S.current.reflectivePersonalSecondary), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    expect(completed, isTrue);
  });
}
