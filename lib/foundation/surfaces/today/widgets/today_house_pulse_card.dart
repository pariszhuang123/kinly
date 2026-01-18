import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:kinly/contracts/mood/enums/house_pulse_state.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/house_pulse_models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/house_pulse_assets.dart';
import 'package:kinly/core/ui/house_pulse_strings.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_section_card.dart';
import 'package:kinly/core/ui/enums/kinly_section_card_visual_position.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';

class TodayHousePulseCard extends StatelessWidget {
  const TodayHousePulseCard({
    super.key,
    required this.pulse,
    required this.palette,
    required this.onTap,
  });

  final HousePulsePayload pulse;
  final SectionColors palette;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;
    final title = resolveHousePulseTitle(s, pulse.label.titleKey);
    final summary = resolveHousePulseSummary(s, pulse.label.summaryKey);
    final updatedLabel = s.housePulseUpdatedOn(
      DateFormat.yMMMd().format(pulse.pulse.computedAt),
    );
    final icon = _iconFor(pulse.pulse.pulseState, pulse.pulse.weatherDisplay);
    final assetPath = resolveHousePulseAssetPath(
      contractVersion: pulse.label.contractVersion,
      imageKey: pulse.label.imageKey,
      pulseState: pulse.pulse.pulseState,
    );

    return KinlySectionCard(
      header: s.housePulseCardHeader,
      palette: palette,
      title: title,
      summary: summary,
      summaryMaxLines: 3,
      onTap: onTap,
      visualPosition: KinlySectionCardVisualPosition.left,
      visual: _PulseGlyph(icon: icon, palette: palette, assetPath: assetPath),
      tags: Wrap(
        spacing: spacing.sm,
        runSpacing: spacing.xs,
        children: [_InfoPill(label: updatedLabel, palette: palette)],
      ),
      trailing: Icon(KinlyIcons.chevronRightRounded, color: palette.icon),
    );
  }
}

class _PulseGlyph extends StatelessWidget {
  const _PulseGlyph({
    required this.icon,
    required this.palette,
    required this.assetPath,
  });

  final IconData icon;
  final SectionColors palette;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing.sm),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            assetPath,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => Icon(icon, color: palette.accent, size: 32),
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.palette});

  final String label;
  final SectionColors palette;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return Container(
      key: const ValueKey('house_pulse_new_badge'),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: palette.card.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

IconData _iconFor(HousePulseState state, MoodScale? weather) {
  switch (state) {
    case HousePulseState.thunderstorm:
      return KinlyIcons.flashOnRounded;
    case HousePulseState.rainySupported:
    case HousePulseState.rainyUnsupported:
      return KinlyIcons.umbrella;
    case HousePulseState.sunnyCalm:
    case HousePulseState.sunnyBumpy:
      return KinlyIcons.wbSunnyRounded;
    case HousePulseState.partlySupported:
      return KinlyIcons.wbCloudyRounded;
    case HousePulseState.cloudySteady:
    case HousePulseState.cloudyTense:
      return KinlyIcons.cloudQueueRounded;
    case HousePulseState.forming:
      return KinlyIcons.autoAwesomeRounded;
  }
}
