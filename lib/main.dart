import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'core/config/app_config.dart';
import 'core/di/locator.dart';
import 'core/router/app_router.dart';
import 'core/router/go_router_refresh_stream.dart';
import 'core/network/connectivity_monitor.dart';
import 'core/supabase/supabase_init.dart';
import 'core/theme/kinly_theme.dart';
import 'data/repositories/app_version_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/home_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/offline/bloc/connectivity_cubit.dart';
import 'features/offline/ui/connectivity_gate.dart';
import 'features/version_gating/bloc/app_version_cubit.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  AppConfig.validate();
  await initSupabase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final AppVersionCubit _appVersionCubit;
  late final ConnectivityCubit _connectivityCubit;
  late final GoRouterRefreshStream _routerRefresh;
  late final RouterConfig<Object> _router;

  @override
  void initState() {
    super.initState();
    final authRepo = sl<AuthRepository>();
    final homeRepo = sl<HomeRepository>();
    final connectivityMonitor = sl<ConnectivityMonitor>();
    final appVersionRepository = sl<AppVersionRepository>();

    _authBloc = AuthBloc(authRepository: authRepo, homeRepository: homeRepo);
    _appVersionCubit = AppVersionCubit(repository: appVersionRepository);
    _connectivityCubit = ConnectivityCubit(monitor: connectivityMonitor);
    _routerRefresh = GoRouterRefreshStream.multi([
      _authBloc.stream,
      _appVersionCubit.stream,
    ]);
    _router = createRouter(
      authBloc: _authBloc,
      appVersionCubit: _appVersionCubit,
      refreshListenable: _routerRefresh,
    );
    unawaited(_startVersionCheck());
  }

  Future<void> _startVersionCheck() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final normalizedVersion = _normalizeVersion(info.version);
      debugPrint(
        'Kinly client version: ${info.version} (normalized: $normalizedVersion)',
      );
      await _appVersionCubit.checkForUpdates(clientVersion: normalizedVersion);
    } catch (error) {
      debugPrint('PackageInfo lookup failed: $error');
      await _appVersionCubit.checkForUpdates(clientVersion: '0.0.0');
    }
  }

  String _normalizeVersion(String version) {
    final match = RegExp(r'^(\d+\.\d+\.\d+)').firstMatch(version);
    if (match != null) {
      final core = match.group(1)!;
      if (core != version) {
        debugPrint('Normalized version "$version" to "$core"');
      }
      return core;
    }
    debugPrint('Unable to parse version "$version"; defaulting to 0.0.0');
    return '0.0.0';
  }

  @override
  void dispose() {
    _routerRefresh.dispose();
    _authBloc.close();
    _appVersionCubit.close();
    _connectivityCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _appVersionCubit),
        BlocProvider.value(value: _connectivityCubit),
      ],
      child: MaterialApp.router(
        onGenerateTitle: (context) => S.of(context).app_title,
        routerConfig: _router,
        builder: (context, child) {
          final resolvedChild = child ?? const _RouterInitializingFallback();
          return ConnectivityGate(child: resolvedChild);
        },
        theme: buildKinlyTheme(Brightness.light),
        darkTheme: buildKinlyTheme(Brightness.dark),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}

class _RouterInitializingFallback extends StatelessWidget {
  const _RouterInitializingFallback();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Starting Kinly (${AppConfig.env})'),
          ],
        ),
      ),
    );
  }
}
