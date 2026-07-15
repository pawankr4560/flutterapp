import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client, Duration? timeout})
    : _client = client ?? http.Client(),
      _timeout = timeout ?? const Duration(seconds: 20);

  final http.Client _client;
  final Duration _timeout;

  static void Function()? onUnauthorized;

  Future<http.Response> send(
    String method,
    Uri uri, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final request = http.Request(method, uri);

    if (headers != null) {
      request.headers.addAll(headers);
    }

    if (body != null) {
      request.body = jsonEncode(body);
    }

    try {
      final streamedResponse = await _client.send(request).timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        onUnauthorized?.call();
      }

      return response;
    } on TimeoutException catch (error) {
      _logFailure(method, uri, error);
      throw const ApiException('The request timed out. Please try again.');
    } on http.ClientException catch (error) {
      _logFailure(method, uri, error);
      throw const ApiException('Please check your network connection.');
    }
  }

  Future<http.Response> get(
    Uri uri, {
    String? bearerToken,
    Map<String, String>? extraHeaders,
  }) {
    return _sendAndThrowForFailure(
      'GET',
      uri,
      headers: _headers(bearerToken: bearerToken, extraHeaders: extraHeaders),
    );
  }

  Future<http.Response> post(
    Uri uri, {
    Map<String, dynamic>? body,
    String? bearerToken,
    Map<String, String>? extraHeaders,
  }) {
    return _sendAndThrowForFailure(
      'POST',
      uri,
      headers: _headers(
        bearerToken: bearerToken,
        extraHeaders: extraHeaders,
        includeJsonContentType: true,
      ),
      body: body,
    );
  }

  Future<http.Response> put(
    Uri uri, {
    Map<String, dynamic>? body,
    String? bearerToken,
    Map<String, String>? extraHeaders,
  }) {
    return _sendAndThrowForFailure(
      'PUT',
      uri,
      headers: _headers(
        bearerToken: bearerToken,
        extraHeaders: extraHeaders,
        includeJsonContentType: true,
      ),
      body: body,
    );
  }

  Future<http.Response> _sendAndThrowForFailure(
    String method,
    Uri uri, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final response = await send(method, uri, headers: headers, body: body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }

    final message =
        _messageFromErrorBody(response.body) ??
        'Request failed with status ${response.statusCode}';
    final error = ApiException(message, statusCode: response.statusCode);
    _logFailure(method, uri, error);
    throw error;
  }

  Map<String, String> _headers({
    String? bearerToken,
    Map<String, String>? extraHeaders,
    bool includeJsonContentType = false,
  }) {
    final headers = <String, String>{'accept': '*/*'};

    if (includeJsonContentType) {
      headers['Content-Type'] = 'application/json';
    }

    if (bearerToken != null && bearerToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  String? _messageFromErrorBody(String body) {
    if (body.isEmpty) {
      return null;
    }

    try {
      final jsonBody = jsonDecode(body);
      if (jsonBody is! Map<String, dynamic>) {
        return null;
      }

      for (final key in const ['errorMessage', 'message', 'error', 'title']) {
        final value = jsonBody[key];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    } on FormatException {
      return null;
    }

    return null;
  }

  void _logFailure(String method, Uri uri, Object error) {
    if (kDebugMode) {
      debugPrint('API $method $uri failed: $error');
    }
  }
}
