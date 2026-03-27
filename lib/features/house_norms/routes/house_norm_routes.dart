import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/house_norms/routes/house_norm_onboarding_args.dart';
import 'package:kinly/features/house_norms/routes/house_norm_report_navigation_args.dart';
import 'package:kinly/features/house_norms/ui/house_norm_edit_provider.dart';
import 'package:kinly/features/house_norms/ui/house_norm_onboarding_provider.dart';
import 'package:kinly/features/house_norms/ui/house_norm_report_provider.dart';
import 'package:kinly/features/house_norms/ui/house_norm_section_route_args.dart';
import 'package:kinly/features/house_norms/ui/house_norm_section_screen.dart';

class HouseNormRouteContext {
  const HouseNormRouteContext({
    required this.homeId,
    required this.userId,
    required this.isOwner,
  });

  final String homeId;
  final String userId;
  final bool isOwner;
}

typedef HouseNormRouteContextResolver = HouseNormRouteContext? Function();

List<GoRoute> buildHouseNormRoutes({
  required HouseNormRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.houseNormsOnboarding,
      name: AppRouteNames.houseNormsOnboarding,
      builder: (_, state) {
        final args = _onboardingArgs(state.extra);
        final context = resolveContext();
        final homeId = context?.homeId ?? args?.homeIdOverride;
        if (homeId == null) {
          return routeFallback(
            'houseNormsOnboarding',
            state: state,
            reason:
                'active membership missing while House norms onboarding restores',
          );
        }
        return HouseNormOnboardingProvider(
          key:
              args?.entrySource == null
                  ? null
                  : ValueKey('house_norms_onboarding_${args!.entrySource}'),
          repository: sl<HouseNormsRepository>(),
          homeId: homeId,
          locale: _localeBase(),
          initialResponses: args?.initialResponses ?? const <String, int>{},
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.houseNormsReport,
      name: AppRouteNames.houseNormsReport,
      builder: (_, state) {
        final context = resolveContext();
        if (context == null) {
          return routeFallback(
            'houseNormsReport',
            state: state,
            reason: 'active membership missing while House norms report restores',
          );
        }
        final extra = state.extra;
        final args = _reportNavigationArgs(extra);
        return HouseNormReportProvider(
          homeId: context.homeId,
          locale: _localeBase(),
          isOwner: context.isOwner,
          repository: sl<HouseNormsRepository>(),
          showConfetti: args?.showConfetti ?? false,
          initialDocument: args?.initialDocument,
          backRouteName: args?.backRouteName ?? AppRouteNames.today,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.houseNormsEdit,
      name: AppRouteNames.houseNormsEdit,
      builder: (_, state) {
        final context = resolveContext();
        if (context == null) {
          return routeFallback(
            'houseNormsEdit',
            state: state,
            reason: 'active membership missing while House norms edit restores',
          );
        }
        return HouseNormEditProvider(
          homeId: context.homeId,
          locale: _localeBase(),
          isOwner: context.isOwner,
          repository: sl<HouseNormsRepository>(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.houseNormsSectionEdit,
      name: AppRouteNames.houseNormsSectionEdit,
      builder: (_, state) {
        final args = state.extra as HouseNormSectionRouteArgs?;
        if (args == null) {
          return routeFallback('houseNormsSectionEdit');
        }
        return BlocProvider.value(
          value: args.reportCubit,
          child: HouseNormSectionScreen(args: args),
        );
      },
    ),
  ];
}

HouseNormReportNavigationArgs? _reportNavigationArgs(Object? extra) {
  if (extra is HouseNormReportNavigationArgs) {
    return extra;
  }
  if (extra is! Map<String, Object?>) {
    return null;
  }

  return HouseNormReportNavigationArgs(
    showConfetti: extra['showConfetti'] as bool? ?? false,
    backRouteName: extra['backRouteName'] as String?,
  );
}

HouseNormOnboardingArgs? _onboardingArgs(Object? extra) {
  if (extra is HouseNormOnboardingArgs) {
    return extra;
  }
  if (extra is! Map<String, Object?>) {
    return null;
  }
  return HouseNormOnboardingArgs(
    initialResponses: _coerceIntMap(extra['initialResponses']),
    entrySource: extra['entrySource'] as String?,
    homeIdOverride: extra['homeIdOverride'] as String?,
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

String _localeBase() {
  final tag = WidgetsBinding.instance.platformDispatcher.locale.toLanguageTag();
  final parts = tag.split('-');
  if (parts.isEmpty || parts.first.isEmpty) return 'en';
  return parts.first.toLowerCase();
}
