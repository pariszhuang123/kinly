part of 'app_router.dart';

List<GoRoute> _buildRoutes(AuthBloc authBloc) {
  return [
    ...buildHomeMembershipRoutes(),
    ...buildWelcomeRoutes(),
    ...buildFlowRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Flow routes require an active membership.');
        }
        return FlowRouteContext(
          homeId: membership.homeId,
          userId: membership.userId,
        );
      },
    ),
    ...buildShareRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Share routes require an active membership.');
        }
        return ShareRouteContext(homeId: membership.homeId);
      },
    ),
    ...buildProfileSettingsRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Profile settings requires an active membership.');
        }
        return ProfileSettingsRouteContext(homeId: membership.homeId);
      },
      onMembershipRefresh:
          () => authBloc.add(const AuthMembershipRefreshRequested()),
      onSignOut: () => authBloc.add(const AuthSignOutRequested()),
    ),
    ...buildProfileSettingsDetailRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Profile settings requires an active membership.');
        }
        return ProfileSettingsDetailRouteContext(homeId: membership.homeId);
      },
    ),
    ...buildNpsRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('NPS requires an active membership.');
        }
        return NpsRouteContext(homeId: membership.homeId);
      },
    ),
    ...buildHarmonyRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Harmony requires an active membership.');
        }
        return HarmonyRouteContext(homeId: membership.homeId);
      },
    ),
    ...buildPaywallRoutes(),
    ...buildSplashRoutes(),
    ...buildVersionGatingRoutes(),
    ...buildProfileRoutes(),
    ...buildExploreRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Explore requires an active membership.');
        }
        return const ExploreRouteContext();
      },
    ),
    ...buildHubRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Hub requires an active membership.');
        }
        return HubRouteContext(homeId: membership.homeId);
      },
    ),
    ...buildTodayRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Today requires an active membership.');
        }
        return TodayRouteContext(homeId: membership.homeId);
      },
    ),
  ];
}
