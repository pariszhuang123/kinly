import 'package:flutter/widgets.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/house_vibe_assets.dart';
import 'package:kinly/core/ui/house_vibe_strings.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/section_container.dart';
import 'package:kinly/generated/l10n.dart';

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

    return SectionContainer(
      title: data.header,
      colors: data.palette,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: data.palette.accent,
                      ),
                    ),
                    if (data.summary.isNotEmpty) ...[
                      SizedBox(height: spacing.xs),
                      Text(
                        data.summary,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                    if (showCoverage &&
                        (data.coverage?.isNotEmpty ?? false)) ...[
                      SizedBox(height: spacing.sm),
                      Text(
                        data.coverage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: spacing.md),
              Container(
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
                      return Icon(
                        KinlyIcons.brokenImage,
                        color: data.palette.icon,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xs,
            ),
            decoration: BoxDecoration(
              color: data.palette.card.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              data.footer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: data.palette.card,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              data.header,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              data.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: data.palette.accent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            ClipRRect(
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
                    return Icon(
                      KinlyIcons.brokenImage,
                      color: data.palette.icon,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            Text(
              data.summary,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            Container(
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
          ],
        ),
      ),
    );
  }
}
