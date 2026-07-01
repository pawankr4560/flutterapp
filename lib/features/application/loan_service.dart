import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../models/loan_application.dart';
import '../../models/loan_status.dart';
import 'document_requests.dart';
import 'loan_requests.dart';

class LoanService {
  LoanService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final Uri _applicationUri = Uri.parse('${AppConfig.baseUrl}/Loan/loan-applications');

  Future<http.Response> submitApplication(
    LoanApplicationRequest request,
    String bearerToken,
  ) {
    return _post(
      _applicationUri,
      request.toJson(),
      bearerToken,
    );
  }

  Future<List<LoanApplication>> fetchApplications(
    String userId,
    String bearerToken,
  ) async {
    final uri = _applicationUri.replace(
      queryParameters: {'userId': userId},
    );

    final response = await _client.get(
      uri,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $bearerToken',
      },
    );

    final body = jsonDecode(response.body) as List<dynamic>?;
    if (body == null) {
      return [];
    }

    return body
        .map((item) => LoanApplication.fromJson(item as Map<String, dynamic>))
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

    final response = await _client.get(
      uri,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $bearerToken',
      },
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return LoanStatus.fromJson(body);
  }

  Future<http.Response> uploadDocuments(
    DocumentUploadRequest request,
  ) {
    final uri = Uri.parse('${AppConfig.baseUrl}/Loan/documents');

    return _post(
      uri,
      request.toJson(),
      '',
      includeAuthorization: false,
    );
  }

  Future<http.Response> _post(
    Uri uri,
    Map<String, dynamic> body,
    String bearerToken,
    {
    bool includeAuthorization = true,
  }
  ) {
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
    };

    if (includeAuthorization && bearerToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }

    return _client.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
