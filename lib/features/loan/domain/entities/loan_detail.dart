/// Immutable loan account details for a customer.
class LoanDetail {
  const LoanDetail({
    required this.loanId,
    required this.principalAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.remainingAmount,
    required this.nextEmiAmount,
    required this.nextEmiDate,
    required this.status,
  });

  final String loanId;
  final double principalAmount;
  final double interestRate;
  final int tenureMonths;
  final double remainingAmount;
  final double nextEmiAmount;
  final DateTime nextEmiDate;
  final String status;
}
