import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:kinly/contracts/mood/enums/house_pulse_state.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/house_pulse_models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/house_pulse_assets.dart';
import 'package:kinly/core/ui/house_pulse_strings.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/share/kinly_story_share_scaffold.dart';
import 'package:kinly/foundation/surfaces/today/bloc/today_bloc.dart';
import 'package:kinly/renderer/material/share/kinly_share_card.dart';

class TodayHousePulseDetailScreen extends StatelessWidget {
  const TodayHousePulseDetailScreen({super.key, required this.pulse});

  final HousePulsePayload pulse;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);
    final title = resolveHousePulseTitle(s, pulse.label.titleKey);
    final summary = resolveHousePulseSummary(s, pulse.label.summaryKey);
    final updatedLabel = s.housePulseUpdatedOn(
      DateFormat.yMMMd().format(pulse.pulse.computedAt),
    );
    final reflectionsLabel = s.housePulseReflections(
      pulse.pulse.reflectionCount,
    );
    final icon = _iconFor(pulse.pulse.pulseState, pulse.pulse.weatherDisplay);
    final assetPath = resolveHousePulseAssetPath(
      contractVersion: pulse.label.contractVersion,
      imageKey: pulse.label.imageKey,
      pulseState: pulse.pulse.pulseState,
    );

    return KinlyStoryShareScaffold(
      fileNamePrefix: 'house_pulse',
      logTag: 'house_pulse',
      appBarTitle: null, // As requested
      fabTooltip: s.housePulseShareCta,
      subjectBuilder: (ctx) => s.housePulseShareTitle,
      messageBuilder: (ctx, appLink) => s.housePulseShareMessage(appLink),
      onSharePressed: () async {
        context.read<TodayBloc>().add(
          const TodayHousePulseShareLogged(channel: 'system_share'),
        );
      },
      child: HousePulseShareCard(
        pulse: pulse,
        palette: sections.pulse,
        title: title,
        summary: summary,
        updatedLabel: updatedLabel,
        reflectionsLabel: reflectionsLabel,
        icon: icon,
        assetPath: assetPath,
      ),
    );
  }
}

class HousePulseShareCard extends StatelessWidget {
  const HousePulseShareCard({
    super.key,
    required this.pulse,
    required this.palette,
    required this.title,
    required this.summary,
    required this.updatedLabel,
    required this.reflectionsLabel,
    required this.icon,
    required this.assetPath,
  });

  final HousePulsePayload pulse;
  final SectionColors palette;
  final String title;
  final String summary;
  final String updatedLabel;
  final String reflectionsLabel;
  final IconData icon;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;

    return KinlyShareCard(
      header: S.of(context).housePulseCardHeader,
      title: title,
      summary: summary,
      palette: palette,
      useGradientBackground: true,
      visualContent: _ShareGlyph(
        icon: icon,
        palette: palette,
        assetPath: assetPath,
      ),
      footerContent: Wrap(
        alignment: WrapAlignment.center,
        spacing: spacing.md,
        runSpacing: spacing.xs,
        children: [_SharePill(label: updatedLabel, palette: palette)],
      ),
    );
  }
}

class _ShareGlyph extends StatelessWidget {
  const _ShareGlyph({
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
    return Container(
      padding: EdgeInsetsDirectional.all(spacing.md),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: palette.card.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: palette.accent.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          width: 72,
          height: 72,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Icon(icon, size: 48, color: palette.accent),
        ),
      ),
    );
  }
}

class _SharePill extends StatelessWidget {
  const _SharePill({required this.label, required this.palette});

  final String label;
  final SectionColors palette;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.accent.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface,
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
