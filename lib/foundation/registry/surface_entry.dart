import 'package:flutter/widgets.dart';

enum SurfaceTier { critical, standard, experimental }

class SurfaceEntry<TScope> {
  const SurfaceEntry({
    required this.slotIndex,
    required this.featureId,
    required this.contributionId,
    required this.builder,
    this.isEnabled,
    this.tier = SurfaceTier.standard,
    this.order = 500,
  });

  final int slotIndex;
  final SurfaceTier tier;
  final int order;
  final String featureId;
  final String contributionId;
  final Widget Function(TScope scope) builder;
  final bool Function(TScope scope)? isEnabled;
}

int compareSurfaceEntries<TScope>(
  SurfaceEntry<TScope> a,
  SurfaceEntry<TScope> b,
) {
  final slotCompare = a.slotIndex.compareTo(b.slotIndex);
  if (slotCompare != 0) return slotCompare;

  final tierCompare = _tierRank(a.tier).compareTo(_tierRank(b.tier));
  if (tierCompare != 0) return tierCompare;

  final orderCompare = a.order.compareTo(b.order);
  if (orderCompare != 0) return orderCompare;

  final featureCompare = a.featureId.compareTo(b.featureId);
  if (featureCompare != 0) return featureCompare;

  return a.contributionId.compareTo(b.contributionId);
}

int _tierRank(SurfaceTier tier) {
  switch (tier) {
    case SurfaceTier.critical:
      return 0;
    case SurfaceTier.standard:
      return 1;
    case SurfaceTier.experimental:
      return 2;
  }
}

