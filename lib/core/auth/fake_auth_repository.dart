import 'dart:async';
import 'auth.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository() {
    // Start unauthenticated
    _controller.add(null);
  }

  final _controller = StreamController<AuthSession?>.broadcast();
  AuthSession? _current;

  @override
  Stream<AuthSession?> get session$ => _controller.stream;

  @override
  AuthSession? get current => _current;

  @override
  Future<void> signInWithApple() async {
    _current = const AuthSession(userId: 'apple-user');
    _controller.add(_current);
  }

  @override
  Future<void> signInWithGoogle() async {
    _current = const AuthSession(userId: 'google-user');
    _controller.add(_current);
  }

  @override
  Future<void> signOut() async {
    _current = null;
    _controller.add(null);
  }
}
