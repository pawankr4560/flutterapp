/// Immutable record for a single loan repayment transaction.
class LoanTransaction {
  const LoanTransaction({
    required this.transactionId,
    required this.amountPaid,
    required this.paymentDate,
    required this.paymentMode,
  });

  final String transactionId;
  final double amountPaid;
  final DateTime paymentDate;
  final String paymentMode;
}
