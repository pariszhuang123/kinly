import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:play_install_referrer/play_install_referrer.dart';

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
        await _coordinator!.capture(initialUri);
      }
    } catch (error, stackTrace) {
      _logger.warn(
        'Initial deep link parse failed: $error',
        tag: 'JoinBootstrap',
        error: error,
        stackTrace: stackTrace,
      );
    }

    try {
      _linksSub = appLinks.uriLinkStream.listen((uri) async {
        await _coordinator!.capture(uri);
      }, onError: (Object error, StackTrace stackTrace) {
        _logger.warn(
          'Deep link stream error: $error',
          tag: 'JoinBootstrap',
          error: error,
          stackTrace: stackTrace,
        );
      });
    } catch (error, stackTrace) {
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
      return;
    }

    try {
      final response = await PlayInstallReferrer.installReferrer;
      final referrer = response.installReferrer;
      await _handleReferrer(referrer);
      await storage.markDeferredChecked();
    } catch (error, stackTrace) {
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
      return;
    }
    final stored = await _coordinator!.captureInstallReferrer(referrer);
    if (stored) {
      await sl<PendingJoinIntentStorage>().markDeferredChecked();
    }
  }
}
