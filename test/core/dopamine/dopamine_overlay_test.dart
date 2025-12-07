import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/dopamine/dopamine_models.dart';
import 'package:kinly/core/dopamine/dopamine_overlay.dart';
import 'package:kinly/core/dopamine/enums/dopamine_milestone.dart';
import 'package:kinly/core/dopamine/enums/dopamine_strength.dart';
import 'package:kinly/core/time/clock.dart';
import '../../support/fake_telemetry.dart';

void main() {
  testWidgets('shows dopamine when off cooldown', (tester) async {
    final clock = _FakeClock(DateTime(2024, 1, 1, 12));
    final hostKey = GlobalKey<DopamineOverlayHostState>();

    await tester.pumpWidget(
      MaterialApp(
        home: DopamineOverlayHost(
          key: hostKey,
          clock: clock,
          child: const SizedBox(),
        ),
      ),
    );

    await hostKey.currentState!.show(
      const DopamineMoment(
        milestone: DopamineMilestone.flow,
        strength: DopamineStrength.medium,
        affirmation: 'thanks',
        reduceMotion: true,
        hapticEnabled: false,
      ),
      anchorRect: const Rect.fromLTWH(100, 100, 48, 48),
    );

    await tester.pump();
    expect(find.byIcon(Icons.auto_awesome), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1000));
    expect(find.byIcon(Icons.auto_awesome), findsNothing);
  });

  testWidgets('drops dopamine during cooldown window', (tester) async {
    final clock = _FakeClock(DateTime(2024, 1, 1, 12));
    final hostKey = GlobalKey<DopamineOverlayHostState>();

    await tester.pumpWidget(
      MaterialApp(
        home: DopamineOverlayHost(
          key: hostKey,
          clock: clock,
          child: const SizedBox(),
        ),
      ),
    );

    await hostKey.currentState!.show(
      const DopamineMoment(
        milestone: DopamineMilestone.flow,
        strength: DopamineStrength.medium,
        affirmation: 'first',
        reduceMotion: true,
        hapticEnabled: false,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1000)); // dismiss
    expect(find.byIcon(Icons.auto_awesome), findsNothing);

    clock.advance(const Duration(seconds: 2)); // inside 3s cooldown
    await hostKey.currentState!.show(
      const DopamineMoment(
        milestone: DopamineMilestone.pulse,
        strength: DopamineStrength.medium,
        affirmation: 'second',
        reduceMotion: true,
        hapticEnabled: false,
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.favorite_rounded), findsNothing);
  });

  testWidgets('replaces active dopamine within coalesce window', (tester) async {
    final clock = _FakeClock(DateTime(2024, 1, 1, 12));
    final hostKey = GlobalKey<DopamineOverlayHostState>();

    await tester.pumpWidget(
      MaterialApp(
        home: DopamineOverlayHost(
          key: hostKey,
          clock: clock,
          child: const SizedBox(),
        ),
      ),
    );

    await hostKey.currentState!.show(
      const DopamineMoment(
        milestone: DopamineMilestone.flow,
        strength: DopamineStrength.medium,
        affirmation: 'first',
        reduceMotion: true,
        hapticEnabled: false,
      ),
    );
    await tester.pump();
    expect(find.byIcon(Icons.auto_awesome), findsOneWidget);

    clock.advance(const Duration(milliseconds: 500)); // within coalesce window
    await hostKey.currentState!.show(
      const DopamineMoment(
        milestone: DopamineMilestone.share,
        strength: DopamineStrength.medium,
        affirmation: 'second',
        reduceMotion: true,
        hapticEnabled: false,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byIcon(Icons.auto_awesome), findsNothing);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('emits telemetry once with expected props', (tester) async {
    final telemetry = FakeTelemetry();
    final clock = _FakeClock(DateTime(2024, 1, 1, 12));
    final hostKey = GlobalKey<DopamineOverlayHostState>();

    await tester.pumpWidget(
      MaterialApp(
        home: DopamineOverlayHost(
          key: hostKey,
          clock: clock,
          telemetry: telemetry,
          child: const SizedBox(),
        ),
      ),
    );

    await hostKey.currentState!.show(
      const DopamineMoment(
        milestone: DopamineMilestone.pulse,
        strength: DopamineStrength.high,
        affirmation: 'cheer',
        echo: 'echo',
        reduceMotion: false,
        hapticEnabled: false,
      ),
    );

    expect(telemetry.events.length, 1);
    final event = telemetry.events.single;
    expect(event.name, 'dopamine_shown');
    expect(event.properties['milestone'], 'pulse');
    expect(event.properties['strength'], 'high');
    expect(event.properties['echo_present'], true);
    expect(event.properties['reduce_motion'], false);
    expect(event.properties['haptic_used'], false);
    expect(event.properties['theme'], 'light');
  });
}

class _FakeClock implements Clock {
  _FakeClock(this._now);

  DateTime _now;

  @override
  DateTime now() => _now;

  void advance(Duration delta) {
    _now = _now.add(delta);
  }
}
