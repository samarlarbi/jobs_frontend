import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jobs_app/api/EndPoint.dart';
import 'dart:convert';

import 'package:jobs_app/api/httpClient.dart';

class AuthProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String? _token;
  bool _isLoading = false;

  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
   final Httpclient api;

  AuthProvider() : api = Httpclient(); // ✅ added semicolon and fixed typo

  void setInitialToken(String? token) {
    if (token != null) {
      _token = token;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await api.post("auth/login",
           {'email': email, 'password': password}
      );

        final data =response;
        _token = data['accessToken']; // assuming backend returns {token: "..."}
        await storage.write(key: 'jwt', value: _token);
        notifyListeners();
     
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    final savedToken = await storage.read(key: 'jwt');
    if (savedToken != null) {
      _token = savedToken;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    await storage.delete(key: 'jwt');
    notifyListeners();
  }
}
