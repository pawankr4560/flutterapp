import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';

class ProfileService {
  ProfileService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>?> updateProfile({
    required String userId,
    required String bearerToken,
    String? userName,
    String? phone,
    String? address,
    String? profileImageUrl,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID is missing. Please login again.');
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

    http.Response response;
    try {
      response = await _client.put(
        uri,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          if (bearerToken.isNotEmpty) 'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );
    } catch (_) {
      throw Exception('Unable to save profile. Please check your connection.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Unable to save profile. Server returned ${response.statusCode}.',
      );
    }

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
