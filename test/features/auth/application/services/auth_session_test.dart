import 'package:finhub/features/auth/application/services/auth_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthSession session;
  late FlutterSecureStorage storage;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    session = AuthSession.instance;
    storage = const FlutterSecureStorage();
    await session.logout();
  });

  test('save persists session values and logout clears them', () async {
    await session.save(
      userId: 'user-1',
      bearerToken: 'token-1',
      userName: 'Asha Rao',
      email: 'asha@example.test',
      phone: '9999999999',
      address: 'Main Road',
      profileImageUrl: 'https://example.test/avatar.png',
    );

    expect(session.isAuthenticated, isTrue);
    expect(session.userId, 'user-1');
    expect(session.bearerToken, 'token-1');
    expect(session.userName, 'Asha Rao');
    expect(await storage.read(key: 'auth_user_id'), 'user-1');
    expect(await storage.read(key: 'auth_bearer_token'), 'token-1');
    expect(await storage.read(key: 'auth_user_name'), 'Asha Rao');

    await session.logout();

    expect(session.isAuthenticated, isFalse);
    expect(session.userId, isEmpty);
    expect(session.bearerToken, isEmpty);
    expect(await storage.read(key: 'auth_user_id'), isNull);
    expect(await storage.read(key: 'auth_bearer_token'), isNull);
    expect(await storage.read(key: 'auth_user_name'), isNull);
  });

  test('initialize reads an existing stored session', () async {
    FlutterSecureStorage.setMockInitialValues({
      'auth_user_id': 'stored-user',
      'auth_bearer_token': 'stored-token',
      'auth_user_name': 'Stored Name',
      'auth_email': 'stored@example.test',
    });

    await session.initialize();

    expect(session.isAuthenticated, isTrue);
    expect(session.userId, 'stored-user');
    expect(session.bearerToken, 'stored-token');
    expect(session.userName, 'Stored Name');
    expect(session.email, 'stored@example.test');
  });

  test('updateFromResponse extracts data.user token id and name', () async {
    await session.updateFromResponse({
      'data': {
        'token': 'token-a',
        'user': {'id': 'user-a', 'name': 'Nisha Patel'},
      },
    });

    expect(session.userId, 'user-a');
    expect(session.bearerToken, 'token-a');
    expect(session.userName, 'Nisha Patel');
  });

  test('updateFromResponse extracts root access token and user id', () async {
    await session.updateFromResponse({
      'access_token': 'token-b',
      'user_id': 'user-b',
      'fullName': 'Dev Mehta',
    });

    expect(session.userId, 'user-b');
    expect(session.bearerToken, 'token-b');
    expect(session.userName, 'Dev Mehta');
  });

  test('updateFromResponse joins first and last names when needed', () async {
    await session.updateFromResponse({
      'data': {
        'jwtToken': 'token-c',
        'userId': 'user-c',
        'user': {'first_name': 'Riya', 'last_name': 'Shah'},
      },
    });

    expect(session.userId, 'user-c');
    expect(session.bearerToken, 'token-c');
    expect(session.userName, 'Riya Shah');
  });
}
