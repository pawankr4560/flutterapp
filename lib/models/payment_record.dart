class PaymentOverview {
  const PaymentOverview({
    this.nextDuePayment,
    required this.payments,
  });

  final PaymentRecord? nextDuePayment;
  final List<PaymentRecord> payments;

  factory PaymentOverview.fromJson(dynamic json) {
    final payload = json is Map<String, dynamic> && json['data'] != null
        ? json['data']
        : json;

    if (payload is List<dynamic>) {
      final payments = _parsePayments(payload);
      return PaymentOverview(
        nextDuePayment: _findNextDuePayment(payments),
        payments: payments,
      );
    }

    if (payload is Map<String, dynamic>) {
      final payments = _parsePayments(
        payload['payments'] ??
            payload['paymentHistory'] ??
            payload['transactions'] ??
            const [],
      );
      final nextDueJson = payload['nextDuePayment'] ??
          payload['nextPayment'] ??
          payload['nextEmi'];

      return PaymentOverview(
        nextDuePayment: nextDueJson is Map<String, dynamic>
            ? PaymentRecord.fromJson(nextDueJson)
            : _findNextDuePayment(payments),
        payments: payments,
      );
    }

    return const PaymentOverview(payments: []);
  }

  static List<PaymentRecord> _parsePayments(dynamic value) {
    if (value is! List<dynamic>) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(PaymentRecord.fromJson)
        .toList();
  }

  static PaymentRecord? _findNextDuePayment(List<PaymentRecord> payments) {
    for (final payment in payments) {
      final status = payment.status.toLowerCase();
      if (status == 'pending' || status == 'due' || status == 'upcoming') {
        return payment;
      }
    }

    return null;
  }
}

class PaymentRecord {
  const PaymentRecord({
    required this.title,
    required this.amount,
    required this.status,
    this.date,
    this.dueDate,
    this.applicationId,
    this.transactionId,
    this.loanId,
    this.scheduleId,
  });

  final String title;
  final double amount;
  final String status;
  final DateTime? date;
  final DateTime? dueDate;
  final String? applicationId;
  final String? transactionId;
  final int? loanId;
  final int? scheduleId;

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    final amountValue =
        json['amount'] ?? json['emiAmount'] ?? json['paymentAmount'] ?? 0;

    return PaymentRecord(
      title: _readString(json, ['title', 'type', 'paymentType']) ?? 'Payment',
      amount: amountValue is num
          ? amountValue.toDouble()
          : double.tryParse('$amountValue') ?? 0,
      status: _readString(json, ['status']) ?? '',
      date: _readDate(json, ['date', 'paidAt', 'paymentDate', 'createdAt']),
      dueDate: _readDate(json, ['dueDate', 'emiDueDate']),
      applicationId: _readString(json, ['applicationId', 'loanApplicationId']),
      transactionId: _readString(json, ['transactionId', 'id', 'paymentId']),
      loanId: _readInt(json, ['loanId', 'loan_id']),
      scheduleId: _readInt(json, ['scheduleId', 'schedule_id', 'emiScheduleId']),
    );
  }

  DateTime? get displayDate => date ?? dueDate;

  bool get canInitiatePayment => loanId != null && scheduleId != null;

  bool get isCompleted => status.toLowerCase() == 'completed' ||
      status.toLowerCase() == 'paid' ||
      status.toLowerCase() == 'success';

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  static DateTime? _readDate(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }

    return null;
  }

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String && value.isNotEmpty) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }

    return null;
  }
}

class RazorpayCheckoutSession {
  const RazorpayCheckoutSession({
    required this.checkoutUrl,
    this.orderId,
    this.paymentLinkId,
  });

  final String checkoutUrl;
  final String? orderId;
  final String? paymentLinkId;

  factory RazorpayCheckoutSession.fromJson(dynamic json) {
    final payload = json is Map<String, dynamic> && json['data'] != null
        ? json['data']
        : json;

    if (payload is! Map<String, dynamic>) {
      throw const FormatException('Invalid Razorpay checkout response.');
    }

    final checkoutUrl = PaymentRecord._readString(payload, [
      'checkoutUrl',
      'paymentUrl',
      'paymentLink',
      'shortUrl',
      'short_url',
      'url',
    ]);

    if (checkoutUrl == null || checkoutUrl.isEmpty) {
      throw const FormatException('Razorpay checkout URL is missing.');
    }

    return RazorpayCheckoutSession(
      checkoutUrl: checkoutUrl,
      orderId: PaymentRecord._readString(payload, ['orderId', 'order_id']),
      paymentLinkId: PaymentRecord._readString(
        payload,
        ['paymentLinkId', 'payment_link_id', 'id'],
      ),
    );
  }
}
