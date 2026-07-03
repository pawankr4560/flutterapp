import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../models/loan_application.dart';
import '../../models/loan_status.dart';
import '../../models/uploaded_document.dart';
import 'document_requests.dart';
import 'loan_requests.dart';

class LoanService {
  LoanService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final Uri _applicationUri = Uri.parse('${AppConfig.baseUrl}/Loan/loan-applications');

  Future<http.Response> submitApplication(
    LoanApplicationRequest request,
    String bearerToken,
  ) async {
    try {
      return await _post(
        _applicationUri,
        request.toJson(),
        bearerToken,
      );
    } catch (_) {
      throw Exception('Unable to submit application. Please check your connection.');
    }
  }

  Future<List<LoanApplication>> fetchApplications(
    String userId,
    String bearerToken,
  ) async {
    final uri = _applicationUri.replace(
      queryParameters: {'userId': userId},
    );

    http.Response response;
    try {
      response = await _client.get(
        uri,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $bearerToken',
        },
      );
    } catch (_) {
      throw Exception('Unable to load applications. Please check your network connection.');
    }

    if (response.statusCode != 200) {
      throw Exception('Unable to load applications. Server returned ${response.statusCode}.');
    }

    late final List<dynamic> body;
    try {
      final decoded = jsonDecode(response.body);
      body = switch (decoded) {
        {'applications': final List<dynamic> items} => items,
        {'loanApplications': final List<dynamic> items} => items,
        {'data': {'applications': final List<dynamic> items}} => items,
        {'data': {'loanApplications': final List<dynamic> items}} => items,
        {'data': final List<dynamic> items} => items,
        List<dynamic> items => items,
        _ => throw const FormatException(),
      };
    } catch (_) {
      throw Exception('Unable to parse applications response.');
    }

    return body
        .whereType<Map<String, dynamic>>()
        .map(LoanApplication.fromJson)
        .where((application) => application.id.isNotEmpty)
        .toList();
  }

  Future<LoanStatus> fetchApplicationStatus(
    String userId,
    String applicationId,
    String bearerToken,
  ) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}/Loan/users/$userId/loan-applications/$applicationId/status',
    );

    http.Response response;
    try {
      response = await _client.get(
        uri,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $bearerToken',
        },
      );
    } catch (_) {
      throw Exception('Unable to load application status. Please check your network connection.');
    }

    if (response.statusCode != 200) {
      throw Exception('Unable to load application status. Server returned ${response.statusCode}.');
    }

    late final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Unable to parse application status response.');
    }

    return LoanStatus.fromJson(body);
  }

  Future<http.Response> uploadDocuments(
    DocumentUploadRequest request,
    String bearerToken,
  ) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/Loan/documents');

    try {
      return await _post(
        uri,
        request.toJson(),
        bearerToken,
      );
    } catch (_) {
      throw Exception('Unable to upload documents. Please check your connection.');
    }
  }

  Future<List<UploadedDocument>> fetchDocuments(
    String applicationId,
    String bearerToken,
  ) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/Loan/$applicationId/documents');

    http.Response response;
    try {
      response = await _client.get(
        uri,
        headers: _headers(bearerToken),
      );
    } catch (_) {
      throw Exception('Unable to load documents. Please check your connection.');
    }

    if (response.statusCode != 200) {
      throw Exception('Unable to load documents. Server returned ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body);
    final documents = switch (decoded) {
      {'documents': final List<dynamic> items} => items,
      {'data': {'documents': final List<dynamic> items}} => items,
      {'data': final List<dynamic> items} => items,
      List<dynamic> items => items,
      _ => throw Exception('Unable to parse documents response.'),
    };

    return documents
        .whereType<Map<String, dynamic>>()
        .map(UploadedDocument.fromJson)
        .where((document) => document.url.isNotEmpty)
        .toList();
  }

  Future<http.Response> _post(
    Uri uri,
    Map<String, dynamic> body,
    String bearerToken,
  ) {
    return _client.post(
      uri,
      headers: _headers(bearerToken, includeJsonContentType: true),
      body: jsonEncode(body),
    );
  }

  Map<String, String> _headers(
    String bearerToken, {
    bool includeJsonContentType = false,
  }) {
    final headers = {
      'accept': '*/*',
    };

    if (includeJsonContentType) {
      headers['Content-Type'] = 'application/json';
    }

    if (bearerToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }

    return headers;
  }
}
