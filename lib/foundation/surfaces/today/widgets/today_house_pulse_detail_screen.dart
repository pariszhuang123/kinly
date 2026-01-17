import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:kinly/contracts/mood/enums/house_pulse_state.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/house_pulse_models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/house_pulse_strings.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/renderer/material/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/buttons/kinly_fab.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/share/snapshot_sharer.dart';
import 'package:kinly/foundation/surfaces/today/bloc/today_bloc.dart';

class TodayHousePulseDetailScreen extends StatefulWidget {
  const TodayHousePulseDetailScreen({super.key, required this.pulse});

  final HousePulsePayload pulse;

  @override
  State<TodayHousePulseDetailScreen> createState() =>
      _TodayHousePulseDetailScreenState();
}

class _TodayHousePulseDetailScreenState
    extends State<TodayHousePulseDetailScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isSharing = false;

  Future<void> _share() async {
    if (_isSharing || !mounted) return;
    setState(() => _isSharing = true);
    final s = S.of(context);
    try {
      context.read<TodayBloc>().add(
            const TodayHousePulseShareLogged(channel: 'system_share'),
          );
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      final shared = await SnapshotSharer.shareRepaintBoundary(
        context: context,
        repaintKey: _repaintKey,
        fileNamePrefix: 'house_pulse',
        logTag: 'house_pulse',
        subject: s.housePulseShareTitle,
        messageBuilder: (appLink) => s.housePulseShareMessage(appLink),
      );
      if (!shared && mounted) {
        KinlySnackBar.showError(context, s.housePulseShareError);
      }
    } catch (_) {
      if (mounted) {
        KinlySnackBar.showError(context, s.housePulseShareError);
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);
    final pulse = widget.pulse;
    final title = resolveHousePulseTitle(s, pulse.label.titleKey);
    final summary = resolveHousePulseSummary(s, pulse.label.summaryKey);
    final updatedLabel =
        s.housePulseUpdatedOn(DateFormat.yMMMd().format(pulse.pulse.computedAt));
    final reflectionsLabel =
        s.housePulseReflections(pulse.pulse.reflectionCount);
    final icon = _iconFor(pulse.pulse.pulseState, pulse.pulse.weatherDisplay);

    return KinlyScaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: KinlyAppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        title: Text(s.housePulseCardHeader),
      ),
      body: ColoredBox(
        color: theme.colorScheme.surface,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.all(spacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: HousePulseShareCard(
                    pulse: pulse,
                    palette: sections.pulse,
                    title: title,
                    summary: summary,
                    updatedLabel: updatedLabel,
                    reflectionsLabel: reflectionsLabel,
                    icon: icon,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: IgnorePointer(
        ignoring: _isSharing,
        child: KinlyFab(
          heroTag: 'house_pulse_share_fab',
          tooltip: s.housePulseShareCta,
          icon: KinlyIcons.iosShareRounded,
          onPressed: _share,
        ),
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
  });

  final HousePulsePayload pulse;
  final SectionColors palette;
  final String title;
  final String summary;
  final String updatedLabel;
  final String reflectionsLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            palette.card,
            palette.card.withValues(alpha: 0.92),
            palette.card.withValues(alpha: 0.86),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              s.housePulseCardHeader,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: palette.accent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            _ShareGlyph(icon: icon, palette: palette),
            SizedBox(height: spacing.md),
            Text(
              summary,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: spacing.md,
              runSpacing: spacing.xs,
              children: [
                _SharePill(label: updatedLabel, palette: palette),
                _SharePill(label: reflectionsLabel, palette: palette),
              ],
            ),
            SizedBox(height: spacing.md),
            Text(
              DateFormat("eeee, MMM d").format(pulse.pulse.computedAt),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareGlyph extends StatelessWidget {
  const _ShareGlyph({required this.icon, required this.palette});

  final IconData icon;
  final SectionColors palette;

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
      child: Icon(
        icon,
        size: 48,
        color: palette.accent,
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
