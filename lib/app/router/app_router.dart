import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/features/flow/routes/flow_routes.dart';
import 'package:kinly/features/share/routes/share_routes.dart';
import 'package:kinly/core/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/version_gating/bloc/app_version_cubit.dart';
import 'package:kinly/features/harmony/routes/harmony_routes.dart';
import 'package:kinly/features/home_membership/routes/home_membership_routes.dart';
import 'package:kinly/foundation/surfaces/explore/routes/explore_routes.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_routes.dart';
import 'package:kinly/features/nps/routes/nps_routes.dart';
import 'package:kinly/features/paywall/routes/paywall_routes.dart';
import 'package:kinly/features/splash/routes/splash_routes.dart';
import 'package:kinly/foundation/surfaces/profile/routes/profile_settings_routes.dart';
import 'package:kinly/features/profile_settings/routes/profile_settings_routes.dart';
import 'package:kinly/foundation/surfaces/today/routes/today_routes.dart';
import 'package:kinly/foundation/surfaces/profile/routes/profile_routes.dart';
import 'package:kinly/features/version_gating/routes/version_gating_routes.dart';
import 'package:kinly/features/welcome/routes/welcome_routes.dart';
import 'package:kinly/features/preferences/routes/preferences_routes.dart';
import 'package:kinly/features/harmony/routes/personal_routes.dart';

import 'navigation_intents.dart';

part 'app_router_redirects.dart';
part 'app_router_routes.dart';

class AppRoutes {
  static const splash = AppRoutePaths.splash;
  static const forceUpdate = AppRoutePaths.forceUpdate;
  static const welcome = AppRoutePaths.welcome;
  static const start = AppRoutePaths.start;
  static const join = AppRoutePaths.join;
  static const joinBlocked = AppRoutePaths.joinBlocked;
  static const infoHub = AppRoutePaths.infoHub;
  static const today = AppRoutePaths.today;
  static const hub = AppRoutePaths.hub;
  static const explore = AppRoutePaths.explore;
  static const flow = AppRoutePaths.flow;
  static const flowChoreCreate = AppRoutePaths.flowChoreCreate;
  static const flowChoreEdit = AppRoutePaths.flowChoreEdit;
  static const flowChoreDetail = AppRoutePaths.flowChoreDetail;
  static const flowChorePhoto = AppRoutePaths.flowChorePhoto;
  static const shareCreate = AppRoutePaths.shareCreate;
  static const shareDraftEdit = AppRoutePaths.shareDraftEdit;
  static const shareCreatedList = AppRoutePaths.shareCreatedList;
  static const shareOwedDetail = AppRoutePaths.shareOwedDetail;
  static const sharePaidToMeDetail = AppRoutePaths.sharePaidToMeDetail;
  static const profileSettings = AppRoutePaths.profileSettings;
  static const profileIdentity = AppRoutePaths.profileIdentity;
  static const connectionSettings = AppRoutePaths.connectionSettings;
  static const harmony = AppRoutePaths.harmony;
  static const gratitudeWall = AppRoutePaths.gratitudeWall;
  static const nps = AppRoutePaths.nps;
  static const paywall = AppRoutePaths.paywall;
  static const preferenceOnboarding = AppRoutePaths.preferenceOnboarding;
  static const preferenceReport = AppRoutePaths.preferenceReport;
  static const preferenceReportEdit = AppRoutePaths.preferenceReportEdit;
  static const preferenceReportSectionEdit =
      AppRoutePaths.preferenceReportSectionEdit;
  static const personalMentions = AppRoutePaths.personalMentions;

  static String flowChoreEditPath(String choreId) =>
      '${AppRoutePaths.flow}/chore/$choreId';
  static String flowChoreDetailPath(String choreId) =>
      '${AppRoutePaths.flow}/chore/$choreId/detail';
  static String shareDraftEditPath(String expenseId) =>
      '${AppRoutePaths.shareCreate.replaceAll('/new', '')}/$expenseId/edit';
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
