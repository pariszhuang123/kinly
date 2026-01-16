import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/preferences/ui/preference_onboarding_provider.dart';
import 'package:kinly/features/preferences/routes/preference_report_navigation_args.dart';
import 'package:kinly/features/preferences/ui/preference_report_edit_provider.dart';
import 'package:kinly/features/preferences/ui/preference_report_provider.dart';
import 'package:kinly/features/preferences/ui/preference_report_section_route_args.dart';
import 'package:kinly/features/preferences/ui/preference_report_section_screen.dart';

class PreferenceRouteContext {
  const PreferenceRouteContext({required this.userId, this.homeId});

  final String? homeId;
  final String userId;
}

typedef PreferenceRouteContextResolver = PreferenceRouteContext Function();

List<GoRoute> buildPreferenceRoutes({
  required PreferenceRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.preferenceOnboarding,
      name: AppRouteNames.preferenceOnboarding,
      builder: (_, state) {
        final membership = resolveContext();
        final entrySource = _entrySourceFromExtra(state.extra);
        return PreferenceOnboardingProvider(
          key:
              entrySource == null
                  ? null
                  : ValueKey('preference_onboarding_$entrySource'),
          repository: sl<PreferenceReportsRepository>(),
          userId: membership.userId,
          homeId: membership.homeId,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.preferenceReport,
      name: AppRouteNames.preferenceReport,
      builder: (_, state) {
        final membership = resolveContext();
        final extra = state.extra;
        final entrySource = _entrySourceFromExtra(extra);
        final showConfetti =
            extra is PreferenceReportNavigationArgs
                ? extra.showConfetti
                : extra == true;
        final initialReport =
            extra is PreferenceReportNavigationArgs
                ? extra.initialReport
                : null;
        return PreferenceReportProvider(
          key:
              entrySource == null
                  ? null
                  : ValueKey('preference_report_$entrySource'),
          homeId: membership.homeId,
          subjectUserId: membership.userId,
          repository: sl<PreferenceReportsRepository>(),
          showConfetti: showConfetti,
          initialReport: initialReport,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.preferenceReportView,
      name: AppRouteNames.preferenceReportView,
      builder: (_, state) {
        final membership = resolveContext();
        final subjectUserId = state.pathParameters['subjectUserId'];
        if (subjectUserId == null || subjectUserId.isEmpty) {
          throw StateError('Preference report view requires subjectUserId.');
        }
        String? displayName;
        String? avatarUrl;
        bool canEdit = subjectUserId == membership.userId;
        final extra = state.extra;
        final entrySource = _entrySourceFromExtra(extra);
        if (extra is Map) {
          displayName = extra['displayName'] as String?;
          avatarUrl = extra['avatarUrl'] as String?;
          final override = extra['canEdit'] as bool?;
          if (override == true) {
            canEdit = true;
          }
        }
        return PreferenceReportProvider(
          key:
              entrySource == null
                  ? null
                  : ValueKey('preference_report_view_$entrySource'),
          homeId: membership.homeId,
          subjectUserId: subjectUserId,
          repository: sl<PreferenceReportsRepository>(),
          canEdit: canEdit,
          popOnDone: true,
          subjectDisplayName: displayName,
          subjectAvatarUrl: avatarUrl,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.preferenceReportEdit,
      name: AppRouteNames.preferenceReportEdit,
      builder: (_, state) {
        final membership = resolveContext();
        String? displayName;
        String? avatarUrl;
        bool canEdit = true;
        String subjectUserId = membership.userId;
        final extra = state.extra;
        final entrySource = _entrySourceFromExtra(extra);
        if (extra is Map) {
          displayName = extra['displayName'] as String?;
          avatarUrl = extra['avatarUrl'] as String?;
          final override = extra['canEdit'] as bool?;
          if (override == false) {
            canEdit = false;
          }
          final subjectOverride = extra['subjectUserId'] as String?;
          if (subjectOverride != null && subjectOverride.isNotEmpty) {
            subjectUserId = subjectOverride;
          }
        }
        return PreferenceReportEditProvider(
          key:
              entrySource == null
                  ? null
                  : ValueKey('preference_report_edit_$entrySource'),
          homeId: membership.homeId,
          subjectUserId: subjectUserId,
          repository: sl<PreferenceReportsRepository>(),
          subjectDisplayName: displayName,
          subjectAvatarUrl: avatarUrl,
          canEdit: canEdit,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.preferenceReportSectionEdit,
      name: AppRouteNames.preferenceReportSectionEdit,
      builder: (_, state) {
        final args = state.extra as PreferenceReportSectionRouteArgs?;
        if (args == null) {
          throw StateError('Preference report section edit requires args.');
        }
        return PreferenceReportSectionScreen(args: args);
      },
    ),
  ];
}

String? _entrySourceFromExtra(Object? extra) {
  if (extra is Map && extra['entrySource'] is String) {
    return extra['entrySource'] as String;
  }
  if (extra is String) return extra;
  return null;
}
