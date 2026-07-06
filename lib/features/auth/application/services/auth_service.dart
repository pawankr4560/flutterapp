import 'package:http/http.dart' as http;

import 'package:finhub/core/constants/app_config.dart';
import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/features/auth/data/models/auth_requests.dart';

class AuthService {
  AuthService({http.Client? client}) : _apiClient = ApiClient(client: client);

  final ApiClient _apiClient;
  final Uri _signupUri = Uri.parse('${AppConfig.baseUrl}/Auth/Signup');
  final Uri _loginUri = Uri.parse('${AppConfig.baseUrl}/Auth/Login');
  final Uri _forgotPasswordUri = Uri.parse(
    '${AppConfig.baseUrl}/Auth/ForgotPassword',
  );

  Future<http.Response> signup(SignupRequest request) async {
    return _post(
      _signupUri,
      request.toJson(),
      headers: const {'X-Client': 'Flutter'},
    );
  }

  Future<http.Response> login(LoginRequest request) async {
    return _post(_loginUri, request.toJson());
  }

  Future<http.Response> forgotPassword(ForgotPasswordRequest request) async {
    return _post(
      _forgotPasswordUri,
      request.toJson(),
      headers: const {'X-Client': 'Flutter'},
    );
  }

  Future<http.Response> _post(
    Uri uri,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) {
    return _apiClient.send(
      'POST',
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: body,
    );
  }
}


