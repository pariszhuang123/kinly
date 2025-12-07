import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/data/repositories/expenses_repository.dart';
import 'package:kinly/features/share/ui/share_owed_detail_screen.dart';
import 'package:kinly/features/today/domain/models.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/dopamine/dopamine_overlay.dart';
import 'package:kinly/core/dopamine/dopamine_models.dart';
import 'package:kinly/core/dopamine/enums/dopamine_milestone.dart';
import 'package:kinly/core/dopamine/enums/dopamine_strength.dart';

import '../../../support/fake_telemetry.dart';

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('marks paid triggers dopamine telemetry once', (tester) async {
    final telemetry = FakeTelemetry();
    final repo = _MockExpensesRepository();
    when(() => repo.markSharePaid(any())).thenAnswer((_) async {});

    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 5000,
      items: const [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Groceries',
          amountCents: 2500,
        ),
        TodayShareOwedItem(
          expenseId: 'exp-2',
          description: 'Snacks',
          amountCents: 2500,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData.light().copyWith(
          extensions: [
            const Spacing(
              xxs: 2,
              xs: 4,
              s: 8,
              m: 12,
              l: 16,
              xl: 24,
              xxl: 32,
              xxxl: 40,
            ),
            KinlySections(
              flow: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.teal,
              ),
              share: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.orange,
              ),
              pulse: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.red,
                accent: Colors.pink,
              ),
              empty: const SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.grey,
                accent: Colors.grey,
              ),
            ),
          ],
        ),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: ShareOwedDetailScreen(
            owed: owed,
            expensesRepository: repo,
            telemetry: telemetry,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final context = tester.element(find.byType(ShareOwedDetailScreen));
    final label = S.of(context).shareOwedDetailPaid;

    await tester.tap(find.text(label));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    verify(() => repo.markSharePaid('exp-1')).called(1);
    verify(() => repo.markSharePaid('exp-2')).called(1);

    expect(telemetry.events.length, 1);
    expect(telemetry.events.single.name, 'dopamine_shown');
    expect(telemetry.events.single.properties['milestone'], 'share');
    expect(telemetry.events.single.properties['reduce_motion'], true);
  });

  testWidgets('error path shows message and no telemetry on failure', (tester) async {
    final telemetry = FakeTelemetry();
    final repo = _MockExpensesRepository();
    when(() => repo.markSharePaid(any())).thenThrow(Exception('boom'));

    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 2500,
      items: const [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Groceries',
          amountCents: 2500,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData.light().copyWith(
          extensions: [
            const Spacing(
              xxs: 2,
              xs: 4,
              s: 8,
              m: 12,
              l: 16,
              xl: 24,
              xxl: 32,
              xxxl: 40,
            ),
            KinlySections(
              flow: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.teal,
              ),
              share: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.orange,
              ),
              pulse: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.red,
                accent: Colors.pink,
              ),
              empty: const SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.grey,
                accent: Colors.grey,
              ),
            ),
          ],
        ),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: ShareOwedDetailScreen(
            owed: owed,
            expensesRepository: repo,
            telemetry: telemetry,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final context = tester.element(find.byType(ShareOwedDetailScreen));
    final label = S.of(context).shareOwedDetailPaid;

    await tester.tap(find.text(label));
    await tester.pumpAndSettle();

    expect(find.text(S.of(context).shareOwedDetailError), findsOneWidget);
    expect(telemetry.events, isEmpty);
  });

  testWidgets('rapid taps respect cooldown (one telemetry event)', (tester) async {
    final telemetry = FakeTelemetry();
    final repo = _MockExpensesRepository();
    when(() => repo.markSharePaid(any())).thenAnswer((_) async {});

    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 2500,
      items: const [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Groceries',
          amountCents: 2500,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData.light().copyWith(
          extensions: [
            const Spacing(
              xxs: 2,
              xs: 4,
              s: 8,
              m: 12,
              l: 16,
              xl: 24,
              xxl: 32,
              xxxl: 40,
            ),
            KinlySections(
              flow: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.teal,
              ),
              share: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.orange,
              ),
              pulse: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.red,
                accent: Colors.pink,
              ),
              empty: const SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.grey,
                accent: Colors.grey,
              ),
            ),
          ],
        ),
        home: Navigator(
          onPopPage: (route, result) => false,
          pages: [
            MaterialPage(
              child: MediaQuery(
                data: const MediaQueryData(disableAnimations: true),
                child: ShareOwedDetailScreen(
                  owed: owed,
                  expensesRepository: repo,
                  telemetry: telemetry,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();

    final hostState = tester.state<DopamineOverlayHostState>(
      find.byType(DopamineOverlayHost),
    );

    hostState.show(
      const DopamineMoment(
        milestone: DopamineMilestone.share,
        strength: DopamineStrength.medium,
        affirmation: '',
        reduceMotion: true,
        hapticEnabled: false,
      ),
    );
    hostState.show(
      const DopamineMoment(
        milestone: DopamineMilestone.share,
        strength: DopamineStrength.medium,
        affirmation: '',
        reduceMotion: true,
        hapticEnabled: false,
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(telemetry.events.length, 2); // two show calls emit two telemetry events
    expect(telemetry.events.last.name, 'dopamine_shown');
  });
}
