import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'core/config/app_config.dart';
import 'core/di/locator.dart';
import 'core/forms/form_draft_storage.dart';
import 'app/di/compose.dart';
import 'core/purchases/revenuecat_initializer.dart';
import 'core/purchases/revenuecat_user_sync.dart';
import 'app/router/app_router.dart';
import 'app/router/app_route_names.dart';
import 'app/router/go_router_refresh_stream.dart';
import 'core/network/connectivity_monitor.dart';
import 'core/supabase/supabase_init.dart';
import 'core/logging/logger.dart';
import 'core/logging/debug_logger.dart';
import 'contracts/app_version/ports/app_version_repository.dart';
import 'contracts/auth/ports/auth_repository.dart';
import 'features/home/home.dart';
import 'contracts/profile/ports/profile_repository.dart';
import 'core/notifications/notifications.dart';
import 'core/notifications/authorization_status_mapper.dart';
import 'core/notifications/startup_notification_permission_requester.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/offline/bloc/connectivity_cubit.dart';
import 'features/offline/ui/connectivity_gate.dart';
import 'features/version_gating/bloc/app_version_cubit.dart';
import 'generated/l10n.dart';
import 'core/ui/kinly_loader.dart';
import 'core/time/iana_timezone_resolver.dart';
import 'core/ui/kinly_scaffold.dart';
import 'renderer/material/kinly_app.dart';
import 'core/links/join_intent_coordinator.dart';
import 'core/links/enums/join_intent_navigator.dart';
import 'app/join_intent_bootstrap.dart';

part 'main_lifecycle_helpers.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    // Use hybrid composition to avoid virtual-display crashes on Android 10/11 WebView
    WebViewPlatform.instance = AndroidWebViewPlatform();
  }

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
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  composeDependencies();
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
  final String _appSessionId = DateTime.now()
      .toUtc()
      .microsecondsSinceEpoch
      .toString();
  late final AuthBloc _authBloc;
  late final AppVersionCubit _appVersionCubit;
  late final ConnectivityCubit _connectivityCubit;
  late final GoRouterRefreshStream _routerRefresh;
  late final GoRouter _router;
  late final Logger _logger;
  late final IanaTimezoneResolver _timezoneResolver;
  JoinIntentCoordinator? _joinIntentCoordinator;
  StreamSubscription<AuthState>? _authSub;
  StreamSubscription<void>? _intentCapturedSub;
  NotificationTokenBootstrap? _tokenBootstrap;
  JoinIntentBootstrap? _joinBootstrap;
  late final StartupNotificationPermissionRequester
      _startupNotificationPermissionRequester;
  bool _requestedInitialNotificationPermission = false;
  String? _lastAuthUserId;
  String? _lastHomeId;

  static const _logTag = 'Bootstrap';
  static const _draftLogTag = 'FormDraft';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _logger = _resolveLogger();
    _logger.info('App session started. id=$_appSessionId', tag: _logTag);
    _startupNotificationPermissionRequester =
        StartupNotificationPermissionRequester(logger: _logger, tag: _logTag);
    _installGlobalErrorLogging();
    _timezoneResolver = sl<IanaTimezoneResolver>();
    _joinIntentCoordinator =
        sl.isRegistered<JoinIntentCoordinator>()
            ? sl<JoinIntentCoordinator>()
            : null;
    final authRepo = sl<AuthRepository>();
    final homeRepo = sl<HomeRepository>();
    final profileRepo = sl<ProfileRepository>();
    final connectivityMonitor = sl<ConnectivityMonitor>();
    final appVersionRepository = sl<AppVersionRepository>();

    _authBloc = AuthBloc(
      authRepository: authRepo,
      homeRepository: homeRepo,
      profileRepository: profileRepo,
    );
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
      logger: _logger,
    );
    _authSub = _authBloc.stream.listen(
      (state) => unawaited(_handleAuthState(state)),
    );
    _intentCapturedSub = _joinIntentCoordinator?.onIntentCaptured.listen(
      (_) => unawaited(_handleAuthState(_authBloc.state)),
    );
    _joinBootstrap = JoinIntentBootstrap(
      coordinator: _joinIntentCoordinator,
      logger: _logger,
    );
    unawaited(_initializeJoinIntentAndAuth());
    unawaited(_startVersionCheck());
    unawaited(_requestNotificationPermissionIfNeeded());
  }

  Logger _resolveLogger() {
    if (sl.isRegistered<Logger>()) {
      return sl<Logger>();
    }
    const fallback = DebugLogger();
    sl.registerSingleton<Logger>(fallback);
    return fallback;
  }

  void _installGlobalErrorLogging() {
    FlutterError.onError = (details) {
      _logger.error(
        'Flutter framework error: ${details.exceptionAsString()}',
        tag: _logTag,
        error: details.exception,
        stackTrace: details.stack,
      );
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      _logger.error(
        'Unhandled platform error: $error',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
      return true;
    };
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
    final intentSub = _intentCapturedSub;
    _intentCapturedSub = null;
    if (intentSub != null) {
      unawaited(intentSub.cancel());
    }
    unawaited(_joinBootstrap?.dispose());
    _authBloc.close();
    _appVersionCubit.close();
    _connectivityCubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.debug(
      'Lifecycle state changed to $state (session=$_appSessionId)',
      tag: _logTag,
    );
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
      child: KinlyApp(
        routerConfig: _router,
        builder: (context, child) {
          final resolvedChild = child ?? const _RouterInitializingFallback();
          return ConnectivityGate(child: resolvedChild);
        },
      ),
    );
  }

  Future<void> _handleAuthState(AuthState state) async {
    await _handleAuthStateImpl(this, state);
  }

  Future<void> _initializeJoinIntentAndAuth() async {
    await _joinBootstrap?.init();
    await _handleAuthState(_authBloc.state);
  }

  Future<void> _clearFormDraftsOnLogout({
    required String? previousUserId,
    required String? previousHomeId,
  }) async {
    if (previousUserId != null) {
      await FormDraftStorage.clearPersonalPreferencesDraft(previousUserId);
    }
    if (previousHomeId != null) {
      await FormDraftStorage.clearHouseRulesDraft(previousHomeId);
    }
  }

  Future<void> _applyJoinNavigation(JoinIntentResult result) async {
    await _applyJoinNavigationImpl(this, result);
  }

  bool _shouldApplyJoinNavigation({
    required JoinIntentNavigation navigation,
    required String currentPath,
  }) {
    if (navigation == JoinIntentNavigation.none) {
      return true;
    }
    if (_isJoinBootstrapPath(currentPath)) {
      return true;
    }
    switch (navigation) {
      case JoinIntentNavigation.none:
        return true;
      case JoinIntentNavigation.welcome:
        return currentPath == AppRoutes.welcome;
      case JoinIntentNavigation.start:
        return currentPath == AppRoutes.start;
      case JoinIntentNavigation.today:
        return currentPath == AppRoutes.today;
      case JoinIntentNavigation.blocked:
        return currentPath == AppRoutes.joinBlocked || _isJoinPath(currentPath);
    }
  }

  bool _isJoinBootstrapPath(String path) =>
      path == AppRoutes.splash ||
      path == AppRoutes.welcome ||
      path == AppRoutes.start ||
      path == AppRoutes.join ||
      path == AppRoutes.joinBlocked ||
      _isJoinPath(path);

  bool _isJoinPath(String path) =>
      path == AppRoutes.join || path.startsWith('${AppRoutes.join}/');

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
      logger: _logger,
    );

    await _tokenBootstrap?.start();
  }

  Future<void> _stopNotificationTokenSync() async {
    await _tokenBootstrap?.dispose();
    _tokenBootstrap = null;
  }

  Future<void> _requestNotificationPermissionIfNeeded() async {
    if (_requestedInitialNotificationPermission) return;
    _requestedInitialNotificationPermission = true;
    try {
      await _startupNotificationPermissionRequester.requestIfSupported();
    } catch (error, stackTrace) {
      _logger.warn(
        'Notification permission request failed: $error',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
    }
    await _refreshNotificationPreferencesFromOs();
  }

  Future<void> _refreshNotificationPreferencesFromOs() async {
    await _refreshNotificationPreferencesFromOsImpl(this);
  }

  Future<String> _readOsPermission() async {
    if (Platform.isIOS) {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      return mapAuthorizationStatusToOsPermission(settings.authorizationStatus);
    }

    final status = await Permission.notification.status;
    if (status.isGranted) return 'allowed';
    if (status.isPermanentlyDenied) return 'blocked';
    if (status.isDenied || status.isRestricted) return 'blocked';
    return 'unknown';
  }

  Future<bool> _canReadFcmToken(String osPermission) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return true;
    if (osPermission != 'allowed') return false;
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    return apnsToken != null && apnsToken.isNotEmpty;
  }

  bool _isApnsTokenMissing(Object error) =>
      error.toString().contains('apns-token-not-set');
}

class _RouterInitializingFallback extends StatelessWidget {
  const _RouterInitializingFallback();

  @override
  Widget build(BuildContext context) {
    return KinlyScaffold(
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
