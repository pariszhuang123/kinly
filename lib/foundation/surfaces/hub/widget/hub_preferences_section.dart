import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_selection_card.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_preferences_list_route_args.dart';
import '../bloc/hub_bloc.dart';

class HubPreferencesSection extends StatelessWidget {
  const HubPreferencesSection({
    super.key,
    required this.members,
    required this.reportItems,
    required this.currentUserId,
    required this.houseVibe,
    required this.hubBloc,
  });

  final List<HomeMemberSummary> members;
  final List<PreferenceReportListItem> reportItems;
  final String currentUserId;
  final HouseVibePayload? houseVibe;
  final HubBloc hubBloc;

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
        members
            .where((member) => reportByUser.containsKey(member.userId))
            .toList();

    if (visibleMembers.isEmpty) return const SizedBox.shrink();

    final palette =
        sections?.preference ??
        context.preferenceSection ??
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
            currentUserId: currentUserId,
            houseVibe: houseVibe,
            hubBloc: hubBloc,
          ),
        );
      },
    );
  }
}
