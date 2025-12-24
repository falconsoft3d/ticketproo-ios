import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  late ApiService _apiService;
  bool _isAuthenticated = false;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;
  ApiService get apiService => _apiService;

  AuthProvider() {
    _apiService = ApiService(baseUrl: 'https://ticketproo.com/');
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final baseUrl = prefs.getString('baseUrl');
    
    if (baseUrl != null) {
      _apiService.setBaseUrl(baseUrl);
    }
    
    if (_token != null) {
      _apiService.setToken(_token!);
      _isAuthenticated = true;
      
      // Cargar datos del usuario si están guardados
      final userId = prefs.getInt('userId');
      final username = prefs.getString('username');
      final email = prefs.getString('email');
      final firstName = prefs.getString('firstName');
      final lastName = prefs.getString('lastName');
      
      if (userId != null && username != null) {
        _user = User(
          id: userId,
          username: username,
          email: email ?? '',
          firstName: firstName ?? '',
          lastName: lastName ?? '',
        );
      }
    }
    
    notifyListeners();
  }

  Future<bool> hasConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('baseUrl');
  }

  Future<void> saveBaseUrl(String baseUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', baseUrl);
    _apiService.setBaseUrl(baseUrl);
    notifyListeners();
  }

  Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('baseUrl') ?? 'https://ticketproo.com/';
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final result = await _apiService.login(username, password);
    
    if (result['success']) {
      _token = result['token'];
      _user = result['user'];
      _isAuthenticated = true;
      
      _apiService.setToken(_token!);
      
      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setInt('userId', _user!.id);
      await prefs.setString('username', _user!.username);
      await prefs.setString('email', _user!.email);
      await prefs.setString('firstName', _user!.firstName);
      await prefs.setString('lastName', _user!.lastName);
      
      notifyListeners();
    }
    
    return result;
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _isAuthenticated = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    // No eliminamos saved_username, saved_password ni remember_me
    // para que persistan después del logout
    
    notifyListeners();
  }

  Future<void> clearConfiguration() async {
    await logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('baseUrl');
    _apiService.setBaseUrl('https://ticketproo.com/');
    notifyListeners();
  }
}
