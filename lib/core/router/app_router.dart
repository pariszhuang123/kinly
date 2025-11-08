import 'package:go_router/go_router.dart';
import '../auth/auth_notifier.dart';

import '../../features/welcome/ui/welcome_screen.dart';
import '../../features/home_membership/create/ui/create_home_screen.dart';
import '../../features/home_membership/join/ui/join_home_screen.dart';
import '../../features/today/ui/today_screen.dart';

class AppRoutes {
  static const welcome = '/';
  static const create = '/create';
  static const join = '/join';
  static const today = '/today';
}

GoRouter createRouter({required AuthNotifier auth}) {
  return GoRouter(
    refreshListenable: auth,
    redirect: (context, state) {
      final isLoggedIn = auth.isAuthenticated;
      final goingTo = state.uri.path;
      final isWelcome = goingTo == AppRoutes.welcome;

      if (!isLoggedIn && !isWelcome) {
        return AppRoutes.welcome;
      }
      if (isLoggedIn && isWelcome) {
        return AppRoutes.today;
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
        path: AppRoutes.create,
        name: 'create',
        builder: (context, state) => const CreateHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.join,
        name: 'join',
        builder: (context, state) => const JoinHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.today,
        name: 'today',
        builder: (context, state) => const TodayScreen(),
      ),
    ],
  );
}
