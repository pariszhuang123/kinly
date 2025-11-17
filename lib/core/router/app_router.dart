import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/chores_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../features/today/ui/today_provider.dart';
import '../../features/home_membership/start/ui/start_home_provider.dart';
import '../../features/welcome/ui/welcome_screen.dart';
import '../../features/home_membership/join/ui/join_home_screen.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import 'navigation_intents.dart';
import '../di/locator.dart';

class AppRoutes {
  static const welcome = '/';
  static const start = '/start';
  static const create = '/create';
  static const join = '/join';
  static const today = '/today';
}

GoRouter createRouter({
  required AuthBloc authBloc,
  required Listenable refreshListenable,
}) {
  return GoRouter(
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final uri = state.uri;
      final goingTo = uri.path;
      final isWelcome = goingTo == AppRoutes.welcome;

      if (!isLoggedIn) {
        final segs = uri.pathSegments;
        if (segs.isNotEmpty && segs.first == 'join' && segs.length >= 2) {
          NavigationIntents.setPendingJoinCode(segs[1]);
        }
        if (!isWelcome) return AppRoutes.welcome;
        return null;
      }

      final membershipStatus = authState.membershipStatus;
      final membershipKnown = membershipStatus != AuthMembershipStatus.unknown;
      if (!membershipKnown) {
        return null; // wait until membership resolved
      }
      final hasMembership = membershipStatus == AuthMembershipStatus.active;

      if (isWelcome) {
        return hasMembership ? AppRoutes.today : AppRoutes.start;
      }

      if (goingTo == AppRoutes.today && !hasMembership) {
        return AppRoutes.start;
      }

      return null;
    },
    routes: <RouteBase>[
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
          );
        },
      ),
    ],
  );
}
