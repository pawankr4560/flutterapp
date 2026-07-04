import 'loan_detail.dart';
import 'loan_transaction.dart';

/// Immutable loan customer profile with current loan details.
class LoanCustomer {
  const LoanCustomer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.profilePicUrl,
    required this.loanDetails,
    this.transactions = const [],
  });

  final String id;
  final String name;
  final String phoneNumber;
  final String profilePicUrl;
  final LoanDetail loanDetails;
  final List<LoanTransaction> transactions;
}
