import 'dart:async';

import 'package:kinly/contracts/homes/enums/join_outcome.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/core/auth/enums/auth_status.dart';
import 'package:kinly/core/logging/logger.dart';

import 'invite_code_parser.dart';
import 'pending_join_intent_storage.dart';
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

  /// Parse + validate + persist the intent. Returns true if stored.
  Future<bool> capture(Uri uri) async {
    final parsed = _parser.parse(uri);
    if (parsed == null) {
      await _storage.clear();
      return false;
    }
    final existing = await _storage.load();
    if (existing != null && existing.inviteCode == parsed.inviteCode) {
      // dedupe duplicate deliveries
      return true;
    }
    await _storage.save(parsed);
    return true;
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
      await _storage.clear();
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
}
