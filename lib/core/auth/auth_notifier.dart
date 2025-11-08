import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/repositories/auth_repository.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._authRepo) {
    _sub = _authRepo.session$.listen((session) {
      _isAuthenticated = session != null;
      notifyListeners();
    });
  }

  final AuthRepository _authRepo;
  late final StreamSubscription _sub;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

