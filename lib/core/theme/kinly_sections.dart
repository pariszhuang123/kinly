import 'package:flutter/material.dart';

@immutable
class SectionColors {
  final Color background;
  final Color card;
  final Color icon;
  final Color accent;

  const SectionColors({
    required this.background,
    required this.card,
    required this.icon,
    required this.accent,
  });

  SectionColors copyWith({
    Color? background,
    Color? card,
    Color? icon,
    Color? accent,
  }) {
    return SectionColors(
      background: background ?? this.background,
      card: card ?? this.card,
      icon: icon ?? this.icon,
      accent: accent ?? this.accent,
    );
  }

  static SectionColors lerp(SectionColors a, SectionColors b, double t) {
    Color lerp(Color x, Color y) => Color.lerp(x, y, t)!;
    return SectionColors(
      background: lerp(a.background, b.background),
      card: lerp(a.card, b.card),
      icon: lerp(a.icon, b.icon),
      accent: lerp(a.accent, b.accent),
    );
  }
}

@immutable
class KinlySections extends ThemeExtension<KinlySections> {
  final SectionColors flow;
  final SectionColors share;
  final SectionColors pulse;
  final SectionColors hub;
  final SectionColors empty;

  const KinlySections({
    required this.flow,
    required this.share,
    required this.pulse,
    required this.hub,
    required this.empty,
  });

  @override
  KinlySections copyWith({
    SectionColors? flow,
    SectionColors? share,
    SectionColors? pulse,
    SectionColors? hub,
    SectionColors? empty,
  }) {
    return KinlySections(
      flow: flow ?? this.flow,
      share: share ?? this.share,
      pulse: pulse ?? this.pulse,
      hub: hub ?? this.hub,
      empty: empty ?? this.empty,
    );
  }

  @override
  KinlySections lerp(ThemeExtension<KinlySections>? other, double t) {
    if (other is! KinlySections) return this;
    return KinlySections(
      flow: SectionColors.lerp(flow, other.flow, t),
      share: SectionColors.lerp(share, other.share, t),
      pulse: SectionColors.lerp(pulse, other.pulse, t),
      hub: SectionColors.lerp(hub, other.hub, t),
      empty: SectionColors.lerp(empty, other.empty, t),
    );
  }
}
