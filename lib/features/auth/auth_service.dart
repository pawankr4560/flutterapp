import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import 'auth_requests.dart';

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final Uri _signupUri = Uri.parse('${AppConfig.baseUrl}/Auth/Signup');
  final Uri _loginUri = Uri.parse('${AppConfig.baseUrl}/Auth/Login');

  Future<http.Response> signup(SignupRequest request) async {
    try {
      return await _post(_signupUri, request.toJson());
    } catch (error) {
      throw Exception('Signup failed. Please check your network connection.');
    }
  }

  Future<http.Response> login(LoginRequest request) async {
    try {
      return await _post(_loginUri, request.toJson());
    } catch (error) {
      throw Exception('Login failed. Please check your network connection.');
    }
  }

  Future<http.Response> _post(Uri uri, Map<String, dynamic> body) {
    return _client.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }
}
