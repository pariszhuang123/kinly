// lib/features/explore/ui/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/home_bottom_nav.dart';
import '../../../generated/l10n.dart';

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
            padding: EdgeInsets.all(spacing.lg),
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
                _ExploreCard(
                  colors: sections.flow,
                  title: s.quick_add_flow_title,
                  subtitle: s.exploreFlowSubtitle,
                  icon: Icons.repeat_rounded,
                  // ✅ Explore → Flow list as a sub-page
                  onTap: () => context.push(AppRoutes.flow),
                ),
                SizedBox(height: spacing.md),
                _ExploreCard(
                  colors: sections.share,
                  title: s.quick_add_share_title,
                  subtitle: s.exploreShareSubtitle,
                  icon: Icons.payments_rounded,
                  // ✅ Explore → Share created list as a sub-page
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
                // ✅ Switch root tab via go()
                context.go(AppRoutes.today);
                break;
              case 1:
                // Already on Explore
                break;
              case 2:
                // ✅ Hook up Hub root tab
                context.go(AppRoutes.hub);
                break;
            }
          },
        ),
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final SectionColors colors;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: colors.icon.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: colors.icon, size: 28),
            ),
            SizedBox(width: spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.icon,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.icon),
          ],
        ),
      ),
    );
  }
}
