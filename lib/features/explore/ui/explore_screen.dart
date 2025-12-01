import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/home_bottom_nav.dart';
import '../../../core/ui/kinly_selection_card.dart';
import '../../../generated/l10n.dart';
import '../../../core/theme/section_assets.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      // ❗ Prevent Explore from being popped via back button / gesture
      canPop: false,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(s.navExplore),
          // Just in case, no back arrow on Explore root tab
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.all(spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.exploreIntroTitle, style: theme.textTheme.headlineSmall),
                SizedBox(height: spacing.sm),
                Text(
                  s.exploreIntroSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: spacing.lg),
                KinlySelectionCard(
                  colors: sections.flow,
                  title: s.quick_add_flow_title,
                  subtitle: s.exploreFlowSubtitle,
                  icon: SectionAssets.flow.build(
                    color: sections.flow.icon,
                    size: 32,
                  ),
                  onTap: () => context.push(AppRoutes.flow),
                ),

                SizedBox(height: spacing.md),

                KinlySelectionCard(
                  colors: sections.share,
                  title: s.quick_add_share_title,
                  subtitle: s.exploreShareSubtitle,
                  icon: SectionAssets.share.build(
                    color: sections.share.icon,
                    size: 32,
                  ),
                  onTap: () => context.push(AppRoutes.shareCreatedList),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: HomeBottomNav(
          currentIndex: 1,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go(AppRoutes.today);
                break;
              case 1:
                // Already on Explore
                break;
              case 2:
                context.go(AppRoutes.hub);
                break;
            }
          },
        ),
      ),
    );
  }
}
