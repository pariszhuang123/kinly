import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_scrollbar.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/generated/l10n.dart';

class HubPreferencesListScreen extends StatelessWidget {
  const HubPreferencesListScreen({
    super.key,
    required this.members,
    required this.palette,
    required this.currentUserId,
  });

  final List<HomeMemberSummary> members;
  final SectionColors palette;
  final String currentUserId;

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
                    member.username.isNotEmpty
                        ? member.username
                        : s.friendDefaultName;
                final avatar = member.avatarUrl ?? '';
                final isCreator =
                    currentUserId.isNotEmpty && member.userId == currentUserId;

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
    );
  }
}
