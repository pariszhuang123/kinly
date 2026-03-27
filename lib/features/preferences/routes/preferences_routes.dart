import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/preferences/ui/preference_onboarding_provider.dart';
import 'package:kinly/features/preferences/routes/preference_onboarding_args.dart';
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
        final args = _onboardingArgsFromExtra(state.extra);
        return PreferenceOnboardingProvider(
          key:
              args?.entrySource == null
                  ? null
                  : ValueKey('preference_onboarding_${args!.entrySource}'),
          repository: sl<PreferenceReportsRepository>(),
          userId: membership.userId,
          homeId: membership.homeId,
          initialResponses: args?.initialResponses ?? const <String, int>{},
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
                : extra == true || (extra is Map && extra['showConfetti'] == true);
        bool canEdit = true;
        bool showDoneCta = true;
        if (extra is Map) {
          final canEditOverride = extra['canEdit'] as bool?;
          if (canEditOverride != null) {
            canEdit = canEditOverride;
          }
          final showDoneOverride = extra['showDoneCta'] as bool?;
          if (showDoneOverride != null) {
            showDoneCta = showDoneOverride;
          }
        }
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
          canEdit: canEdit,
          showDoneCta: showDoneCta,
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
          return routeFallback('preferenceReportView');
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
          return routeFallback('preferenceReportSectionEdit');
        }
        return PreferenceReportSectionScreen(args: args);
      },
    ),
  ];
}

String? _entrySourceFromExtra(Object? extra) {
  if (extra is PreferenceOnboardingArgs) {
    return extra.entrySource;
  }
  if (extra is Map && extra['entrySource'] is String) {
    return extra['entrySource'] as String;
  }
  if (extra is String) return extra;
  return null;
}

PreferenceOnboardingArgs? _onboardingArgsFromExtra(Object? extra) {
  if (extra is PreferenceOnboardingArgs) {
    return extra;
  }
  if (extra is String) {
    return PreferenceOnboardingArgs(entrySource: extra);
  }
  if (extra is! Map<String, Object?>) {
    return null;
  }
  return PreferenceOnboardingArgs(
    initialResponses: _coerceIntMap(extra['initialResponses']),
    entrySource: extra['entrySource'] as String?,
  );
}

Map<String, int> _coerceIntMap(Object? raw) {
  if (raw is! Map) {
    return const <String, int>{};
  }
  final coerced = <String, int>{};
  for (final entry in raw.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key is! String) continue;
    if (value is int) {
      coerced[key] = value;
      continue;
    }
    if (value is num) {
      coerced[key] = value.toInt();
    }
  }
  return coerced;
}
