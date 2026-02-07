import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:play_install_referrer/play_install_referrer.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../core/links/join_intent_coordinator.dart';
import '../core/links/pending_join_intent_storage.dart';
import '../core/logging/logger.dart';
import '../core/di/locator.dart';

/// Handles deep-link intake and deferred install referrer for join intents.
class JoinIntentBootstrap {
  JoinIntentBootstrap({
    required JoinIntentCoordinator? coordinator,
    required Logger logger,
  })  : _coordinator = coordinator,
        _logger = logger;

  final JoinIntentCoordinator? _coordinator;
  final Logger _logger;
  StreamSubscription<Uri>? _linksSub;

  Future<void> init() async {
    if (_coordinator == null) return;
    await _initDeepLinks(appLinks: AppLinks());
    if (Platform.isAndroid) {
      await _checkDeferredInstallReferrer();
    }
    await _captureDebugEvent('join_intent_bootstrap_completed');
  }

  Future<void> dispose() async {
    await _linksSub?.cancel();
    _linksSub = null;
  }

  // Visible for tests
  Future<void> initWith({required AppLinks appLinks}) async {
    if (_coordinator == null) return;
    await _initDeepLinks(appLinks: appLinks);
  }

  Future<void> _initDeepLinks({required AppLinks appLinks}) async {
    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        _addBreadcrumb(
          message: 'Initial deep link received',
          data: {'hasUri': true},
        );
        await _coordinator!.capture(initialUri);
      } else {
        _addBreadcrumb(
          message: 'Initial deep link missing',
          data: {'hasUri': false},
        );
      }
    } catch (error, stackTrace) {
      _addBreadcrumb(
        message: 'Initial deep link parse failed',
        data: {'error': error.toString()},
        level: SentryLevel.warning,
      );
      _logger.warn(
        'Initial deep link parse failed: $error',
        tag: 'JoinBootstrap',
        error: error,
        stackTrace: stackTrace,
      );
    }

    try {
      _linksSub = appLinks.uriLinkStream.listen((uri) async {
        _addBreadcrumb(
          message: 'Deep link stream received',
          data: {'hasUri': true},
        );
        await _coordinator!.capture(uri);
      }, onError: (Object error, StackTrace stackTrace) {
        _addBreadcrumb(
          message: 'Deep link stream error',
          data: {'error': error.toString()},
          level: SentryLevel.warning,
        );
        _logger.warn(
          'Deep link stream error: $error',
          tag: 'JoinBootstrap',
          error: error,
          stackTrace: stackTrace,
        );
      });
    } catch (error, stackTrace) {
      _addBreadcrumb(
        message: 'Deep link stream subscribe failed',
        data: {'error': error.toString()},
        level: SentryLevel.warning,
      );
      _logger.warn(
        'Deep link stream subscribe failed: $error',
        tag: 'JoinBootstrap',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // Visible for tests
  Future<void> handleReferrerForTest(String? referrer) =>
      _handleReferrer(referrer);

  Future<void> _checkDeferredInstallReferrer() async {
    if (_coordinator == null) return;
    final storage = sl<PendingJoinIntentStorage>();
    if (await storage.wasDeferredChecked()) {
      _addBreadcrumb(
        message: 'Deferred referrer already checked',
        data: {'checked': true},
      );
      return;
    }

    try {
      final response = await PlayInstallReferrer.installReferrer;
      final referrer = response.installReferrer;
      _addBreadcrumb(
        message: 'Install referrer read',
        data: {'hasReferrer': referrer?.isNotEmpty == true},
      );
      await _handleReferrer(referrer);
      await storage.markDeferredChecked();
    } catch (error, stackTrace) {
      _addBreadcrumb(
        message: 'Install referrer lookup failed',
        data: {'error': error.toString()},
        level: SentryLevel.warning,
      );
      _logger.warn(
        'Install referrer lookup failed: $error',
        tag: 'JoinBootstrap',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _handleReferrer(String? referrer) async {
    if (referrer == null || referrer.isEmpty) {
      _addBreadcrumb(
        message: 'Install referrer missing',
        data: {'hasReferrer': false},
      );
      await _captureDebugEvent('install_referrer_missing');
      return;
    }
    final stored = await _coordinator!.captureInstallReferrer(referrer);
    _addBreadcrumb(
      message: 'Install referrer handled',
      data: {'stored': stored},
    );
    await _captureDebugEvent(
      'install_referrer_handled',
      data: {'stored': stored},
    );
    if (stored) {
      await sl<PendingJoinIntentStorage>().markDeferredChecked();
    }
  }

  void _addBreadcrumb({
    required String message,
    Map<String, Object?>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    if (!Sentry.isEnabled) return;
    Sentry.addBreadcrumb(
      Breadcrumb(
        category: 'join_intent',
        message: message,
        level: level,
        data: data,
      ),
    );
  }

  Future<void> _captureDebugEvent(
    String name, {
    Map<String, Object?>? data,
  }) async {
    if (!Sentry.isEnabled) return;
    await Sentry.captureMessage(
      'join_intent_debug',
      level: SentryLevel.info,
      withScope: (scope) {
        scope.setTag('join_intent_event', name);
        if (data != null && data.isNotEmpty) {
          scope.setContexts('join_intent', data);
        }
      },
    );
  }
}
