import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/auth_repository.dart';
import '../config/app_config.dart';
import '../logging/debug_logger.dart';
import '../logging/logger.dart';

typedef PlatformCheck = bool Function();

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    SupabaseClient? client,
    GoogleSignIn? googleSignIn,
    Logger? logger,
    AppleSignInProvider? appleSignInProvider,
    PlatformCheck? platformCheck,
  }) : _client = client ?? Supabase.instance.client,
       _googleSignIn = googleSignIn ?? _buildDefaultGoogleSignIn(),
       _logger = logger ?? const DebugLogger(),
       _appleSignInProvider =
           appleSignInProvider ?? const DefaultAppleSignInProvider(),
       _isApplePlatform = platformCheck ?? (() => Platform.isIOS) {
    _sessionController = StreamController<AuthSession?>.broadcast();

    // Seed current state
    final current = _client.auth.currentSession;
    _current = current != null ? AuthSession(userId: current.user.id) : null;
    _sessionController.add(_current);

    // Listen for auth changes
    _sub = _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      _current = session != null ? AuthSession(userId: session.user.id) : null;
      _sessionController.add(_current);
    });
  }

  final SupabaseClient _client;
  final GoogleSignIn _googleSignIn;
  final Logger _logger;
  final AppleSignInProvider _appleSignInProvider;
  final PlatformCheck _isApplePlatform;

  late final StreamSubscription<AuthState> _sub;
  late final StreamController<AuthSession?> _sessionController;

  AuthSession? _current;

  static const _logTag = 'SupabaseAuthRepo';

  @override
  Stream<AuthSession?> get session$ => _sessionController.stream;

  @override
  AuthSession? get current =>
      _current ??
      (_client.auth.currentSession != null
          ? AuthSession(userId: _client.auth.currentSession!.user.id)
          : null);

  @override
  Future<void> signInWithGoogle() async {
    if (kDebugMode) {
      _logger.debug('GOOGLE_TAP', tag: _logTag);
    }

    // Supabase validates Google ID tokens against the *Web* OAuth client ID.
    if (AppConfig.webClientId.isEmpty) {
      throw AuthException(
        'Missing WEB_CLIENT_ID dart-define (Google web client ID required).',
      );
    }

    // iOS requires the reversed iOS client id URL scheme present in Info.plist
    // to receive the OAuth callback, but the token "aud" must still match WEB_CLIENT_ID.
    if (_isApplePlatform() && AppConfig.iosClientId.isEmpty) {
      throw AuthException(
        'Missing IOS_CLIENT_ID dart-define (Google iOS client ID required).',
      );
    }

    // IMPORTANT:
    // When switching between dev/prod (or changing WEB_CLIENT_ID),
    // iOS can reuse a cached Google session via signInSilently() and return an ID token
    // whose "aud" is tied to the previous client configuration.
    //
    // To make env switching reliable:
    // 1) force a clean session (disconnect clears granted scopes + cached auth),
    // 2) do an interactive sign-in (no silent sign-in).
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      // disconnect can throw if there is no previous session; safe to ignore.
      if (kDebugMode) {
        _logger.debug('GOOGLE: disconnect noop/failed: $e', tag: _logTag);
      } else {
        _logger.info('GOOGLE: disconnect noop/failed', tag: _logTag);
      }
      if (kDebugMode) {
        _logger.debug('GOOGLE: disconnect stack', tag: _logTag);
      }
    }

    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) {
      _logger.info('GOOGLE: user canceled sign-in', tag: _logTag);
      throw AuthException('Sign-in aborted.');
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;

    if (idToken == null) {
      throw AuthException(
        'Missing Google ID token. Check WEB_CLIENT_ID dart-define.',
      );
    }

    // Guardrail: verify the ID token audience matches the web client ID used by Supabase.
    final audience = _readAudience(idToken);

    if (kDebugMode) {
      _logger.debug(
        'GOOGLE: aud=$audience webClientId=${_redactClientId(AppConfig.webClientId)} '
        'iosClientId=${_isApplePlatform() ? _redactClientId(AppConfig.iosClientId) : 'n/a'}',
        tag: _logTag,
      );
    }

    if (audience != null && audience != AppConfig.webClientId) {
      _logger.error(
        'GOOGLE: unexpected ID token audience "$audience" (expected ${_redactClientId(AppConfig.webClientId)}).',
        tag: _logTag,
      );
      throw AuthException(
        'Google sign-in returned an unexpected audience. '
        'Please ensure WEB_CLIENT_ID matches the Supabase Google OAuth client ID '
        'for this environment, then delete/reinstall the app if needed.',
      );
    }

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: auth.accessToken,
    );
  }

  @override
  Future<void> signInWithApple() async {
    if (!_isApplePlatform()) {
      throw AuthException('Apple Sign-In is only available on iOS.');
    }
    if (!await _appleSignInProvider.isAvailable()) {
      throw AuthException('Apple Sign-In is not available on this device.');
    }

    final rawNonce = _generateNonce();
    if (kDebugMode) {
      _logger.debug('APPLE_TAP', tag: _logTag);
      _logger.debug('APPLE: start', tag: _logTag);
    }

    AuthorizationCredentialAppleID appleCredential;
    try {
      appleCredential = await _appleSignInProvider.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: _sha256ofString(rawNonce),
      );
    } on SignInWithAppleAuthorizationException catch (error, stackTrace) {
      if (error.code == AuthorizationErrorCode.canceled) {
        _logger.info('APPLE: user canceled', tag: _logTag);
        return;
      }
      _logger.error(
        'APPLE: authorization failed (${error.code.name}): ${error.message}',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
      throw AuthException(
        'Apple Sign-In failed (${error.code.name}). '
        'Please retry and confirm the Sign in with Apple capability is enabled.',
      );
    }

    final idToken = appleCredential.identityToken;

    if (kDebugMode) {
      _logger.debug(
        'APPLE: got identityToken? ${idToken != null}',
        tag: _logTag,
      );
    }

    if (idToken == null) {
      _logger.error('APPLE: missing identity token', tag: _logTag);
      throw AuthException(
        'Missing Apple identity token. Confirm Sign in with Apple is enabled in Xcode capabilities.',
      );
    }

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  @override
  Future<void> signOut() async {
    // Best effort: sign out of Google too (prevents silent reuse across envs).
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      if (kDebugMode) {
        _logger.debug('GOOGLE: signOut failed: $e', tag: _logTag);
      }
    }
    await _client.auth.signOut();
  }

  void dispose() {
    _sub.cancel();
    _sessionController.close();
  }

  static GoogleSignIn _buildDefaultGoogleSignIn() {
    // IMPORTANT:
    // For Supabase, the ID token audience MUST be the Web OAuth Client ID.
    // Passing serverClientId ensures the minted ID token "aud" matches WEB_CLIENT_ID.
    final serverClientId =
        AppConfig.webClientId.isEmpty ? null : AppConfig.webClientId;

    // NOTE:
    // On iOS, you generally do NOT need to pass `clientId` here if you have:
    // - the reversed iOS client id URL scheme in Info.plist, and/or
    // - GoogleService-Info.plist properly configured.
    //
    // Passing `clientId` can increase the chance of env mismatch if it isn't aligned.
    // So we deliberately omit it.
    return GoogleSignIn(
      scopes: const ['email', 'profile'],
      serverClientId: serverClientId,
    );
  }

  String? _readAudience(String jwt) {
    final parts = jwt.split('.');
    if (parts.length < 2) return null;
    try {
      final normalized = base64Url.normalize(parts[1]);
      final payload = json.decode(utf8.decode(base64Url.decode(normalized)));
      final aud = payload['aud'];
      if (aud is String) return aud;
      if (aud is List && aud.isNotEmpty && aud.first is String) {
        return aud.first as String;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String _redactClientId(String value) {
    if (value.isEmpty) return '(empty)';
    // Show first 10 + last 6 to help debug without leaking full secret-ish strings.
    if (value.length <= 18) return value;
    return '${value.substring(0, 10)}???${value.substring(value.length - 6)}';
  }
}

/// Adapter around [SignInWithApple] to keep [SupabaseAuthRepository] testable.
abstract class AppleSignInProvider {
  const AppleSignInProvider();

  Future<bool> isAvailable();

  Future<AuthorizationCredentialAppleID> getAppleIDCredential({
    required List<AppleIDAuthorizationScopes> scopes,
    required String nonce,
  });
}

class DefaultAppleSignInProvider implements AppleSignInProvider {
  const DefaultAppleSignInProvider();

  @override
  Future<bool> isAvailable() => SignInWithApple.isAvailable();

  @override
  Future<AuthorizationCredentialAppleID> getAppleIDCredential({
    required List<AppleIDAuthorizationScopes> scopes,
    required String nonce,
  }) => SignInWithApple.getAppleIDCredential(scopes: scopes, nonce: nonce);
}
