import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/employee.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  Employee? _employee;
  bool _isLoading = false;
  String? _token;

  User? get user => _user;
  Employee? get employee => _employee;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null && _token != null;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    try {
      print('Starting login process for email: $email');

      final result = await ApiService.login(email, password);

      if (result != null) {
        final success = result['success'] as bool? ?? false;

        if (success) {
          final userData = result['user'];

          if (userData != null) {
            try {
              _user = User.fromJson(userData);
              _token = result['token'] as String?;

              // Save to shared preferences
              final prefs = await SharedPreferences.getInstance();
              if (_token != null) {
                await prefs.setString('token', _token!);
              }
              await prefs.setInt('user_id', _user!.idUser);
              await prefs.setString('user_email', _user!.email);
              await prefs.setString('user_nama', _user!.nama);

              notifyListeners();
              setLoading(false);
              return true;
            } catch (e) {
              print('Error creating user object: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Login error: $e');
    }

    setLoading(false);
    return false;
  }

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('user_id');

      if (userId != null) {
        _token = token;
        _user = await ApiService.getUserProfile(userId);
        _employee = await ApiService.getEmployeeDetail(userId);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> logout() async {
    _user = null;
    _employee = null;
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_nama');

    notifyListeners();
  }
}
