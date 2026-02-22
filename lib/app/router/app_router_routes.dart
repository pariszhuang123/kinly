part of 'app_router.dart';

List<GoRoute> _buildRoutes(AuthBloc authBloc) {
  return [
    ...buildHomeMembershipRoutes(),
    ...buildWelcomeRoutes(),
    ...buildFlowRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) return null;
        return FlowRouteContext(
          homeId: membership.homeId,
          userId: membership.userId,
        );
      },
    ),
    ...buildShareRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) return null;
        return ShareRouteContext(homeId: membership.homeId);
      },
    ),
    ...buildProfileSettingsRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) return null;
        return ProfileSettingsRouteContext(homeId: membership.homeId);
      },
      onMembershipRefresh:
          () => authBloc.add(const AuthMembershipRefreshRequested()),
      onSignOut: () => authBloc.add(const AuthSignOutRequested()),
    ),
    ...buildProfileSettingsDetailRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) return null;
        return ProfileSettingsDetailRouteContext(homeId: membership.homeId);
      },
    ),
    ...buildNpsRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) return null;
        return NpsRouteContext(homeId: membership.homeId);
      },
    ),
    ...buildHarmonyRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) return null;
        return HarmonyRouteContext(homeId: membership.homeId);
      },
    ),
    ...buildPersonalRoutes(),
    ...buildPreferenceRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        final userId = authBloc.state.userId;
        if (userId == null) {
          throw StateError('Preferences are available after sign in.');
        }
        return PreferenceRouteContext(
          homeId: membership?.homeId,
          userId: userId,
        );
      },
    ),
    ...buildHouseNormRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        final userId = authBloc.state.userId;
        if (membership == null || userId == null) return null;
        return HouseNormRouteContext(
          homeId: membership.homeId,
          userId: userId,
          isOwner: membership.role.toLowerCase() == 'owner',
        );
      },
    ),
    ...buildPaywallRoutes(),
    ...buildSplashRoutes(),
    ...buildVersionGatingRoutes(),
    ...buildProfileRoutes(),
    ...buildExploreRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) return null;
        return ExploreRouteContext(
          homeId: membership.homeId,
          userId: membership.userId,
        );
      },
    ),
    ...buildHubRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) return null;
        return HubRouteContext(homeId: membership.homeId);
      },
    ),
    ...buildTodayRoutes(
      resolveContext: () {
        final membership = authBloc.state.membership;
        if (membership == null) return null;
        return TodayRouteContext(homeId: membership.homeId);
      },
    ),
  ];
}
