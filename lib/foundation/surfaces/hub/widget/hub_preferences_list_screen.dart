import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/config/app_config.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/house_vibe_assets.dart';
import 'package:kinly/core/ui/house_vibe_strings.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/buttons/kinly_fab.dart';
import 'package:kinly/core/ui/kinly_scrollbar.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/core/ui/section_container.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_house_vibe_share_route_args.dart';
import '../bloc/hub_bloc.dart';

class HubPreferencesListScreen extends StatelessWidget {
  const HubPreferencesListScreen({
    super.key,
    required this.members,
    required this.palette,
    required this.currentUserId,
    required this.houseVibe,
    required this.hubBloc,
  });

  final List<HomeMemberSummary> members;
  final SectionColors palette;
  final String currentUserId;
  final HouseVibePayload? houseVibe;
  final HubBloc hubBloc;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.hubPreferencesTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (houseVibe != null) ...[
                _HouseVibeSection(
                  vibe: houseVibe!,
                  palette: palette,
                  hubBloc: hubBloc,
                ),
                SizedBox(height: spacing.lg),
              ],
              Expanded(
                child: KinlyScrollbar(
                  child: KinlyScrollFade(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: members.length,
                      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                      itemBuilder: (context, index) {
                        final member = members[index];
                        final displayName =
                            member.username.isNotEmpty
                                ? member.username
                                : s.friendDefaultName;
                        final avatar = member.avatarUrl ?? '';
                        final isCreator =
                            currentUserId.isNotEmpty &&
                            member.userId == currentUserId;

                        return KinlyTapTarget(
                          onTap: () {
                            if (isCreator) {
                              context.goNamed(
                                AppRouteNames.preferenceReportEdit,
                                extra: {
                                  'displayName': displayName,
                                  'avatarUrl': avatar,
                                },
                              );
                              return;
                            }
                            context.goNamed(
                              AppRouteNames.preferenceReportEdit,
                              extra: {
                                'displayName': displayName,
                                'avatarUrl': avatar,
                                'canEdit': false,
                                'subjectUserId': member.userId,
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              spacing.md,
                              spacing.sm,
                              spacing.md,
                              spacing.sm,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: palette.icon.withValues(alpha: 0.14),
                                    image:
                                        avatar.isNotEmpty
                                            ? DecorationImage(
                                              image: NetworkImage(avatar),
                                              fit: BoxFit.cover,
                                            )
                                            : null,
                                  ),
                                  child:
                                      avatar.isEmpty
                                          ? Icon(
                                            KinlyIcons.selfImprovementRounded,
                                            color: palette.icon,
                                          )
                                          : null,
                                ),
                                SizedBox(width: spacing.md),
                                Expanded(
                                  child: Text(
                                    displayName,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                Icon(
                                  KinlyIcons.chevronRightRounded,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HouseVibeSection extends StatefulWidget {
  const _HouseVibeSection({
    required this.vibe,
    required this.palette,
    required this.hubBloc,
  });

  final HouseVibePayload vibe;
  final SectionColors palette;
  final HubBloc hubBloc;

  @override
  State<_HouseVibeSection> createState() => _HouseVibeSectionState();
}

class _HouseVibeSectionState extends State<_HouseVibeSection> {
  @override
  Widget build(BuildContext context) {
    final assetPath = resolveHouseVibeAssetPath(
      mappingVersion: widget.vibe.mappingVersion,
      imageKey: widget.vibe.imageKey,
      labelId: widget.vibe.labelId,
    );

    final card = _HouseVibeCard(
      vibe: widget.vibe,
      palette: widget.palette,
      showCoverage: true,
      assetPathOverride: assetPath,
      logger: sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger(),
    );

    return KinlyTapTarget(
      borderRadius: BorderRadius.circular(24),
      onTap:
          () => context.pushNamed(
            AppRouteNames.hubHouseVibeShare,
            extra: HubHouseVibeShareArgs(
              vibe: widget.vibe,
              palette: widget.palette,
              hubBloc: widget.hubBloc,
            ),
          ),
      child: Semantics(
        button: true,
        label: S.of(context).houseVibeShareCta,
        child: card,
      ),
    );
  }
}

class _HouseVibeCard extends StatelessWidget {
  const _HouseVibeCard({
    required this.vibe,
    required this.palette,
    this.showCoverage = true,
    this.assetPathOverride,
    this.logger,
  });

  final HouseVibePayload vibe;
  final SectionColors palette;
  final bool showCoverage;
  final String? assetPathOverride;
  final Logger? logger;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    final vibeTitle = resolveHouseVibeTitle(s, vibe.titleKey);
    final vibeSummary = resolveHouseVibeSummary(s, vibe.summaryKey);
    final coverage =
        vibe.coverage.total > 0
            ? s.homeVibeCoverage(vibe.coverage.answered, vibe.coverage.total)
            : '';
    final assetPath =
        assetPathOverride ??
        resolveHouseVibeAssetPath(
          mappingVersion: vibe.mappingVersion,
          imageKey: vibe.imageKey,
          labelId: vibe.labelId,
        );

    return SectionContainer(
      title: s.homeVibeTitle,
      colors: palette,
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
                      vibeTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: palette.accent,
                      ),
                    ),
                    if (vibeSummary.isNotEmpty) ...[
                      SizedBox(height: spacing.xs),
                      Text(
                        vibeSummary,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                    if (showCoverage && coverage.isNotEmpty) ...[
                      SizedBox(height: spacing.sm),
                      Text(
                        coverage,
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
                  color: palette.card,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: EdgeInsetsDirectional.all(spacing.xs),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      logger?.warn(
                        'house_vibe_asset_load_failed '
                        'homeId=${vibe.homeId} labelId=${vibe.labelId} '
                        'mappingVersion=${vibe.mappingVersion} '
                        'imageKey=${vibe.imageKey} assetPath=$assetPath',
                      );
                      return Icon(KinlyIcons.brokenImage, color: palette.icon);
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
              color: palette.card.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              s.gratitudeWallFooter(s.app_title),
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

class HouseVibeShareScreen extends StatefulWidget {
  const HouseVibeShareScreen({
    super.key,
    required this.vibe,
    required this.palette,
    required this.hubBloc,
  });

  final HouseVibePayload vibe;
  final SectionColors palette;
  final HubBloc hubBloc;

  @override
  State<HouseVibeShareScreen> createState() => _HouseVibeShareScreenState();
}

class _HouseVibeShareScreenState extends State<HouseVibeShareScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isSharing = false;

  Future<void> _share(BuildContext context, String assetPath) async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    final s = S.of(context);
    try {
      widget.hubBloc.add(
        const HubShareLogged(feature: 'house_vibe', channel: 'system_share'),
      );
      await precacheImage(AssetImage(assetPath), context);
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        KinlySnackBar.showError(context, s.houseVibeShareError);
        return;
      }
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        KinlySnackBar.showError(context, s.houseVibeShareError);
        return;
      }
      final pngBytes = byteData.buffer.asUint8List();

      final appLink = _resolveAppLink();
      final message = s.houseVibeShareMessage(appLink);

      final xfile = XFile.fromData(
        pngBytes,
        mimeType: 'image/png',
        name: 'house_vibe.png',
      );

      await Share.shareXFiles(
        [xfile],
        subject: s.houseVibeShareTitle,
        text: message,
      );
    } catch (_) {
      KinlySnackBar.showError(context, s.houseVibeShareError);
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  String _resolveAppLink() {
    if (AppConfig.iosStoreUrl.isNotEmpty) return AppConfig.iosStoreUrl;
    if (AppConfig.androidStoreUrl.isNotEmpty) return AppConfig.androidStoreUrl;
    return 'https://kinly.app';
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>();
    final resolvedPalette = sections?.share ?? widget.palette;
    final assetPath = resolveHouseVibeAssetPath(
      mappingVersion: widget.vibe.mappingVersion,
      imageKey: widget.vibe.imageKey,
      labelId: widget.vibe.labelId,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: resolvedPalette.background,
        systemNavigationBarColor: resolvedPalette.background,
        systemNavigationBarDividerColor: resolvedPalette.background,
      ),
      child: KinlyScaffold(
        backgroundColor: resolvedPalette.background,
        body: ColoredBox(
          color: resolvedPalette.background,
          child: RepaintBoundary(
            key: _repaintKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                var width = constraints.maxWidth;
                var height = width * (16 / 9);
                if (height > constraints.maxHeight) {
                  height = constraints.maxHeight;
                  width = height * (9 / 16);
                }

                return Center(
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: ColoredBox(
                      color: theme.colorScheme.surface,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(spacing.xl),
                        child: Column(
                          children: [
                            const Spacer(),
                            _HouseVibeShareCard(
                              vibe: widget.vibe,
                              palette: resolvedPalette,
                              assetPath: assetPath,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: IgnorePointer(
          ignoring: _isSharing,
          child: KinlyFab(
            heroTag: 'house_vibe_share_fab',
            tooltip: s.houseVibeShareCta,
            icon: KinlyIcons.iosShareRounded,
            onPressed: () => _share(context, assetPath),
          ),
        ),
      ),
    );
  }
}

class _HouseVibeShareCard extends StatelessWidget {
  const _HouseVibeShareCard({
    required this.vibe,
    required this.palette,
    required this.assetPath,
  });

  final HouseVibePayload vibe;
  final SectionColors palette;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    final sections = theme.extension<KinlySections>();
    final resolvedPalette = sections?.share ?? palette;

    final vibeTitle = resolveHouseVibeTitle(s, vibe.titleKey);
    final vibeSummary = resolveHouseVibeSummary(s, vibe.summaryKey);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolvedPalette.card,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              s.homeVibeTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              vibeTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: palette.accent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(assetPath, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: spacing.md),
            Text(
              vibeSummary,
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
                color: palette.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                s.gratitudeWallFooter(s.app_title),
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
