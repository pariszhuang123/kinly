import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_scrollbar.dart';
import 'package:kinly/core/ui/kinly_selection_card.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_preferences_list_route_args.dart';

class HubPreferencesSection extends StatelessWidget {
  const HubPreferencesSection({
    super.key,
    required this.members,
    required this.reportItems,
  });

  final List<HomeMemberSummary> members;
  final List<PreferenceReportListItem> reportItems;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty || reportItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = KinlyThemeAccess.of(context);
    final sections = theme.extension<KinlySections>();
    final colors = theme.colorScheme;
    final s = S.of(context);

    final reportByUser = {
      for (final report in reportItems) report.subjectUserId: report,
    };
    final visibleMembers =
        members.where((member) => reportByUser.containsKey(member.userId)).toList();

    if (visibleMembers.isEmpty) return const SizedBox.shrink();

    final palette = sections?.share ??
        sections?.pulse ??
        SectionColors(
          background: colors.surfaceContainerHighest,
          card: colors.surfaceContainerHigh,
          icon: colors.primary,
          accent: colors.primary,
        );

    return KinlySelectionCard(
      colors: palette,
      title: s.hubPreferencesTitle,
      subtitle: s.hubPreferencesSubtitle,
      icon: Icon(
        KinlyIcons.selfImprovementRounded,
        color: palette.icon,
        size: 28,
      ),
      onTap: () {
        context.pushNamed(
          AppRouteNames.hubPreferencesList,
          extra: HubPreferencesListArgs(
            members: visibleMembers,
            palette: palette,
          ),
        );
      },
    );
  }
}

class HubPreferencesListScreen extends StatelessWidget {
  const HubPreferencesListScreen({
    super.key,
    required this.members,
    required this.palette,
  });

  final List<HomeMemberSummary> members;
  final SectionColors palette;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.hubPreferencesTitle)),
      body: SafeArea(
        child: KinlyScrollbar(
          child: KinlyScrollFade(
            child: ListView.separated(
              padding: EdgeInsetsDirectional.fromSTEB(
                spacing.lg,
                spacing.lg,
                spacing.lg,
                spacing.xl,
              ),
              itemCount: members.length,
              separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
              itemBuilder: (context, index) {
                final member = members[index];
                final displayName =
                    member.username.isNotEmpty ? member.username : s.friendDefaultName;
                final avatar = member.avatarUrl ?? '';

                return KinlyTapTarget(
                  onTap: () {
                    context.goNamed(
                      AppRouteNames.preferenceReportView,
                      pathParameters: {'subjectUserId': member.userId},
                      extra: {
                        'displayName': displayName,
                        'avatarUrl': avatar,
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
    );
  }
}
