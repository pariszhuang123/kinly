part of 'app_router.dart';

typedef _RouteBuilder = Widget Function(BuildContext, GoRouterState);

class _RouteSpec {
  const _RouteSpec({
    required this.path,
    required this.name,
    required this.builder,
  });

  final String path;
  final String name;
  final _RouteBuilder builder;
}

List<GoRoute> _buildRoutes(AuthBloc authBloc) {
  final specs = <_RouteSpec>[
    _RouteSpec(
      path: AppRoutes.forceUpdate,
      name: 'forceUpdate',
      builder: (_, __) => const ForceUpdateScreen(),
    ),
    _RouteSpec(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (_, __) => const SplashScreen(),
    ),
    _RouteSpec(
      path: AppRoutes.welcome,
      name: 'welcome',
      builder: (_, __) => const WelcomeScreen(),
    ),
    _RouteSpec(
      path: AppRoutes.start,
      name: 'start',
      builder: (_, __) => const StartHomeProvider(),
    ),
    _RouteSpec(
      path: AppRoutes.join,
      name: 'join',
      builder: (_, __) => const JoinHomeScreen(),
    ),
    _RouteSpec(
      path: AppRoutes.joinBlocked,
      name: 'joinBlocked',
      builder: (_, __) => const JoinHomeBlockedScreen(),
    ),
  ];

  final dynamicSpecs = <_RouteSpec>[
    _RouteSpec(
      path: '/join/:code',
      name: 'joinWithCode',
      builder: (context, state) =>
          JoinHomeScreen(initialCode: state.pathParameters['code']),
    ),
    _RouteSpec(
      path: AppRoutes.today,
      name: 'today',
      builder: (_, __) {
        final homeId = authBloc.state.membership!.homeId;
        return TodayProvider(
          homeId: homeId,
          choresRepository: sl<ChoresRepository>(),
          profileRepository: sl<ProfileRepository>(),
          expensesRepository: sl<ExpensesRepository>(),
          homeRepository: sl<HomeRepository>(),
          moodRepository: sl<MoodRepository>(),
          onboardingRepository: sl<OnboardingRepository>(),
          profileUpdateNotifier: sl<ProfileUpdateNotifier>(),
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.nps,
      name: 'nps',
      builder: (_, __) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('NPS requires an active membership.');
        }
        return NpsProvider(
          homeId: membership.homeId,
          moodRepository: sl<MoodRepository>(),
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.explore,
      name: 'explore',
      builder: (_, __) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Explore requires an active membership.');
        }
        return const ExploreScreen();
      },
    ),
    _RouteSpec(
      path: AppRoutes.hub,
      name: 'hub',
      builder: (_, __) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Hub requires an active membership.');
        }
        return HubProvider(
          homeId: membership.homeId,
          homeRepository: sl<HomeRepository>(),
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.harmony,
      name: 'harmony',
      builder: (_, __) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Harmony requires an active membership.');
        }
        return HarmonyProvider(
          homeId: membership.homeId,
          moodRepository: sl<MoodRepository>(),
          child: HarmonyPage(homeId: membership.homeId),
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.gratitudeWall,
      name: 'gratitudeWall',
      builder: (_, __) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Gratitude wall requires an active membership.');
        }
        return GratitudeWallProvider(
          homeId: membership.homeId,
          moodRepository: sl<MoodRepository>(),
          homeRepository: sl<HomeRepository>(),
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.flow,
      name: 'flow',
      builder: (_, state) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Flow routes require an active membership.');
        }
        final filter = FlowListFilter.fromQueryParam(
          state.uri.queryParameters['filter'],
        );
        final scope = state.uri.queryParameters['scope'];
        final showOnlyMine = scope == 'mine';
        return FlowListProvider(
          homeId: membership.homeId,
          choresRepository: sl<ChoresRepository>(),
          homeRepository: sl<HomeRepository>(),
          filter: filter,
          currentUserId: membership.userId,
          showOnlyCurrentUser: showOnlyMine,
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.flowChoreCreate,
      name: 'flowChoreCreate',
      builder: (_, __) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Flow routes require an active membership.');
        }
        return FlowChoreProvider(
          homeId: membership.homeId,
          choresRepository: sl<ChoresRepository>(),
          homeRepository: sl<HomeRepository>(),
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.flowChoreEdit,
      name: 'flowChoreEdit',
      builder: (_, state) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Flow routes require an active membership.');
        }
        final choreId = state.pathParameters['choreId']!;
        return FlowChoreProvider(
          homeId: membership.homeId,
          choresRepository: sl<ChoresRepository>(),
          homeRepository: sl<HomeRepository>(),
          choreId: choreId,
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.flowChoreDetail,
      name: 'flowChoreDetail',
      builder: (_, state) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Flow routes require an active membership.');
        }
        final choreId = state.pathParameters['choreId']!;
        return FlowChoreDetailProvider(
          homeId: membership.homeId,
          choreId: choreId,
          choresRepository: sl<ChoresRepository>(),
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.shareCreatedList,
      name: 'shareCreatedList',
      builder: (_, state) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Share routes require an active membership.');
        }
        final draftsOnly = state.extra is bool ? state.extra as bool : false;
        return ShareCreatedListProvider(
          homeId: membership.homeId,
          expensesRepository: sl<ExpensesRepository>(),
          draftsOnly: draftsOnly,
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.shareCreate,
      name: 'shareCreate',
      builder: (_, __) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Share routes require an active membership.');
        }
        return ShareCreateProvider(
          homeId: membership.homeId,
          expensesRepository: sl<ExpensesRepository>(),
          homeRepository: sl<HomeRepository>(),
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.shareDraftEdit,
      name: 'shareDraftEdit',
      builder: (_, state) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError('Share routes require an active membership.');
        }
        final expenseId = state.pathParameters['expenseId']!;
        final args = state.extra as ShareEditRouteArgs?;
        return ShareEditProvider(
          homeId: membership.homeId,
          expenseId: expenseId,
          expensesRepository: sl<ExpensesRepository>(),
          homeRepository: sl<HomeRepository>(),
          allowDelete: args?.allowDelete ?? false,
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.profileSettings,
      name: 'profileSettings',
      builder: (_, state) {
        final args = state.extra as ProfileSettingsRouteArgs?;
        final membership = authBloc.state.membership;
        final homeId = args?.homeId ?? membership?.homeId;
        if (homeId == null) {
          throw StateError('Profile settings requires an active membership.');
        }
        return ProfileSettingsProvider(
          homeId: homeId,
          initialDisplayName: args?.displayName,
          initialAvatarUrl: args?.avatarUrl,
        );
      },
    ),
    _RouteSpec(
      path: AppRoutes.connectionSettings,
      name: 'connectionSettings',
      builder: (_, __) {
        final membership = authBloc.state.membership;
        if (membership == null) {
          throw StateError(
            'Connection settings requires an active membership.',
          );
        }
        return ConnectionSettingsProvider();
      },
    ),
    _RouteSpec(
      path: AppRoutes.profileIdentity,
      name: 'profileIdentity',
      builder: (_, state) {
        final args = state.extra as ProfileIdentityRouteArgs?;
        final membership = authBloc.state.membership;
        final homeId = args?.homeId ?? membership?.homeId;
        if (homeId == null) {
          throw StateError('Profile identity requires an active membership.');
        }
        return ProfileIdentityProvider(
          homeId: homeId,
          initialUsername: args?.initialUsername,
          initialAvatarStoragePath: args?.initialAvatarStoragePath,
          initialAvatarUrl: args?.initialAvatarUrl,
        );
      },
    ),
  ];

  return [
    ...specs.map(
      (spec) => GoRoute(
        path: spec.path,
        name: spec.name,
        builder: spec.builder,
      ),
    ),
    ...dynamicSpecs.map(
      (spec) => GoRoute(
        path: spec.path,
        name: spec.name,
        builder: spec.builder,
      ),
    ),
  ];
}
