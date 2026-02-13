import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route_names.dart';
import '../../../app/router/home_tab_navigation.dart';
import '../../../app/router/home_tab_swipe_region.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/home_bottom_nav.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../generated/l10n.dart';
import '../today/routes/today_shopping_route_args.dart';
import 'explore_registry.dart';
import 'explore_slots.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_app_bar.dart';
import '../../../core/ui/kinly_theme_access.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key, required this.homeId});

  final String homeId;

  @override
  Widget build(BuildContext context) {
    ExploreRegistry.bootstrap();
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      // Prevent Explore from being popped via back button / gesture.
      canPop: false,
      child: HomeTabSwipeRegion(
        onSwipeLeft: () {
          context.goNamed(
            AppRouteNames.hub,
            extra: const HomeTabNavExtra(fromIndex: homeTabIndexExplore),
          );
        },
        onSwipeRight: () {
          context.goNamed(
            AppRouteNames.today,
            extra: const HomeTabNavExtra(fromIndex: homeTabIndexExplore),
          );
        },
        child: KinlyScaffold(
          backgroundColor: colorScheme.surface,
          appBar: KinlyAppBar(
            title: Text(s.navExplore),
            // Root tab: no back arrow.
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.all(spacing.lg),
              child: _buildExploreBody(context, theme, spacing, s),
            ),
          ),
          bottomNavigationBar: HomeBottomNav(
            currentIndex: 1,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.goNamed(
                    AppRouteNames.today,
                    extra: const HomeTabNavExtra(fromIndex: homeTabIndexExplore),
                  );
                  break;
                case 1:
                  // Already on Explore.
                  break;
                case 2:
                  context.goNamed(
                    AppRouteNames.hub,
                    extra: const HomeTabNavExtra(fromIndex: homeTabIndexExplore),
                  );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExploreBody(
    BuildContext context,
    dynamic theme,
    Spacing spacing,
    S strings,
  ) {
    final actions = ExploreSurfaceActions(
      onFlowTap: () => context.pushNamed(
        AppRouteNames.flow,
        queryParameters: {'homeId': homeId},
      ),
      onShareTap: () => context.pushNamed(AppRouteNames.shareCreatedList),
      onShoppingTap: () => context.pushNamed(
        AppRouteNames.todayShoppingList,
        queryParameters: {'homeId': homeId},
        extra: TodayShoppingRouteArgs(
          homeId: homeId,
          listMode: TodayShoppingListMode.manage,
        ),
      ),
    );
    final scope = ExploreSurfaceScope(
      context: context,
      spacing: spacing,
      sections: theme.extension<KinlySections>()!,
      strings: strings,
      actions: actions,
    );
    final slots = ExploreSurfaceSlots(body: _buildExploreContent(scope));
    return slots.body;
  }

  Widget _buildExploreContent(ExploreSurfaceScope scope) {
    return KinlyScrollFade(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildExploreSections(scope),
        ),
      ),
    );
  }

  List<Widget> _buildExploreSections(ExploreSurfaceScope scope) {
    final entries = ExploreRegistry.bodySections;
    final spacing = scope.spacing;
    final children = <Widget>[SizedBox(height: spacing.lg)];

    for (final entry in entries) {
      if (entry.isVisible != null && !entry.isVisible!(scope)) {
        continue;
      }
      children.add(entry.builder(scope));
      final gap = _resolveSectionSpacing(entry.spacingAfter, spacing);
      if (gap > 0) {
        children.add(SizedBox(height: gap));
      }
    }

    return children;
  }

  double _resolveSectionSpacing(ExploreSectionSpacing spacing, Spacing tokens) {
    switch (spacing) {
      case ExploreSectionSpacing.none:
        return 0;
      case ExploreSectionSpacing.sm:
        return tokens.sm;
      case ExploreSectionSpacing.md:
        return tokens.md;
      case ExploreSectionSpacing.lg:
        return tokens.lg;
      case ExploreSectionSpacing.xl:
        return tokens.xl;
    }
  }
}
