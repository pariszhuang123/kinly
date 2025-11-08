import 'dart:async';
import '../../data/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository() {
    // Start unauthenticated
    _controller.add(null);
  }

  final _controller = StreamController<AuthSession?>.broadcast();

  @override
  Stream<AuthSession?> get session$ => _controller.stream;

  @override
  Future<void> signInWithApple() async {
    _controller.add(const AuthSession(userId: 'apple-user'));
  }

  @override
  Future<void> signInWithGoogle() async {
    _controller.add(const AuthSession(userId: 'google-user'));
  }

  @override
  Future<void> signOut() async {
    _controller.add(null);
  }
}
