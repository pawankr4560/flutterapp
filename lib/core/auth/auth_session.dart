import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSession extends ChangeNotifier {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  static const String _userIdKey = 'auth_user_id';
  static const String _bearerTokenKey = 'auth_bearer_token';
  static const String _userNameKey = 'auth_user_name';
  static const String _emailKey = 'auth_email';
  static const String _phoneKey = 'auth_phone';
  static const String _addressKey = 'auth_address';
  static const String _profileImageUrlKey = 'auth_profile_image_url';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _userId;
  String? _bearerToken;
  String? _userName;
  String? _email;
  String? _phone;
  String? _address;
  String? _profileImageUrl;

  bool get isAuthenticated =>
      _userId != null &&
      _userId!.isNotEmpty &&
      _bearerToken != null &&
      _bearerToken!.isNotEmpty;

  String get userId => _userId ?? '';

  String get bearerToken => _bearerToken ?? '';

  String get userName => _userName ?? '';

  String get email => _email ?? '';

  String get phone => _phone ?? '';

  String get address => _address ?? '';

  String get profileImageUrl => _profileImageUrl ?? '';

  Future<void> initialize() async {
    _userId = await _storage.read(key: _userIdKey);
    _bearerToken = await _storage.read(key: _bearerTokenKey);
    _userName = await _storage.read(key: _userNameKey);
    _email = await _storage.read(key: _emailKey);
    _phone = await _storage.read(key: _phoneKey);
    _address = await _storage.read(key: _addressKey);
    _profileImageUrl = await _storage.read(key: _profileImageUrlKey);
    notifyListeners();
  }

  Future<void> save({
    required String userId,
    required String bearerToken,
    String? userName,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
  }) async {
    _userId = userId;
    _bearerToken = bearerToken;
    _userName = userName;
    _email = email;
    _phone = phone;
    _address = address;
    _profileImageUrl = profileImageUrl;

    await Future.wait([
      _storage.write(key: _userIdKey, value: userId),
      _storage.write(key: _bearerTokenKey, value: bearerToken),
      if (userName != null) _storage.write(key: _userNameKey, value: userName),
      if (email != null) _storage.write(key: _emailKey, value: email),
      if (phone != null) _storage.write(key: _phoneKey, value: phone),
      if (address != null) _storage.write(key: _addressKey, value: address),
      if (profileImageUrl != null)
        _storage.write(key: _profileImageUrlKey, value: profileImageUrl),
    ]);

    notifyListeners();
  }

  Future<void> updateProfile({
    String? userName,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
  }) async {
    _userName = userName ?? _userName;
    _email = email ?? _email;
    _phone = phone ?? _phone;
    _address = address ?? _address;
    _profileImageUrl = profileImageUrl ?? _profileImageUrl;

    await Future.wait([
      if (userName != null) _storage.write(key: _userNameKey, value: userName),
      if (email != null) _storage.write(key: _emailKey, value: email),
      if (phone != null) _storage.write(key: _phoneKey, value: phone),
      if (address != null) _storage.write(key: _addressKey, value: address),
      if (profileImageUrl != null)
        _storage.write(key: _profileImageUrlKey, value: profileImageUrl),
    ]);

    notifyListeners();
  }

  Future<void> updateFromResponse(Map<String, dynamic>? responseBody) async {
    if (responseBody == null) {
      return;
    }

    final data =
        _normalizeMap(responseBody['data']) ?? _normalizeMap(responseBody);
    final user =
        _normalizeMap(data?['user']) ?? _normalizeMap(responseBody['user']);
    if (data == null && user == null) {
      return;
    }

    final bearerToken = _extractFirstStringFromMaps(
      [user, data, responseBody],
      [
        'token',
        'accessToken',
        'access_token',
        'bearerToken',
        'authToken',
        'jwt',
        'jwtToken',
      ],
    );
    final userId = _extractFirstStringFromMaps(
      [user, data, responseBody],
      ['userId', 'id', 'user_id'],
    );
    final userName = _extractFirstStringFromMaps(
      [user, data, responseBody],
      ['userName', 'name', 'fullName', 'firstName'],
    );
    final firstName = _extractFirstStringFromMaps(
      [user, data, responseBody],
      ['firstName', 'first_name'],
    );
    final lastName = _extractFirstStringFromMaps(
      [user, data, responseBody],
      ['lastName', 'last_name'],
    );
    final email = _extractFirstStringFromMaps(
      [user, data, responseBody],
      ['email', 'userEmail'],
    );
    final phone = _extractFirstStringFromMaps(
      [user, data, responseBody],
      ['phone', 'phoneNumber', 'mobile', 'mobileNumber'],
    );
    final address = _extractFirstStringFromMaps(
      [user, data, responseBody],
      ['address', 'userAddress'],
    );
    final profileImageUrl = _extractFirstStringFromMaps(
      [user, data, responseBody],
      [
        'profileImageUrl',
        'profilePictureUrl',
        'avatarUrl',
        'imageUrl',
        'photoUrl',
      ],
    );
    final displayName = userName ?? _joinName(firstName, lastName);

    if (userId != null && bearerToken != null) {
      await save(
        userId: userId,
        bearerToken: bearerToken,
        userName: displayName,
        email: email,
        phone: phone,
        address: address,
        profileImageUrl: profileImageUrl,
      );
    }
  }

  Future<void> logout() async {
    _userId = null;
    _bearerToken = null;
    _userName = null;
    _email = null;
    _phone = null;
    _address = null;
    _profileImageUrl = null;

    await Future.wait([
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _bearerTokenKey),
      _storage.delete(key: _userNameKey),
      _storage.delete(key: _emailKey),
      _storage.delete(key: _phoneKey),
      _storage.delete(key: _addressKey),
      _storage.delete(key: _profileImageUrlKey),
    ]);

    notifyListeners();
  }

  Map<String, dynamic>? _normalizeMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }

  String? _extractFirstString(Map<String, dynamic> payload, List<String> keys) {
    for (final key in keys) {
      final value = payload[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  String? _extractFirstStringFromMaps(
    List<Map<String, dynamic>?> payloads,
    List<String> keys,
  ) {
    for (final payload in payloads) {
      if (payload == null) {
        continue;
      }

      final value = _extractFirstString(payload, keys);
      if (value != null) {
        return value;
      }
    }

    return null;
  }

  String? _joinName(String? firstName, String? lastName) {
    final parts = [
      if (firstName != null && firstName.isNotEmpty) firstName,
      if (lastName != null && lastName.isNotEmpty) lastName,
    ];

    return parts.isEmpty ? null : parts.join(' ');
  }
}
