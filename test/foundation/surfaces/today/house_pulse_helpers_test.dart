import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/mood/enums/house_pulse_state.dart';
import 'package:kinly/contracts/mood/house_pulse_models.dart';
import 'package:kinly/foundation/surfaces/today/domain/house_pulse_helpers.dart';

void main() {
  group('hasUnseenHousePulse', () {
    final now = DateTime(2026, 1, 15, 12, 0, 0);

    HousePulseSnapshot snapshot({DateTime? computedAt}) {
      return HousePulseSnapshot(
        homeId: 'home-1',
        isoWeekYear: 2026,
        isoWeek: 3,
        contractVersion: 'v1',
        memberCount: 3,
        reflectionCount: 2,
        carePresent: true,
        frictionPresent: false,
        complexityPresent: false,
        pulseState: HousePulseState.sunnyCalm,
        computedAt: computedAt ?? now,
      );
    }

    final label = HousePulseLabel(
      contractVersion: 'v1',
      pulseState: HousePulseState.sunnyCalm,
      titleKey: 'pulse.sunny_calm.title',
      summaryKey: 'pulse.sunny_calm.summary',
      imageKey: 'pulse_sunny_calm',
      ui: const {},
    );

    test('returns true when never seen', () {
      final payload = HousePulsePayload(pulse: snapshot(), label: label, seen: null);
      expect(hasUnseenHousePulse(payload), isTrue);
    });

    test('returns false when seen pulse matches state and computedAt', () {
      final seen = HousePulseRead(
        homeId: 'home-1',
        userId: 'user-1',
        isoWeekYear: 2026,
        isoWeek: 3,
        contractVersion: 'v1',
        lastSeenPulseState: HousePulseState.sunnyCalm,
        lastSeenComputedAt: now,
        seenAt: now.add(const Duration(minutes: 1)),
      );
      final payload = HousePulsePayload(
        pulse: snapshot(computedAt: now),
        label: label,
        seen: seen,
      );
      expect(hasUnseenHousePulse(payload), isFalse);
    });

    test('returns true when pulse updated after seen timestamp', () {
      final seen = HousePulseRead(
        homeId: 'home-1',
        userId: 'user-1',
        isoWeekYear: 2026,
        isoWeek: 3,
        contractVersion: 'v1',
        lastSeenPulseState: HousePulseState.sunnyCalm,
        lastSeenComputedAt: now.subtract(const Duration(minutes: 5)),
        seenAt: now,
      );
      final payload = HousePulsePayload(
        pulse: snapshot(computedAt: now),
        label: label,
        seen: seen,
      );
      expect(hasUnseenHousePulse(payload), isTrue);
    });

    test('returns true when pulse state changes', () {
      final seen = HousePulseRead(
        homeId: 'home-1',
        userId: 'user-1',
        isoWeekYear: 2026,
        isoWeek: 3,
        contractVersion: 'v1',
        lastSeenPulseState: HousePulseState.cloudySteady,
        lastSeenComputedAt: now,
        seenAt: now,
      );
      final payload = HousePulsePayload(
        pulse: snapshot(computedAt: now),
        label: label,
        seen: seen,
      );
      expect(hasUnseenHousePulse(payload), isTrue);
    });
  });
}
