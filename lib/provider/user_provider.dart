import 'package:flutter/cupertino.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  UserSQ? _currentUser;
  bool _loading = false;
  String? _error;

  Future<void> fetchCurrentUser() async {
    // ✅ 1. Chặn gọi trùng
    if (_loading) return;

    // ✅ 2. Không có token thì không gọi
    if (!_api.hasToken) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _api.fetchCurrentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void signOut() {
    _api.signOut();
    _currentUser = null;
    _error = null;
    _loading = false;
    notifyListeners();
  }

  UserSQ? get currentUser => _currentUser;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
}

