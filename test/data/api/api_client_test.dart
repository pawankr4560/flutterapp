import 'dart:async';
import 'dart:convert';

import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/data/api/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  tearDown(() {
    ApiClient.onUnauthorized = null;
  });

  test('returns successful responses unchanged', () async {
    final client = ApiClient(
      client: _FakeHttpClient(
        (request) async => _response('{"ok":true}', statusCode: 200),
      ),
    );

    final response = await client.get(Uri.parse('https://example.test/items'));

    expect(response.statusCode, 200);
    expect(response.body, '{"ok":true}');
  });

  test('throws ApiException with message from JSON error body', () async {
    final client = ApiClient(
      client: _FakeHttpClient(
        (request) async => _response(
          jsonEncode({'message': 'Email already exists'}),
          statusCode: 409,
        ),
      ),
    );

    await expectLater(
      client.post(Uri.parse('https://example.test/signup'), body: {}),
      throwsA(
        isA<ApiException>()
            .having((error) => error.message, 'message', 'Email already exists')
            .having((error) => error.statusCode, 'statusCode', 409),
      ),
    );
  });

  test('throws ApiException when the request times out', () async {
    final client = ApiClient(
      timeout: const Duration(milliseconds: 1),
      client: _FakeHttpClient(
        (request) => Completer<http.StreamedResponse>().future,
      ),
    );

    await expectLater(
      client.get(Uri.parse('https://example.test/slow')),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          'The request timed out. Please try again.',
        ),
      ),
    );
  });

  test('fires onUnauthorized callback for 401 responses', () async {
    var unauthorizedCount = 0;
    ApiClient.onUnauthorized = () => unauthorizedCount++;
    final client = ApiClient(
      client: _FakeHttpClient(
        (request) async =>
            _response(jsonEncode({'error': 'Unauthorized'}), statusCode: 401),
      ),
    );

    await expectLater(
      client.get(Uri.parse('https://example.test/private')),
      throwsA(isA<ApiException>()),
    );

    expect(unauthorizedCount, 1);
  });
}

class _FakeHttpClient extends http.BaseClient {
  _FakeHttpClient(this._handler);

  final Future<http.StreamedResponse> Function(http.BaseRequest request)
  _handler;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _handler(request);
  }
}

http.StreamedResponse _response(String body, {required int statusCode}) {
  return http.StreamedResponse(
    Stream.value(utf8.encode(body)),
    statusCode,
    headers: {'content-type': 'application/json'},
  );
}
