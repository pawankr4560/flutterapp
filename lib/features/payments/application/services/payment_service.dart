import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:finhub/core/constants/app_config.dart';
import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/data/api/api_exception.dart';
import 'package:finhub/features/payments/data/models/payment_record.dart';

class PaymentService {
  PaymentService({http.Client? client})
      : _apiClient = ApiClient(client: client);

  final ApiClient _apiClient;
  final Uri _paymentsUri = Uri.parse('${AppConfig.baseUrl}/Payment/payments');
  final Uri _razorpayInitiateUri = Uri.parse(
    '${AppConfig.baseUrl}/Razorpay/emi/order',
  );

  Future<PaymentOverview> fetchPayments({
    required String userId,
    required String bearerToken,
  }) async {
    final uri = _paymentsUri.replace(queryParameters: {'userId': userId});

    final response = await _apiClient.get(uri, bearerToken: bearerToken);

    try {
      return PaymentOverview.fromJson(jsonDecode(response.body));
    } catch (_) {
      throw const ApiException('Unable to parse payments response.');
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
      throw const ApiException(
        'Loan ID or schedule ID is missing for this EMI.',
      );
    }

    final response = await _apiClient.post(
      _razorpayInitiateUri,
      bearerToken: bearerToken,
      body: {
        'loanId': loanId,
        'scheduleId': scheduleId,
      },
    );

    try {
      return RazorpayCheckoutSession.fromJson(jsonDecode(response.body));
    } catch (_) {
      throw const ApiException('Unable to parse Razorpay payment response.');
    }
  }
}


