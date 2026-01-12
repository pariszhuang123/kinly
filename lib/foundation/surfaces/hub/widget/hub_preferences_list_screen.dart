import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/config/app_config.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/house_vibe_assets.dart';
import 'package:kinly/core/ui/house_vibe_strings.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_scrollbar.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/core/ui/section_container.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:share_plus/share_plus.dart';
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
                                    color: palette.icon.withValues(
                                      alpha: 0.14,
                                    ),
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
  final GlobalKey _repaintKey = GlobalKey();
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    final card = RepaintBoundary(
      key: _repaintKey,
      child: _HouseVibeCard(
        vibe: widget.vibe,
        palette: widget.palette,
      ),
    );

    return Stack(
      children: [
        card,
        PositionedDirectional(
          top: spacing.sm,
          end: spacing.sm,
          child: KinlyTapTarget(
            borderRadius: BorderRadius.circular(24),
            onTap:
                _isSharing
                    ? null
                    : () async {
                      widget.hubBloc.add(
                        const HubShareLogged(
                          feature: 'house_vibe',
                          channel: 'system_share',
                        ),
                      );
                      await _share();
                    },
            child: Semantics(
              button: true,
              label: s.houseVibeShareCta,
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: widget.palette.icon.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  KinlyIcons.iosShareRounded,
                  size: 20,
                  color: widget.palette.icon,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _share() async {
    final s = S.of(context);
    setState(() => _isSharing = true);
    try {
      final boundary =
          _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        if (!mounted) return;
        KinlySnackBar.showError(context, s.houseVibeShareError);
        return;
      }
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      if (!mounted) return;
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        if (!mounted) return;
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
      if (!mounted) return;
    } catch (_) {
      if (!mounted) return;
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
}

class _HouseVibeCard extends StatelessWidget {
  const _HouseVibeCard({required this.vibe, required this.palette});

  final HouseVibePayload vibe;
  final SectionColors palette;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    final vibeTitle = resolveHouseVibeTitle(s, vibe.titleKey);
    final vibeSummary = resolveHouseVibeSummary(s, vibe.summaryKey);
    final coverage =
        vibe.coverage.total > 0
            ? s.homeVibeCoverage(
              vibe.coverage.answered,
              vibe.coverage.total,
            )
            : '';
    final assetPath = resolveHouseVibeAssetPath(
      mappingVersion: vibe.mappingVersion,
      imageKey: vibe.imageKey,
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
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                    if (coverage.isNotEmpty) ...[
                      SizedBox(height: spacing.sm),
                      Text(
                        coverage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
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
                    errorBuilder:
                        (_, __, ___) => Icon(
                          KinlyIcons.brokenImage,
                          color: palette.icon,
                        ),
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
