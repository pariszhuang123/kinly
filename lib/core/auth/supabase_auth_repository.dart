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

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    SupabaseClient? client,
    GoogleSignIn? googleSignIn,
    Logger? logger,
  }) : _client = client ?? Supabase.instance.client,
       _googleSignIn = googleSignIn ?? _buildDefaultGoogleSignIn(),
       _logger = logger ?? const DebugLogger() {
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
    if (AppConfig.webClientId.isEmpty) {
      throw AuthException(
        'Missing WEB_CLIENT_ID dart-define (Google web client ID required).',
      );
    }
    if (Platform.isIOS && AppConfig.iosClientId.isEmpty) {
      throw AuthException(
        'Missing IOS_CLIENT_ID dart-define (Google iOS client ID required).',
      );
    }

    // Attempt silent sign-in first to reuse existing credentials.
    GoogleSignInAccount? account = await _googleSignIn.signInSilently();
    account ??= await _googleSignIn.signIn();
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
    final audience = _readAudience(idToken);
    if (kDebugMode) {
      _logger.debug(
        'GOOGLE: aud=$audience webClientId=${AppConfig.webClientId}',
        tag: _logTag,
      );
    }
    if (audience != null && audience != AppConfig.webClientId) {
      _logger.error(
        'GOOGLE: unexpected ID token audience "$audience" (expected ${AppConfig.webClientId}).',
        tag: _logTag,
      );
      throw AuthException(
        'Google sign-in returned an unexpected audience. '
        'Please reinstall and ensure WEB_CLIENT_ID matches the Supabase Google OAuth client ID.',
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
    if (!Platform.isIOS) {
      throw AuthException('Apple Sign-In is only available on iOS.');
    }
    if (!await SignInWithApple.isAvailable()) {
      throw AuthException('Apple Sign-In is not available on this device.');
    }

    final rawNonce = _generateNonce();
    if (kDebugMode) {
      _logger.debug('APPLE_TAP', tag: _logTag);
      _logger.debug('APPLE: start', tag: _logTag);
    }

    AuthorizationCredentialAppleID appleCredential;
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
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
    await _client.auth.signOut();
  }

  void dispose() {
    _sub.cancel();
    _sessionController.close();
  }

  static GoogleSignIn _buildDefaultGoogleSignIn() {
    final serverClientId =
        AppConfig.webClientId.isEmpty ? null : AppConfig.webClientId;
    final iosClientId =
        AppConfig.iosClientId.isEmpty ? null : AppConfig.iosClientId;
    return GoogleSignIn(
      scopes: const ['email', 'profile'],
      serverClientId: serverClientId,
      clientId: Platform.isIOS ? iosClientId : null,
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
}
