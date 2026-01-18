import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/renderer/material/share/kinly_story_share_scaffold.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/house/house_info_card.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_scrollbar.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_house_vibe_share_route_args.dart';
import 'package:kinly/generated/l10n.dart';
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
    final sections = theme.extension<KinlySections>();
    final resolvedPalette = sections?.preference ?? palette;
    final _ = context.preferenceSection;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(s.hubPreferencesTitle),
        backgroundColor: surface,
        foregroundColor: onSurface,
      ),
      backgroundColor: surface,
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
                  palette: resolvedPalette,
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: resolvedPalette.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: resolvedPalette.accent.withValues(
                                  alpha: 0.12,
                                ),
                              ),
                            ),
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
                                    color: resolvedPalette.icon.withValues(
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
                                            color: resolvedPalette.icon,
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
                                  color: resolvedPalette.icon,
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
    final s = S.of(context);
    final data = HouseInfoCardData.fromVibe(
      vibe: widget.vibe,
      palette: widget.palette,
      strings: s,
      includeCoverage: true,
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
        child: HouseInfoCard(data: data),
      ),
    );
  }
}

class HouseVibeShareScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final sections = theme.extension<KinlySections>();
    final resolvedPalette = sections?.preference ?? palette;

    final data = HouseInfoCardData.fromVibe(
      vibe: vibe,
      palette: resolvedPalette,
      strings: s,
      includeCoverage: false,
      logger: sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger(),
    );

    return KinlyStoryShareScaffold(
      fileNamePrefix: 'house_vibe',
      logTag: 'house_vibe',
      appBarTitle: null, // As requested: remove title
      fabTooltip: s.houseVibeShareCta,
      subjectBuilder: (ctx) => s.houseVibeShareTitle,
      messageBuilder: (ctx, appLink) => s.houseVibeShareMessage(appLink),
      onSharePressed: () async {
        hubBloc.add(
          const HubShareLogged(feature: 'house_vibe', channel: 'system_share'),
        );
      },
      child: HouseInfoShareCard(data: data),
    );
  }
}
