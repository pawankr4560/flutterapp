class LoanApplication {
  const LoanApplication({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.stepsCompleted,
  });

  final String id;
  final String type;
  final double amount;
  final String status;
  final int stepsCompleted;
}
