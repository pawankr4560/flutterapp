import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import 'auth_requests.dart';

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final Uri _signupUri = Uri.parse('${AppConfig.baseUrl}/Auth/Signup');
  final Uri _loginUri = Uri.parse('${AppConfig.baseUrl}/Auth/Login');

  Future<http.Response> signup(SignupRequest request) {
    return _post(_signupUri, request.toJson());
  }

  Future<http.Response> login(LoginRequest request) {
    return _post(_loginUri, request.toJson());
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
