import 'dart:math' as math;

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
  final SectionColors preference;
  final SectionColors empty;

  const KinlySections({
    required this.flow,
    required this.share,
    required this.pulse,
    required this.preference,
    required this.empty,
  });

  @override
  KinlySections copyWith({
    SectionColors? flow,
    SectionColors? share,
    SectionColors? pulse,
    SectionColors? preference,
    SectionColors? empty,
  }) {
    return KinlySections(
      flow: flow ?? this.flow,
      share: share ?? this.share,
      pulse: pulse ?? this.pulse,
      preference: preference ?? this.preference,
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
      preference: SectionColors.lerp(preference, other.preference, t),
      empty: SectionColors.lerp(empty, other.empty, t),
    );
  }
}

extension KinlySectionsAccess on BuildContext {
  KinlySections get sections => Theme.of(this).extension<KinlySections>()!;
  SectionColors get preferenceSection => sections.preference;
}

extension SectionColorsForeground on SectionColors {
  Color onAccent({Color? preferred}) =>
      _pickOnColor(background: accent, preferred: preferred ?? icon);
}

Color _pickOnColor({required Color background, required Color preferred}) {
  final contrast = _contrastRatio(preferred, background);
  if (contrast >= 4.5) return preferred;
  final whiteContrast = _contrastRatio(Colors.white, background);
  final blackContrast = _contrastRatio(Colors.black, background);
  return whiteContrast >= blackContrast ? Colors.white : Colors.black;
}

double _contrastRatio(Color foreground, Color background) {
  final l1 = foreground.computeLuminance();
  final l2 = background.computeLuminance();
  final light = math.max(l1, l2);
  final dark = math.min(l1, l2);
  return (light + 0.05) / (dark + 0.05);
}
