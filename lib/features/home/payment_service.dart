import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../models/payment_record.dart';

class PaymentService {
  PaymentService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final Uri _paymentsUri = Uri.parse('${AppConfig.baseUrl}/Payment/payments');
  final Uri _razorpayInitiateUri = Uri.parse(
    '${AppConfig.baseUrl}/Razorpay/emi/order',
  );

  Future<PaymentOverview> fetchPayments({
    required String userId,
    required String bearerToken,
  }) async {
    final uri = _paymentsUri.replace(queryParameters: {'userId': userId});

    http.Response response;
    try {
      response = await _client.get(
        uri,
        headers: {
          'accept': '*/*',
          if (bearerToken.isNotEmpty) 'Authorization': 'Bearer $bearerToken',
        },
      );
    } catch (_) {
      throw Exception('Unable to load payments. Please check your connection.');
    }

    if (response.statusCode != 200) {
      throw Exception('Unable to load payments. Server returned ${response.statusCode}.');
    }

    try {
      return PaymentOverview.fromJson(jsonDecode(response.body));
    } catch (_) {
      throw Exception('Unable to parse payments response.');
    }
  }

  Future<RazorpayCheckoutSession> initiateRazorpayPayment({
    required String userId,
    required String bearerToken,
    required PaymentRecord payment,
  }) async {
    final loanId = payment.loanId;
    final scheduleId = payment.scheduleId;
    if (loanId == null || scheduleId == null) {
      throw Exception('Loan ID or schedule ID is missing for this EMI.');
    }

    http.Response response;
    try {
      response = await _client.post(
        _razorpayInitiateUri,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          if (bearerToken.isNotEmpty) 'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode({
          'loanId': loanId,
          'scheduleId': scheduleId,
        }),
      );
    } catch (_) {
      throw Exception('Unable to start Razorpay payment. Please check your connection.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to start Razorpay payment. Server returned ${response.statusCode}.');
    }

    try {
      return RazorpayCheckoutSession.fromJson(jsonDecode(response.body));
    } catch (_) {
      throw Exception('Unable to parse Razorpay payment response.');
    }
  }
}
