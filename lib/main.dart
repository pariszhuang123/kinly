import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'core/config/app_config.dart';
import 'core/di/locator.dart';
import 'core/router/app_router.dart';
import 'core/router/go_router_refresh_stream.dart';
import 'core/network/connectivity_monitor.dart';
import 'core/supabase/supabase_init.dart';
import 'core/theme/kinly_theme.dart';
import 'core/logging/logger.dart';
import 'core/logging/debug_logger.dart';
import 'data/repositories/app_version_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/home_repository.dart';
import 'data/repositories/notifications_repository.dart';
import 'core/notifications/notification_token_bootstrap.dart';
import 'core/notifications/notification_sync_state.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/offline/bloc/connectivity_cubit.dart';
import 'features/offline/ui/connectivity_gate.dart';
import 'features/version_gating/bloc/app_version_cubit.dart';
import 'generated/l10n.dart';
import 'core/ui/kinly_loader.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
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
  late final Logger _logger;
  NotificationTokenBootstrap? _tokenBootstrap;

  static const _logTag = 'Bootstrap';

  @override
  void initState() {
    super.initState();
    _logger = _resolveLogger();
    final authRepo = sl<AuthRepository>();
    final homeRepo = sl<HomeRepository>();
    final connectivityMonitor = sl<ConnectivityMonitor>();
    final appVersionRepository = sl<AppVersionRepository>();

    _authBloc = AuthBloc(authRepository: authRepo, homeRepository: homeRepo);
    _appVersionCubit = AppVersionCubit(
      repository: appVersionRepository,
      logger: _logger,
    );
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
    unawaited(_startNotificationTokenSync());
  }

  Logger _resolveLogger() {
    if (sl.isRegistered<Logger>()) {
      return sl<Logger>();
    }
    const fallback = DebugLogger();
    sl.registerSingleton<Logger>(fallback);
    return fallback;
  }

  Future<void> _startVersionCheck() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final normalizedVersion = _normalizeVersion(info.version);
      _logger.info(
        'Kinly client version: ${info.version} (normalized: $normalizedVersion)',
        tag: _logTag,
      );
      await _appVersionCubit.checkForUpdates(clientVersion: normalizedVersion);
    } catch (error, stackTrace) {
      _logger.warn(
        'PackageInfo lookup failed: $error',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
      await _appVersionCubit.checkForUpdates(clientVersion: '0.0.0');
    }
  }

  String _normalizeVersion(String version) {
    final match = RegExp(r'^(\d+\.\d+\.\d+)').firstMatch(version);
    if (match != null) {
      final core = match.group(1)!;
      if (core != version) {
        _logger.debug('Normalized version "$version" to "$core"', tag: _logTag);
      }
      return core;
    }
    _logger.warn(
      'Unable to parse version "$version"; defaulting to 0.0.0',
      tag: _logTag,
    );
    return '0.0.0';
  }

  @override
  void dispose() {
    unawaited(_tokenBootstrap?.dispose());
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

  Future<void> _startNotificationTokenSync() async {
    final notificationsRepo = sl<NotificationsRepository>();
    final syncState = sl<NotificationSyncState>();

    _tokenBootstrap = NotificationTokenBootstrap(
      notificationsRepository: notificationsRepo,
      syncProvider: () async => syncState.current,
    );

    await _tokenBootstrap?.start();
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
            const KinlyLoader(size: 56),
            const SizedBox(height: 16),
            Text(S.of(context).bootstrap_initializing(AppConfig.env)),
          ],
        ),
      ),
    );
  }
}
