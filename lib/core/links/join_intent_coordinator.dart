import 'dart:async';

import 'package:kinly/contracts/homes/enums/join_outcome.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/core/auth/enums/auth_status.dart';
import 'package:kinly/core/logging/logger.dart';

import 'invite_code_parser.dart';
import 'pending_join_intent_storage.dart';
import 'pending_join_intent.dart';
import 'enums/join_intent_navigator.dart';

class JoinIntentResult {
  const JoinIntentResult({required this.navigation, this.blockedRequestId});

  final JoinIntentNavigation navigation;
  final String? blockedRequestId;
}

/// Handles intake, persistence, and resolution of invite join intents.
class JoinIntentCoordinator {
  JoinIntentCoordinator({
    required PendingJoinIntentStorage storage,
    required InviteCodeParser parser,
    required HomeRepository homeRepository,
    required Logger logger,
  }) : _storage = storage,
       _parser = parser,
       _homeRepository = homeRepository,
       _logger = logger;

  final PendingJoinIntentStorage _storage;
  final InviteCodeParser _parser;
  final HomeRepository _homeRepository;
  final Logger _logger;

  bool _resolving = false;

  final _intentCapturedController = StreamController<void>.broadcast();

  /// Fires when a new invite intent is captured and stored.
  /// Subscribers should call [handleAuthState] to resolve the intent.
  Stream<void> get onIntentCaptured => _intentCapturedController.stream;

  void dispose() {
    _intentCapturedController.close();
  }

  /// Parse + validate + persist the intent. Returns true if stored.
  Future<bool> capture(Uri uri) async {
    final parsed = _parser.parse(uri);
    if (parsed == null) {
      await _storage.clear();
      return false;
    }

    final intent = parsed.copyWith(
      source: parsed.source ?? 'web_join',
      receivedAt: DateTime.now().toUtc(),
    );
    final stored = await _storeIntent(intent);
    if (stored) {
      _intentCapturedController.add(null);
    }
    return stored;
  }

  /// Parse install referrer (Android Play Store deferred deep link).
  /// Accepts `kinly_invite_code` or `kinly_invite` keys.
  Future<bool> captureInstallReferrer(String? referrer) async {
    if (referrer == null || referrer.trim().isEmpty) return false;
    Map<String, String> params;
    try {
      params = Uri.splitQueryString(referrer);
    } catch (_) {
      return false;
    }

    final code = params['kinly_invite_code'] ?? params['kinly_invite'];
    if (code == null || !_parser.isValid(code)) return false;

    final intent = PendingJoinIntent(
      inviteCode: code.trim().toUpperCase(),
      receivedAt: DateTime.now().toUtc(),
      source: 'android_install_referrer',
    );
    return _storeIntent(intent);
  }

  /// Manual confirm path (iOS fallback). Accepts raw invite code or full URL.
  Future<bool> captureManualEntry(String input) async {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return false;

    Uri? uri = Uri.tryParse(trimmed);
    if (uri == null || (uri.scheme.isEmpty && !trimmed.contains('/'))) {
      uri = Uri(
        scheme: 'kinly',
        host: 'manual',
        queryParameters: {'code': trimmed},
      );
    }

    final parsed = _parser.parse(uri);
    if (parsed == null) return false;

    final intent = parsed.copyWith(
      source: 'ios_manual_confirm',
      receivedAt: DateTime.now().toUtc(),
    );
    return _storeIntent(intent);
  }

  Future<void> clear() => _storage.clear();

  /// Binds pending intent to the current user and resolves when eligible.
  ///
  /// Returns a navigation directive; navigation execution is left to caller.
  Future<JoinIntentResult> handleAuthState({
    required AuthStatus authStatus,
    required AuthMembershipStatus membershipStatus,
    required String? userId,
  }) async {
    if (authStatus != AuthStatus.authenticated) {
      return const JoinIntentResult(navigation: JoinIntentNavigation.none);
    }

    if (membershipStatus == AuthMembershipStatus.unknown) {
      return const JoinIntentResult(navigation: JoinIntentNavigation.none);
    }

    final pending = await _storage.load();
    if (pending == null) {
      return const JoinIntentResult(navigation: JoinIntentNavigation.none);
    }

    if (pending.userId != null && pending.userId != userId) {
      await _storage.clear();
      return const JoinIntentResult(navigation: JoinIntentNavigation.none);
    }

    final bound = pending.userId == null ? pending.bindUser(userId) : pending;
    if (bound.userId != pending.userId) {
      await _storage.save(bound);
    }

    if (membershipStatus == AuthMembershipStatus.active) {
      await _storage.clear();
      return const JoinIntentResult(navigation: JoinIntentNavigation.today);
    }

    if (_resolving) {
      return const JoinIntentResult(navigation: JoinIntentNavigation.none);
    }

    _resolving = true;
    try {
      final result = await _homeRepository.joinHome(bound.inviteCode);
      if (result.outcome == JoinOutcome.success) {
        await _storage.clear();
        return const JoinIntentResult(navigation: JoinIntentNavigation.today);
      }

      // Blocked (member cap)
      await _storage.clear();
      return const JoinIntentResult(navigation: JoinIntentNavigation.blocked);
    } catch (error, stackTrace) {
      _logger.warn(
        'Join intent resolution failed: $error',
        tag: 'JoinIntent',
        error: error,
        stackTrace: stackTrace,
      );
      await _storage.clear();
      final destination =
          membershipStatus == AuthMembershipStatus.active
              ? JoinIntentNavigation.today
              : JoinIntentNavigation.start;
      return JoinIntentResult(navigation: destination);
    } finally {
      _resolving = false;
    }
  }

  Future<bool> _storeIntent(PendingJoinIntent intent) async {
    final normalized = intent.copyWith(
      inviteCode: intent.inviteCode.trim().toUpperCase(),
      receivedAt: intent.receivedAt.toUtc(),
      source: intent.source ?? 'web_join',
    );

    final existing = await _storage.load();
    if (existing != null) {
      if (existing.inviteCode == normalized.inviteCode) {
        return true;
      }
      if (_priorityForSource(existing.source) >
          _priorityForSource(normalized.source)) {
        return false;
      }
    }

    await _storage.save(normalized);
    return true;
  }

  int _priorityForSource(String? source) {
    switch (source) {
      case 'android_install_referrer':
        return 2;
      case 'ios_manual_confirm':
        return 1;
      default:
        return 3; // platform-delivered deep link or web_join
    }
  }
}
