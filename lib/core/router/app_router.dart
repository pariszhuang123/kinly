import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/chores_repository.dart';
import '../../data/repositories/expenses_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/home_repository.dart';
import '../../features/today/ui/today_provider.dart';
import '../../features/flow/ui/flow_chore_detail/flow_chore_detail_provider.dart';
import '../../features/flow/ui/flow_chore_provider.dart';
import '../../features/flow/ui/flow_list_provider.dart';
import '../../features/explore/ui/explore_screen.dart';
import '../../features/home_membership/start/ui/start_home_provider.dart';
import '../../features/welcome/ui/welcome_screen.dart';
import '../../features/home_membership/join/ui/join_home_screen.dart';
import '../../features/hub/ui/hub_provider.dart';
import '../../features/flow/ui/flow_list_filter.dart';
import '../../features/profile_settings/ui/profile_settings_provider.dart';
import '../../features/profile_settings/edit/profile_identity_provider.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import 'navigation_intents.dart';
import '../di/locator.dart';
import '../profile/profile_update_notifier.dart';

import '../../features/splash/ui/splash_screen.dart';
import '../../features/version_gating/bloc/app_version_cubit.dart';
import '../../features/version_gating/ui/force_update_screen.dart';
import '../../features/share/ui/share_create/share_create_provider.dart';
import '../../features/share/ui/share_created_list/share_created_list_provider.dart';
import '../../features/share/ui/share_edit_provider.dart';
import '../../features/share/ui/share_edit_route_args.dart';
import '../../features/harmony/ui/harmony_provider.dart';
import '../../features/harmony/ui/harmony_page.dart';
import '../../features/harmony/ui/gratitude_wall/gratitude_wall_provider.dart';
import '../../data/repositories/mood_repository.dart';
import '../../features/nps/ui/nps_provider.dart';

class AppRoutes {
  static const splash = '/';
  static const forceUpdate = '/force-update';
  static const welcome = '/welcome';
  static const start = '/start';
  static const create = '/create';
  static const join = '/join';
  static const today = '/today';
  static const hub = '/hub';
  static const explore = '/explore';
  static const flow = '/flow';
  static const flowChoreCreate = '/flow/chore/new';
  static const flowChoreEdit = '/flow/chore/:choreId';
  static const flowChoreDetail = '/flow/chore/:choreId/detail';
  static const shareCreate = '/share/new';
  static const shareDraftEdit = '/share/:expenseId/edit';
  static const shareCreatedList = '/share/created';
  static const profileSettings = '/settings/profile';
  static const profileIdentity = '/settings/profile/identity';
  static const harmony = '/harmony';
  static const gratitudeWall = '/gratitude-wall';
  static const nps = '/nps';

  static String flowChoreEditPath(String choreId) => '/flow/chore/$choreId';
  static String flowChoreDetailPath(String choreId) =>
      '/flow/chore/$choreId/detail';
  static String shareDraftEditPath(String expenseId) =>
      '/share/$expenseId/edit';
}

GoRouter createRouter({
  required AuthBloc authBloc,
  required AppVersionCubit appVersionCubit,
  required Listenable refreshListenable,
}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authState = authBloc.state;
      final authStatus = authState.status;
      final isLoggedIn = authStatus == AuthStatus.authenticated;
      final uri = state.uri;
      final goingTo = uri.path;
      final isForceUpdate = goingTo == AppRoutes.forceUpdate;
      final forceUpdateRequired =
          appVersionCubit.state.status == AppVersionStatus.hardBlocked;
      if (forceUpdateRequired && !isForceUpdate) {
        return AppRoutes.forceUpdate;
      }
      if (!forceUpdateRequired && isForceUpdate) {
        return AppRoutes.splash;
      }
      final isSplash = goingTo == AppRoutes.splash;
      final isWelcome = goingTo == AppRoutes.welcome;

      if (authStatus == AuthStatus.unknown) {
        return isSplash ? null : AppRoutes.splash;
      }

      if (!isLoggedIn) {
        final segs = uri.pathSegments;
        if (segs.isNotEmpty && segs.first == 'join' && segs.length >= 2) {
          NavigationIntents.setPendingJoinCode(segs[1]);
        }
        if (isSplash) return AppRoutes.welcome;
        if (!isWelcome) return AppRoutes.welcome;
        return null;
      }

      final membershipStatus = authState.membershipStatus;
      final membershipKnown = membershipStatus != AuthMembershipStatus.unknown;
      if (!membershipKnown) {
        return isSplash ? null : AppRoutes.splash;
      }
      final hasMembership = membershipStatus == AuthMembershipStatus.active;

      if (isSplash) {
        return hasMembership ? AppRoutes.today : AppRoutes.start;
      }

      if (isWelcome) {
        return hasMembership ? AppRoutes.today : AppRoutes.start;
      }

      if (goingTo == AppRoutes.start && hasMembership) {
        return AppRoutes.today;
      }

      if (goingTo == AppRoutes.today && !hasMembership) {
        return AppRoutes.start;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.forceUpdate,
        name: 'forceUpdate',
        builder: (context, state) => const ForceUpdateScreen(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.start,
        name: 'start',
        builder: (context, state) => const StartHomeProvider(),
      ),
      GoRoute(
        path: AppRoutes.join,
        name: 'join',
        builder: (context, state) => const JoinHomeScreen(),
      ),
      GoRoute(
        path: '/join/:code',
        name: 'joinWithCode',
        builder:
            (context, state) =>
                JoinHomeScreen(initialCode: state.pathParameters['code']),
      ),
      GoRoute(
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
            profileUpdateNotifier: sl<ProfileUpdateNotifier>(),
          );
        },
      ),
      GoRoute(
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
      GoRoute(
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
      GoRoute(
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
      GoRoute(
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
      GoRoute(
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
          );
        },
      ),
      GoRoute(
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
          return FlowListProvider(
            homeId: membership.homeId,
            choresRepository: sl<ChoresRepository>(),
            homeRepository: sl<HomeRepository>(),
            filter: filter,
          );
        },
      ),
      GoRoute(
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
      GoRoute(
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
      GoRoute(
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
      GoRoute(
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
      GoRoute(
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
      GoRoute(
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
      GoRoute(
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
      GoRoute(
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
    ],
  );
}
