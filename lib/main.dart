import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/config/app_config.dart';
import 'core/di/locator.dart';
import 'core/purchases/revenuecat_initializer.dart';
import 'core/purchases/revenuecat_user_sync.dart';
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

  if (AppConfig.sentryDsn.isEmpty) {
    await _bootstrapApp();
    return;
  }

  try {
    await SentryFlutter.init((options) {
      options.dsn = AppConfig.sentryDsn;
      options.environment = AppConfig.env;
      options.debug = !kReleaseMode;
      options.diagnosticLevel = SentryLevel.debug;
      options.enableAppHangTracking = true;
      options.tracesSampleRate = kReleaseMode ? 1.0 : 0.0;
      options.sendDefaultPii = false;
    }, appRunner: () => _bootstrapApp());
  } catch (error, stackTrace) {
    const DebugLogger().warn(
      'Failed to initialize Sentry: $error',
      tag: 'Bootstrap',
      error: error,
      stackTrace: stackTrace,
    );
    await _bootstrapApp();
  }
}

Future<void> _bootstrapApp() async {
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
  await initRevenueCat(
    sl<Logger>(),
    appUserId: sl<AuthRepository>().current?.userId,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AuthBloc _authBloc;
  late final AppVersionCubit _appVersionCubit;
  late final ConnectivityCubit _connectivityCubit;
  late final GoRouterRefreshStream _routerRefresh;
  late final RouterConfig<Object> _router;
  late final Logger _logger;
  StreamSubscription<AuthState>? _authSub;
  NotificationTokenBootstrap? _tokenBootstrap;

  static const _logTag = 'Bootstrap';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    _authSub = _authBloc.stream.listen(
      (state) => unawaited(_handleAuthState(state)),
    );
    unawaited(_handleAuthState(_authBloc.state));
    unawaited(_startVersionCheck());
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
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_stopNotificationTokenSync());
    _routerRefresh.dispose();
    final authSub = _authSub;
    _authSub = null;
    if (authSub != null) {
      unawaited(authSub.cancel());
    }
    _authBloc.close();
    _appVersionCubit.close();
    _connectivityCubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshNotificationPreferencesFromOs());
    }
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

  Future<void> _handleAuthState(AuthState state) async {
    if (!state.isAuthenticated) {
      await syncRevenueCatUser(_logger, userId: null);
      await _stopNotificationTokenSync();
      return;
    }
    await syncRevenueCatUser(_logger, userId: state.userId);
    await _refreshNotificationPreferencesFromOs();
    await _startNotificationTokenSync();
  }

  Future<void> _startNotificationTokenSync() async {
    if (_tokenBootstrap != null) return;
    if (!sl.isRegistered<NotificationsRepository>() ||
        !sl.isRegistered<NotificationSyncState>()) {
      _logger.debug(
        'Skipping notification token sync; dependencies not registered',
        tag: _logTag,
      );
      return;
    }

    final notificationsRepo = sl<NotificationsRepository>();
    final syncState = sl<NotificationSyncState>();

    _tokenBootstrap = NotificationTokenBootstrap(
      notificationsRepository: notificationsRepo,
      syncProvider: () async => syncState.current,
    );

    await _tokenBootstrap?.start();
  }

  Future<void> _stopNotificationTokenSync() async {
    await _tokenBootstrap?.dispose();
    _tokenBootstrap = null;
  }

  Future<void> _refreshNotificationPreferencesFromOs() async {
    if (!_authBloc.state.isAuthenticated) return;
    if (!sl.isRegistered<NotificationsRepository>() ||
        !sl.isRegistered<NotificationSyncState>()) {
      _logger.debug(
        'Skipping notification prefs refresh; dependencies not registered',
        tag: _logTag,
      );
      return;
    }

    final notificationsRepo = sl<NotificationsRepository>();
    final syncState = sl<NotificationSyncState>();

    final osPermission = await _readOsPermission();
    final locale =
        WidgetsBinding.instance.platformDispatcher.locale.toLanguageTag();
    final timezone = DateTime.now().timeZoneName;
    final platformName = defaultTargetPlatform.name;
    String? deviceToken;
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to read FCM token during prefs refresh: $error',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
      deviceToken = null;
    }

    try {
      final prefs = await notificationsRepo.fetchPreferences(
        timezone: timezone,
        locale: locale,
        osPermission: osPermission,
        deviceToken: deviceToken,
        platform: platformName,
      );

      syncState.setPayload(
        NotificationSyncPayload(
          wantsDaily: prefs.wantsDaily,
          preferredHour: prefs.preferredHour,
          timezone: timezone,
          locale: locale,
          osPermission:
              prefs.osPermission.isNotEmpty ? prefs.osPermission : osPermission,
          platform: platformName,
        ),
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to refresh notification preferences from OS: $error',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<String> _readOsPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return 'allowed';
    if (status.isPermanentlyDenied) return 'blocked';
    if (status.isDenied || status.isRestricted) return 'blocked';
    return 'unknown';
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
