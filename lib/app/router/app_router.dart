import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/flow/flow.dart';
import 'package:kinly/features/share/share.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/core/onboarding/onboarding.dart';
import 'package:kinly/features/profile_settings/profile_settings.dart';
import 'package:kinly/core/profile/profile_update_notifier.dart';
import 'package:kinly/features/auth/auth.dart';
import 'package:kinly/features/explore/explore.dart';
import 'package:kinly/features/harmony/harmony.dart';
import 'package:kinly/features/home_membership/home_membership.dart';
import 'package:kinly/features/hub/hub.dart';
import 'package:kinly/features/nps/nps.dart';
import 'package:kinly/features/splash/splash.dart';
import 'package:kinly/features/today/today.dart';
import 'package:kinly/features/version_gating/version_gating.dart';
import 'package:kinly/features/welcome/welcome.dart';

import 'navigation_intents.dart';

part 'app_router_redirects.dart';
part 'app_router_routes.dart';

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
  static const connectionSettings = '/settings/profile/connection';
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
    redirect:
        (context, state) => _redirect(
          state: state,
          authBloc: authBloc,
          appVersionCubit: appVersionCubit,
        ),
    routes: _buildRoutes(authBloc),
  );
}
