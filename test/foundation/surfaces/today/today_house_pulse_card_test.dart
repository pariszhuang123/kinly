import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/mood/enums/house_pulse_state.dart';
import 'package:kinly/contracts/mood/house_pulse_models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_house_pulse_card.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  HousePulsePayload buildPayload({required bool seenUpToDate}) {
    final computedAt = DateTime(2026, 1, 15, 12, 0, 0);
    final pulse = HousePulseSnapshot(
      homeId: 'home-1',
      isoWeekYear: 2026,
      isoWeek: 3,
      contractVersion: 'v1',
      memberCount: 4,
      reflectionCount: 3,
      carePresent: true,
      frictionPresent: false,
      complexityPresent: false,
      pulseState: HousePulseState.sunnyCalm,
      computedAt: computedAt,
    );
    final label = HousePulseLabel(
      contractVersion: 'v1',
      pulseState: HousePulseState.sunnyCalm,
      titleKey: 'pulse.sunny_calm.title',
      summaryKey: 'pulse.sunny_calm.summary',
      imageKey: 'pulse_sunny_calm',
      ui: const {},
    );
    final seen =
        seenUpToDate
            ? HousePulseRead(
              homeId: 'home-1',
              userId: 'user-1',
              isoWeekYear: 2026,
              isoWeek: 3,
              contractVersion: 'v1',
              lastSeenPulseState: HousePulseState.sunnyCalm,
              lastSeenComputedAt: computedAt,
              seenAt: computedAt.add(const Duration(minutes: 1)),
            )
            : null;
    return HousePulsePayload(pulse: pulse, label: label, seen: seen);
  }

  testWidgets('shows badge and fires tap for unseen pulse', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) {
            final sections = Theme.of(context).extension<KinlySections>()!;
            return TodayHousePulseCard(
              pulse: buildPayload(seenUpToDate: false),
              palette: sections.pulse,
              onTap: () async => tapped = true,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(S.current.housePulseCardHeader), findsOneWidget);
    expect(find.byKey(const ValueKey('house_pulse_new_badge')), findsOneWidget);

    await tester.tap(find.byType(TodayHousePulseCard));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets('hides badge when pulse already seen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) {
            final sections = Theme.of(context).extension<KinlySections>()!;
            return TodayHousePulseCard(
              pulse: buildPayload(seenUpToDate: true),
              palette: sections.pulse,
              onTap: () async {},
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
  });
}
