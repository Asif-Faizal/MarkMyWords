import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  User? _user;
  bool _isLoading = true;
  String? _error;

  AuthProvider({required ApiService apiService}) : _apiService = apiService {
    _checkAuthStatus();
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _checkAuthStatus() async {
    try {
      if (_apiService.isAuthenticated) {
        _user = await _apiService.getCurrentUser();
      }
    } catch (e) {
      // User not authenticated or token expired
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );
      
      _user = User.fromJson(response['user']);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.register(
        email: email,
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      
      _user = User.fromJson(response['user']);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
