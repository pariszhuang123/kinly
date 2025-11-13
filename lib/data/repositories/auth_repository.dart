import 'dart:async';

abstract class AuthRepository {
  Stream<AuthSession?> get session$;
  AuthSession? get current;
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signOut();
}

class AuthSession {
  const AuthSession({required this.userId});
  final String userId;
}
