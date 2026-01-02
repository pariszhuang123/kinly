import 'dart:async';

class AuthSession {
  const AuthSession({required this.userId});
  final String userId;
}

abstract class AuthRepository {
  Stream<AuthSession?> get session$;
  AuthSession? get current;
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signOut();
}
