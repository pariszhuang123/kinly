import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/core/di/locator.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/features/flow/flow.dart';
import 'package:kinly/features/share/share.dart';
import 'package:kinly/features/share/ui/share_detail_route_args.dart';
import 'package:kinly/features/share/ui/share_owed_detail_screen.dart';
import 'package:kinly/features/share/ui/share_paid_to_me_detail_screen.dart';
import 'package:kinly/features/home/home.dart';
import 'package:kinly/contracts/onboarding/ports/onboarding_repository.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/contracts/profile_settings/profile_identity_route_args.dart';
import 'package:kinly/contracts/profile_settings/profile_settings_route_args.dart';
import 'package:kinly/foundation/surfaces/profile/profile_provider.dart';
import 'package:kinly/foundation/surfaces/profile/profile_info_hub_webview.dart';
import 'package:kinly/features/profile_settings/profile_settings.dart';
import 'package:kinly/core/notifications/profile_update_notifier.dart';
import 'package:kinly/features/auth/auth.dart';
import 'package:kinly/foundation/surfaces/explore/explore_surface.dart';
import 'package:kinly/features/flow/ui/flow_chore_detail/widgets/flow_chore_expectation_photo_viewer.dart';
import 'package:kinly/features/harmony/harmony.dart';
import 'package:kinly/features/home_membership/home_membership.dart';
import 'package:kinly/foundation/surfaces/hub/hub_provider.dart';
import 'package:kinly/features/nps/nps.dart';
import 'package:kinly/features/paywall/ui/paywall_route_args.dart';
import 'package:kinly/features/paywall/ui/paywall_screen.dart';
import 'package:kinly/features/splash/splash.dart';
import 'package:kinly/foundation/surfaces/today/today_provider.dart';
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
  static const joinBlocked = '/join/blocked';
  static const infoHub = '/settings/profile/info-hub';
  static const today = '/today';
  static const hub = '/hub';
  static const explore = '/explore';
  static const flow = '/flow';
  static const flowChoreCreate = '/flow/chore/new';
  static const flowChoreEdit = '/flow/chore/:choreId';
  static const flowChoreDetail = '/flow/chore/:choreId/detail';
  static const flowChorePhoto = '/flow/chore/photo';
  static const shareCreate = '/share/new';
  static const shareDraftEdit = '/share/:expenseId/edit';
  static const shareCreatedList = '/share/created';
  static const shareOwedDetail = '/share/owed-detail';
  static const sharePaidToMeDetail = '/share/paid-to-me-detail';
  static const profileSettings = '/settings/profile';
  static const profileIdentity = '/settings/profile/identity';
  static const connectionSettings = '/settings/profile/connection';
  static const harmony = '/harmony';
  static const gratitudeWall = '/gratitude-wall';
  static const nps = '/nps';
  static const paywall = '/paywall';

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

