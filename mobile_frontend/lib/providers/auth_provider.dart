import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

/// Manages user authentication state, token persistence, and auth API calls.
// PUBLIC_INTERFACE
class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _loadToken();
  }

  final APIService _api = APIService();
  String? _token;
  bool _loading = false;
  String? _error;

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  String? get token => _token;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _api.setToken(_token);
    notifyListeners();
  }

  Future<void> _saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null || token.isEmpty) {
      await prefs.remove('auth_token');
    } else {
      await prefs.setString('auth_token', token);
    }
  }

  // PUBLIC_INTERFACE
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final res = await _api.post('/auth/login', {'email': email, 'password': password});
      final t = (res['token'] ?? res['data']?['token'])?.toString() ?? '';
      if (t.isEmpty) {
        throw Exception('Invalid token received');
      }
      _token = t;
      _api.setToken(_token);
      await _saveToken(_token);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // PUBLIC_INTERFACE
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      final res = await _api.post('/auth/register', {'name': name, 'email': email, 'password': password});
      final t = (res['token'] ?? res['data']?['token'])?.toString() ?? '';
      if (t.isEmpty) {
        // some backends return user then require login; fallback to immediate login
        await login(email, password);
        return isAuthenticated;
      }
      _token = t;
      _api.setToken(_token);
      await _saveToken(_token);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // PUBLIC_INTERFACE
  Future<void> logout() async {
    _token = null;
    _api.setToken(null);
    await _saveToken(null);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
