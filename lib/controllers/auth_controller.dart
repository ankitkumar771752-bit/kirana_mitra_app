import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void login(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
