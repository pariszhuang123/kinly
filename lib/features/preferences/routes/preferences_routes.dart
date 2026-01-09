import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/preferences/ui/preference_onboarding_provider.dart';
import 'package:kinly/features/preferences/ui/preference_report_edit_provider.dart';
import 'package:kinly/features/preferences/ui/preference_report_provider.dart';
import 'package:kinly/features/preferences/ui/preference_report_section_route_args.dart';
import 'package:kinly/features/preferences/ui/preference_report_section_screen.dart';

class PreferenceRouteContext {
  const PreferenceRouteContext({required this.homeId, required this.userId});

  final String homeId;
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
      builder: (_, __) {
        return PreferenceOnboardingProvider(
          repository: sl<PreferenceReportsRepository>(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.preferenceReport,
      name: AppRouteNames.preferenceReport,
      builder: (_, __) {
        final membership = resolveContext();
        return PreferenceReportProvider(
          homeId: membership.homeId,
          subjectUserId: membership.userId,
          repository: sl<PreferenceReportsRepository>(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.preferenceReportEdit,
      name: AppRouteNames.preferenceReportEdit,
      builder: (_, __) {
        final membership = resolveContext();
        return PreferenceReportEditProvider(
          homeId: membership.homeId,
          subjectUserId: membership.userId,
          repository: sl<PreferenceReportsRepository>(),
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
