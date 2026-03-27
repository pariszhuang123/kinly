import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/homes/ports/fit_check_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/fit_check/ui/fit_check_attach_provider.dart';
import 'package:kinly/features/fit_check/ui/fit_check_briefing_provider.dart';
import 'package:kinly/features/fit_check/ui/fit_check_claim_provider.dart';
import 'package:kinly/features/fit_check/ui/fit_check_inbox_provider.dart';

List<GoRoute> buildFitCheckRoutes() {
  return [
    GoRoute(
      path: AppRoutePaths.fitCheckClaim,
      name: AppRouteNames.fitCheckClaim,
      builder: (_, state) {
        return FitCheckClaimProvider(
          repository: sl<FitCheckRepository>(),
          claimToken: state.uri.queryParameters['claimToken'] ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.fitCheckAttach,
      name: AppRouteNames.fitCheckAttach,
      builder: (_, state) {
        final draftId = state.pathParameters['draftId'];
        if (draftId == null || draftId.isEmpty) {
          return routeFallback('fitCheckAttach', state: state);
        }
        final homeId = state.uri.queryParameters['homeId'];
        return FitCheckAttachProvider(
          repository: sl<FitCheckRepository>(),
          draftId: draftId,
          homeId: homeId,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.fitCheckInbox,
      name: AppRouteNames.fitCheckInbox,
      builder: (_, state) {
        final draftId = state.pathParameters['draftId'];
        if (draftId == null || draftId.isEmpty) {
          return routeFallback('fitCheckInbox', state: state);
        }
        return FitCheckInboxProvider(
          repository: sl<FitCheckRepository>(),
          draftId: draftId,
          locale: _localeBase(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.fitCheckBriefing,
      name: AppRouteNames.fitCheckBriefing,
      builder: (_, state) {
        final draftId = state.pathParameters['draftId'];
        final submissionId = state.pathParameters['submissionId'];
        if (draftId == null ||
            draftId.isEmpty ||
            submissionId == null ||
            submissionId.isEmpty) {
          return routeFallback('fitCheckBriefing', state: state);
        }
        return FitCheckBriefingProvider(
          repository: sl<FitCheckRepository>(),
          submissionId: submissionId,
          locale: _localeBase(),
        );
      },
    ),
  ];
}

String _localeBase() {
  final tag = WidgetsBinding.instance.platformDispatcher.locale.toLanguageTag();
  final parts = tag.split('-');
  if (parts.isEmpty || parts.first.isEmpty) return 'en';
  return parts.first.toLowerCase();
}
