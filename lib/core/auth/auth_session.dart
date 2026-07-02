import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSession extends ChangeNotifier {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  static const String _userIdKey = 'auth_user_id';
  static const String _bearerTokenKey = 'auth_bearer_token';
  static const String _userNameKey = 'auth_user_name';
  static const String _emailKey = 'auth_email';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _userId;
  String? _bearerToken;
  String? _userName;
  String? _email;

  bool get isAuthenticated =>
      _userId != null && _userId!.isNotEmpty && _bearerToken != null && _bearerToken!.isNotEmpty;

  String get userId => _userId ?? '';

  String get bearerToken => _bearerToken ?? '';

  String get userName => _userName ?? '';

  String get email => _email ?? '';

  Future<void> initialize() async {
    _userId = await _storage.read(key: _userIdKey);
    _bearerToken = await _storage.read(key: _bearerTokenKey);
    _userName = await _storage.read(key: _userNameKey);
    _email = await _storage.read(key: _emailKey);
    notifyListeners();
  }

  Future<void> save({
    required String userId,
    required String bearerToken,
    String? userName,
    String? email,
  }) async {
    _userId = userId;
    _bearerToken = bearerToken;
    _userName = userName;
    _email = email;

    await Future.wait([
      _storage.write(key: _userIdKey, value: userId),
      _storage.write(key: _bearerTokenKey, value: bearerToken),
      if (userName != null) _storage.write(key: _userNameKey, value: userName),
      if (email != null) _storage.write(key: _emailKey, value: email),
    ]);

    notifyListeners();
  }

  Future<void> updateFromResponse(Map<String, dynamic>? responseBody) async {
    if (responseBody == null) {
      return;
    }

    final data = _normalizeMap(responseBody['data']) ?? _normalizeMap(responseBody);
    final payload = _normalizeMap(data?['user']) ?? data;
    if (payload == null) {
      return;
    }

    final bearerToken = _extractFirstString(payload, [
      'token',
      'accessToken',
      'bearerToken',
      'authToken',
      'jwt',
    ]);
    final userId = _extractFirstString(payload, [
      'userId',
      'id',
      'user_id',
    ]);
    final userName = _extractFirstString(payload, [
      'userName',
      'name',
      'fullName',
      'firstName',
    ]);
    final email = _extractFirstString(payload, [
      'email',
      'userEmail',
    ]);

    if (userId != null && bearerToken != null) {
      await save(
        userId: userId,
        bearerToken: bearerToken,
        userName: userName,
        email: email,
      );
    }
  }

  Future<void> logout() async {
    _userId = null;
    _bearerToken = null;
    _userName = null;
    _email = null;

    await Future.wait([
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _bearerTokenKey),
      _storage.delete(key: _userNameKey),
      _storage.delete(key: _emailKey),
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
}
