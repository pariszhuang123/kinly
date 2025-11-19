import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/auth_repository.dart';
import '../config/app_config.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({SupabaseClient? client, GoogleSignIn? googleSignIn})
    : _client = client ?? Supabase.instance.client,
      _googleSignIn = googleSignIn ?? _buildDefaultGoogleSignIn() {
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
  late final StreamSubscription<AuthState> _sub;
  late final StreamController<AuthSession?> _sessionController;
  AuthSession? _current;

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
    // Attempt silent sign-in first to reuse existing credentials.
    GoogleSignInAccount? account = await _googleSignIn.signInSilently();
    account ??= await _googleSignIn.signIn();
    if (account == null) {
      throw AuthException('Sign-in aborted.');
    }
    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw AuthException(
        'Missing Google ID token. Check WEB_CLIENT_ID dart-define.',
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
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: _sha256ofString(rawNonce),
    );
    final idToken = appleCredential.identityToken;
    if (idToken == null) {
      throw AuthException('Missing Apple identity token.');
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
