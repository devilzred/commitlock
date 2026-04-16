import 'package:commitlock/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  AuthProvider() {
    loadAuthData();
  }

  // Load authentication data from SharedPreferences
  Future<void> loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? userName = prefs.getString('user_name');
    String? userEmail = prefs.getString('user_email');
    String? userPassword = prefs.getString('user_password');

    if (userId != null && userName != null && userEmail != null && userPassword != null) {
      _isAuthenticated = true;
      _currentUser = UserModel(
        id: userId,
        name: userName,
        email: userEmail,
        password: userPassword,
      );
      
      notifyListeners();
    }
  }

  // Login method
  Future<void> login(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_password', user.password);

    _isAuthenticated = true;
    _currentUser = user;
    
    notifyListeners();
  }

  // Logout method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_password');

    _isAuthenticated = false;
    notifyListeners();
  }
}