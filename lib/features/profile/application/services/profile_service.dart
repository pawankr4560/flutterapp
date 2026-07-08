import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:finhub/core/constants/app_config.dart';
import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/data/api/api_exception.dart';

class ProfileService {
  ProfileService({http.Client? client})
      : _apiClient = ApiClient(client: client);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>?> fetchProfile({
    required String userId,
    required String bearerToken,
  }) async {
    if (userId.isEmpty) {
      throw const ApiException('User ID is missing. Please login again.');
    }

    final uri = Uri.parse('${AppConfig.baseUrl}/Auth/users/$userId/profile');
    final response = await _apiClient.get(uri, bearerToken: bearerToken);

    if (response.body.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(response.body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProfile({
    required String userId,
    required String bearerToken,
    String? userName,
    String? phone,
    String? address,
    String? profileImageUrl,
  }) async {
    if (userId.isEmpty) {
      throw const ApiException('User ID is missing. Please login again.');
    }

    final uri = Uri.parse('${AppConfig.baseUrl}/Auth/users/$userId/profile');

    final nameParts = _splitName(userName);
    final body = <String, dynamic>{};
    void addIfPresent(String key, String? value) {
      if (value != null) {
        body[key] = value;
      }
    }

    addIfPresent('firstName', nameParts.firstName);
    addIfPresent('lastName', nameParts.lastName);
    addIfPresent('mobile', phone);
    addIfPresent('address', address);
    addIfPresent('profileImageUrl', profileImageUrl);

    final response = await _apiClient.put(
      uri,
      bearerToken: bearerToken,
      body: body,
    );

    if (response.body.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(response.body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  _NameParts _splitName(String? fullName) {
    final trimmedName = fullName?.trim();
    if (trimmedName == null || trimmedName.isEmpty) {
      return const _NameParts();
    }

    final parts = trimmedName.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return _NameParts(firstName: parts.first);
    }

    return _NameParts(
      firstName: parts.first,
      lastName: parts.skip(1).join(' '),
    );
  }
}

class _NameParts {
  const _NameParts({this.firstName, this.lastName});

  final String? firstName;
  final String? lastName;
}


