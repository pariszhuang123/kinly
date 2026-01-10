import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/foundation/registry/surface_entry.dart';

SurfaceEntry<void> _entry({
  required int slotIndex,
  required String featureId,
  required String contributionId,
  SurfaceTier tier = SurfaceTier.standard,
  int order = 500,
}) {
  return SurfaceEntry<void>(
    slotIndex: slotIndex,
    featureId: featureId,
    contributionId: contributionId,
    tier: tier,
    order: order,
    builder: (_) => const SizedBox.shrink(),
  );
}

void main() {
  test('compareSurfaceEntries is deterministic', () {
    final entries = [
      _entry(slotIndex: 1, featureId: 'flow', contributionId: 'b', order: 200),
      _entry(
        slotIndex: 0,
        featureId: 'share',
        contributionId: 'a',
        tier: SurfaceTier.critical,
      ),
      _entry(slotIndex: 0, featureId: 'flow', contributionId: 'c', order: 600),
    ];

    entries.sort(compareSurfaceEntries);

    expect(entries.map((e) => e.contributionId).toList(), ['a', 'c', 'b']);
  });

  test('compareSurfaceEntries uses contributionId as final tie-breaker', () {
    final first = _entry(slotIndex: 0, featureId: 'flow', contributionId: 'a');
    final second = _entry(slotIndex: 0, featureId: 'flow', contributionId: 'b');

    final entries = [second, first]..sort(compareSurfaceEntries);

    expect(entries.first.contributionId, 'a');
    expect(entries.last.contributionId, 'b');
  });

  test('compareSurfaceEntries prioritizes slotIndex', () {
    final entries = [
      _entry(slotIndex: 2, featureId: 'flow', contributionId: 'c'),
      _entry(slotIndex: 1, featureId: 'flow', contributionId: 'b'),
      _entry(slotIndex: 0, featureId: 'flow', contributionId: 'a'),
    ];

    entries.sort(compareSurfaceEntries);

    expect(entries.map((e) => e.slotIndex).toList(), [0, 1, 2]);
  });
}
