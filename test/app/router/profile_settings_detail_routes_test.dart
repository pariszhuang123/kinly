import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/contracts/profile_settings/profile_shared_unit_create_route_args.dart';
import 'package:kinly/features/profile_settings/routes/profile_settings_routes.dart';
import 'package:kinly/features/profile_settings/shared_unit_create/profile_shared_unit_create_screen.dart';
import 'package:kinly/features/profile_settings/shared_unit_join/profile_shared_unit_join_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockHomeUnitsRepository extends Mock implements HomeUnitsRepository {}

class _FakeLogger extends Logger {
  @override
  void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {}
}

void main() {
  late _MockHomeUnitsRepository homeUnitsRepository;

  setUp(() {
    homeUnitsRepository = _MockHomeUnitsRepository();
    when(
      () => homeUnitsRepository.listCreateSharedUnitCandidates(
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async => const []);
    when(
      () => homeUnitsRepository.listJoinableSharedUnits(
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async => const []);

    if (sl.isRegistered<HomeUnitsRepository>()) {
      sl.unregister<HomeUnitsRepository>();
    }
    if (sl.isRegistered<Logger>()) {
      sl.unregister<Logger>();
    }
    sl.registerSingleton<HomeUnitsRepository>(homeUnitsRepository);
    sl.registerSingleton<Logger>(_FakeLogger());
  });

  tearDown(() {
    if (sl.isRegistered<HomeUnitsRepository>()) {
      sl.unregister<HomeUnitsRepository>();
    }
    if (sl.isRegistered<Logger>()) {
      sl.unregister<Logger>();
    }
  });

  MaterialApp routerApp(GoRouter router) {
    return MaterialApp.router(
      routerConfig: router,
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  testWidgets('join route uses resolved home context', (tester) async {
    final router = GoRouter(
      initialLocation: '/settings/profile/shared-unit/join',
      routes: [
        ...buildProfileSettingsDetailRoutes(
          resolveContext:
              () => const ProfileSettingsDetailRouteContext(homeId: 'home-1'),
        ),
        GoRoute(
          path: '/today',
          name: AppRouteNames.today,
          builder: (_, __) => const Scaffold(body: Text('Today')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(routerApp(router));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileSharedUnitJoinScreen), findsOneWidget);
    verify(
      () => homeUnitsRepository.listJoinableSharedUnits(homeId: 'home-1'),
    ).called(1);
  });

  testWidgets('create route falls back when args are missing', (tester) async {
    final router = GoRouter(
      initialLocation: '/settings/profile/shared-unit/create',
      routes: [
        ...buildProfileSettingsDetailRoutes(resolveContext: () => null),
        GoRoute(
          path: '/today',
          name: AppRouteNames.today,
          builder: (_, __) => const Scaffold(body: Text('Today')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(routerApp(router));
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('create route builds provider when args are present', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        AppRouteNames.profileSharedUnitCreate,
                        extra: const ProfileSharedUnitCreateRouteArgs(
                          homeId: 'home-1',
                          creatorMembershipId: 'membership-1',
                        ),
                      );
                    },
                    child: const Text('open-create'),
                  ),
                ),
              ),
        ),
        ...buildProfileSettingsDetailRoutes(resolveContext: () => null),
        GoRoute(
          path: '/today',
          name: AppRouteNames.today,
          builder: (_, __) => const Scaffold(body: Text('Today')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(routerApp(router));
    await tester.tap(find.text('open-create'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileSharedUnitCreateScreen), findsOneWidget);
    verify(
      () => homeUnitsRepository.listCreateSharedUnitCandidates(
        homeId: 'home-1',
      ),
    ).called(1);
  });
}
