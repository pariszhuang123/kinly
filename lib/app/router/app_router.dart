import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/profile/profile_update_notifier.dart';
import 'package:kinly/data/repositories/chores_repository.dart';
import 'package:kinly/data/repositories/expenses_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/data/repositories/mood_repository.dart';
import 'package:kinly/data/repositories/onboarding_repository.dart';
import 'package:kinly/data/repositories/profile_repository.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/explore/ui/explore_screen.dart';
import 'package:kinly/features/flow/ui/flow_chore_detail/flow_chore_detail_provider.dart';
import 'package:kinly/features/flow/ui/flow_chore_provider.dart';
import 'package:kinly/features/flow/ui/flow_list_filter.dart';
import 'package:kinly/features/flow/ui/flow_list_provider.dart';
import 'package:kinly/features/harmony/ui/gratitude_wall/gratitude_wall_provider.dart';
import 'package:kinly/features/harmony/ui/harmony_page.dart';
import 'package:kinly/features/harmony/ui/harmony_provider.dart';
import 'package:kinly/features/home_membership/join/ui/join_home_screen.dart';
import 'package:kinly/features/home_membership/start/ui/start_home_provider.dart';
import 'package:kinly/features/hub/ui/hub_provider.dart';
import 'package:kinly/features/nps/ui/nps_provider.dart';
import 'package:kinly/features/profile_settings/connection/ui/connection_settings_provider.dart';
import 'package:kinly/features/profile_settings/edit/profile_identity_provider.dart';
import 'package:kinly/features/profile_settings/ui/profile_settings_provider.dart';
import 'package:kinly/features/share/ui/share_create/share_create_provider.dart';
import 'package:kinly/features/share/ui/share_created_list/share_created_list_provider.dart';
import 'package:kinly/features/share/ui/share_edit_provider.dart';
import 'package:kinly/features/share/ui/share_edit_route_args.dart';
import 'package:kinly/features/splash/ui/splash_screen.dart';
import 'package:kinly/features/today/ui/today_provider.dart';
import 'package:kinly/features/version_gating/bloc/app_version_cubit.dart';
import 'package:kinly/features/version_gating/ui/force_update_screen.dart';
import 'package:kinly/features/welcome/ui/welcome_screen.dart';

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
