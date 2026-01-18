import 'package:flutter/widgets.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/house_vibe_assets.dart';
import 'package:kinly/core/ui/house_vibe_strings.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/generated/l10n.dart';

import 'package:kinly/renderer/material/share/kinly_share_card.dart';
import 'package:kinly/core/ui/kinly_section_card.dart';
import 'package:kinly/core/ui/enums/kinly_section_card_visual_position.dart';

class HouseInfoCardData {
  const HouseInfoCardData({
    required this.header,
    required this.title,
    required this.summary,
    required this.footer,
    required this.assetPath,
    required this.palette,
    this.coverage,
    this.logger,
    this.logContext,
  });

  final String header;
  final String title;
  final String summary;
  final String footer;
  final String assetPath;
  final SectionColors palette;
  final String? coverage;
  final Logger? logger;
  final String? logContext;

  factory HouseInfoCardData.fromVibe({
    required HouseVibePayload vibe,
    required SectionColors palette,
    required S strings,
    bool includeCoverage = true,
    String? assetPathOverride,
    Logger? logger,
  }) {
    final coverage =
        includeCoverage && vibe.coverage.total > 0
            ? strings.homeVibeCoverage(
              vibe.coverage.answered,
              vibe.coverage.total,
            )
            : null;

    final assetPath =
        assetPathOverride ??
        resolveHouseVibeAssetPath(
          mappingVersion: vibe.mappingVersion,
          imageKey: vibe.imageKey,
          labelId: vibe.labelId,
        );

    return HouseInfoCardData(
      header: strings.homeVibeTitle,
      title: resolveHouseVibeTitle(strings, vibe.titleKey),
      summary: resolveHouseVibeSummary(strings, vibe.summaryKey),
      footer: strings.gratitudeWallFooter(strings.app_title),
      assetPath: assetPath,
      palette: palette,
      coverage: coverage,
      logger: logger,
      logContext:
          'homeId=${vibe.homeId} labelId=${vibe.labelId} '
          'mappingVersion=${vibe.mappingVersion} imageKey=${vibe.imageKey}',
    );
  }
}

class HouseInfoCard extends StatelessWidget {
  const HouseInfoCard({
    super.key,
    required this.data,
    this.showCoverage = true,
  });

  final HouseInfoCardData data;
  final bool showCoverage;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    return KinlySectionCard(
      header: data.header,
      palette: data.palette,
      title: data.title,
      summary: data.summary,
      // Note: we purposely omit 'footer' ("Made with Kinly") and 'tags' (coverage) as requested.
      visualPosition: KinlySectionCardVisualPosition.right,
      visual: Container(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          color: data.palette.card,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: EdgeInsetsDirectional.all(spacing.xs),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            data.assetPath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              data.logger?.warn(
                'house_info_asset_load_failed ${data.logContext} '
                'assetPath=${data.assetPath}',
              );
              return Icon(KinlyIcons.brokenImage, color: data.palette.icon);
            },
          ),
        ),
      ),
    );
  }
}

class HouseInfoShareCard extends StatelessWidget {
  const HouseInfoShareCard({super.key, required this.data});

  final HouseInfoCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    return KinlyShareCard(
      header: data.header,
      title: data.title,
      summary: data.summary,
      palette: data.palette,
      // HouseInfoCard uses solid background
      useGradientBackground: false,
      visualContent: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.asset(
            data.assetPath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              data.logger?.warn(
                'house_info_asset_load_failed ${data.logContext} '
                'assetPath=${data.assetPath}',
              );
              return Icon(KinlyIcons.brokenImage, color: data.palette.icon);
            },
          ),
        ),
      ),
      footerContent: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xs,
        ),
        decoration: BoxDecoration(
          color: data.palette.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          data.footer,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
