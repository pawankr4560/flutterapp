import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:finhub/core/constants/app_config.dart';
import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/data/api/api_exception.dart';
import 'package:finhub/features/loan/data/models/loan_application.dart';
import 'package:finhub/features/loan/data/models/loan_status.dart';
import 'package:finhub/features/loan/data/models/uploaded_document.dart';
import 'package:finhub/features/loan/data/models/document_requests.dart';
import 'package:finhub/features/loan/data/models/loan_requests.dart';

class LoanService {
  LoanService({http.Client? client}) : _apiClient = ApiClient(client: client);

  final ApiClient _apiClient;
  final Uri _applicationUri = Uri.parse(
    '${AppConfig.baseUrl}/Loan/loan-applications',
  );

  Future<http.Response> submitApplication(
    LoanApplicationRequest request,
    String bearerToken,
  ) async {
    return _post(_applicationUri, request.toJson(), bearerToken);
  }

  Future<List<LoanApplication>> fetchApplications(
    String userId,
    String bearerToken,
  ) async {
    final uri = _applicationUri.replace(
      queryParameters: {'userId': userId},
    );

    final response = await _apiClient.get(uri, bearerToken: bearerToken);

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
      throw const ApiException('Unable to parse applications response.');
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

    final response = await _apiClient.get(uri, bearerToken: bearerToken);

    late final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const ApiException('Unable to parse application status response.');
    }

    return LoanStatus.fromJson(body);
  }

  Future<http.Response> uploadDocuments(
    DocumentUploadRequest request,
    String bearerToken,
  ) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/Loan/documents');

    return _post(uri, request.toJson(), bearerToken);
  }

  Future<List<UploadedDocument>> fetchDocuments(
    String applicationId,
    String bearerToken,
  ) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/Loan/$applicationId/documents');

    final response = await _apiClient.get(uri, bearerToken: bearerToken);

    late final List<dynamic> documents;
    try {
      final decoded = jsonDecode(response.body);
      documents = switch (decoded) {
        {'documents': final List<dynamic> items} => items,
        {'data': {'documents': final List<dynamic> items}} => items,
        {'data': final List<dynamic> items} => items,
        List<dynamic> items => items,
        _ => throw const FormatException(),
      };
    } catch (_) {
      throw const ApiException('Unable to parse documents response.');
    }

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
    return _apiClient.send(
      'POST',
      uri,
      headers: _headers(bearerToken, includeJsonContentType: true),
      body: body,
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


