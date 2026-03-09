import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:kinly/core/ui/kinly_refresh_indicator.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_scrollbar.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_house_vibe_share_route_args.dart';
import 'package:kinly/generated/l10n.dart';
import '../bloc/hub_bloc.dart';

class HubPreferencesListScreen extends StatefulWidget {
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
  State<HubPreferencesListScreen> createState() =>
      _HubPreferencesListScreenState();
}

class _HubPreferencesListScreenState extends State<HubPreferencesListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final bloc = widget.hubBloc;
    if (bloc.state.isRefreshing) {
      await bloc.stream.firstWhere((state) => !state.isRefreshing);
      return;
    }

    final completion = bloc.stream
        .skipWhile((state) => !state.isRefreshing)
        .firstWhere((state) => !state.isRefreshing);
    bloc.add(const HubRefreshed());
    await completion;
  }

  void _openPreferenceReport({
    required BuildContext context,
    required bool isCreator,
    required String displayName,
    required String avatarUrl,
    required String subjectUserId,
  }) {
    final extra = <String, Object>{
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    };

    if (!isCreator) {
      extra['canEdit'] = false;
      extra['subjectUserId'] = subjectUserId;
    }

    context.goNamed(
      AppRouteNames.preferenceReportEdit,
      extra: extra,
    );
  }

  Widget _buildMemberTile({
    required BuildContext context,
    required HomeMemberSummary member,
    required String resolvedCurrentUserId,
    required SectionColors resolvedPalette,
    required Spacing spacing,
    required TextStyle? titleStyle,
    required S strings,
  }) {
    final displayName =
        member.username.isNotEmpty ? member.username : strings.friendDefaultName;
    final avatar = member.avatarUrl ?? '';
    final isCreator =
        resolvedCurrentUserId.isNotEmpty && member.userId == resolvedCurrentUserId;

    return KinlyTapTarget(
      onTap:
          () => _openPreferenceReport(
            context: context,
            isCreator: isCreator,
            displayName: displayName,
            avatarUrl: avatar,
            subjectUserId: member.userId,
          ),
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
                style: titleStyle,
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>();
    final resolvedPalette = sections?.preference ?? widget.palette;
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
      body: BlocBuilder<HubBloc, HubState>(
        bloc: widget.hubBloc,
        builder: (context, state) {
          final memberById = {
            for (final member in state.members) member.userId: member,
          };
          final resolvedMembers =
              widget.members
                  .map((member) => memberById[member.userId] ?? member)
                  .toList(growable: false);
          final resolvedCurrentUserId =
              state.currentUserId.isNotEmpty
                  ? state.currentUserId
                  : widget.currentUserId;
          final resolvedHouseVibe = state.houseVibe ?? widget.houseVibe;
          final hasHouseVibe = resolvedHouseVibe != null;

          return SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                spacing.lg,
                spacing.lg,
                spacing.lg,
                spacing.xl,
              ),
              child: KinlyRefreshIndicator(
                onRefresh: _onRefresh,
                child: KinlyScrollbar(
                  controller: _scrollController,
                  child: KinlyScrollFade(
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: resolvedMembers.length + (hasHouseVibe ? 1 : 0),
                      separatorBuilder:
                          (_, index) => SizedBox(
                            height:
                                hasHouseVibe && index == 0
                                    ? spacing.lg
                                    : spacing.sm,
                          ),
                      itemBuilder: (context, index) {
                        if (hasHouseVibe && index == 0) {
                          return _HouseVibeSection(
                            vibe: resolvedHouseVibe,
                            palette: resolvedPalette,
                            hubBloc: widget.hubBloc,
                          );
                        }

                        final member =
                            resolvedMembers[index - (hasHouseVibe ? 1 : 0)];
                        return _buildMemberTile(
                          context: context,
                          member: member,
                          resolvedCurrentUserId: resolvedCurrentUserId,
                          resolvedPalette: resolvedPalette,
                          spacing: spacing,
                          titleStyle: theme.textTheme.titleMedium,
                          strings: s,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
