class LoanApplication {
  const LoanApplication({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.stepsCompleted,
    this.submittedDate,
  });

  final String id;
  final String type;
  final double amount;
  final String status;
  final int stepsCompleted;
  final DateTime? submittedDate;

  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    final amountValue = json['amount'] ?? json['amountRequested'] ?? json['loanAmount'];
    final amount = amountValue is num
        ? amountValue.toDouble()
        : double.tryParse('$amountValue') ?? 0.0;

    DateTime? submittedDate;
    final rawDate = json['submittedDate'] ?? json['createdAt'] ?? json['appliedDate'];
    if (rawDate is String && rawDate.isNotEmpty) {
      submittedDate = DateTime.tryParse(rawDate);
    }

    return LoanApplication(
      id: json['applicationId']?.toString() ??
          json['id']?.toString() ??
          json['loanApplicationId']?.toString() ??
          '',
      type: json['loanType']?.toString() ?? json['type']?.toString() ?? '',
      amount: amount,
      status: json['status']?.toString() ?? '',
      stepsCompleted: json['stepsCompleted'] is int
          ? json['stepsCompleted'] as int
          : int.tryParse('${json['stepsCompleted']}') ?? 0,
      submittedDate: submittedDate,
    );
  }
}
