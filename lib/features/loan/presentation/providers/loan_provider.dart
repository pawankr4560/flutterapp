import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/loan_customer.dart';
import '../../domain/entities/loan_detail.dart';
import '../../domain/entities/loan_transaction.dart';

/// Provides and mutates loan customers for the Loan Management module.
final loanCustomersProvider =
    NotifierProvider<LoanCustomersNotifier, List<LoanCustomer>>(
  LoanCustomersNotifier.new,
);

/// Manages the in-memory loan customer directory.
class LoanCustomersNotifier extends Notifier<List<LoanCustomer>> {
  @override
  List<LoanCustomer> build() {
    final now = DateTime.now();

    return [
      LoanCustomer(
        id: 'customer-rahul-sharma',
        name: 'Rahul Sharma',
        phoneNumber: '+91 98765 43210',
        profilePicUrl: '',
        loanDetails: LoanDetail(
          loanId: 'LN-RAHUL-001',
          principalAmount: 50000,
          interestRate: 12.5,
          tenureMonths: 12,
          remainingAmount: 37500,
          nextEmiAmount: 4580,
          nextEmiDate: now.add(const Duration(days: 5)),
          status: 'Active',
        ),
      ),
      LoanCustomer(
        id: 'customer-amit-verma',
        name: 'Amit Verma',
        phoneNumber: '+91 99887 76655',
        profilePicUrl: '',
        loanDetails: LoanDetail(
          loanId: 'LN-AMIT-002',
          principalAmount: 120000,
          interestRate: 14,
          tenureMonths: 24,
          remainingAmount: 108000,
          nextEmiAmount: 6200,
          nextEmiDate: now.subtract(const Duration(days: 2)),
          status: 'Overdue',
        ),
      ),
      LoanCustomer(
        id: 'customer-priya-patel',
        name: 'Priya Patel',
        phoneNumber: '+91 91234 56780',
        profilePicUrl: '',
        loanDetails: LoanDetail(
          loanId: 'LN-PRIYA-003',
          principalAmount: 30000,
          interestRate: 11.75,
          tenureMonths: 6,
          remainingAmount: 20000,
          nextEmiAmount: 5300,
          nextEmiDate: now.add(const Duration(days: 10)),
          status: 'Active',
        ),
      ),
    ];
  }

  void addCustomer(LoanCustomer customer) {
    state = [...state, customer];
  }

  void payEmi(String customerId, double amountPaid) {
    final paidAt = DateTime.now();
    final transaction = LoanTransaction(
      transactionId: 'TXN-${paidAt.microsecondsSinceEpoch}',
      amountPaid: amountPaid,
      paymentDate: paidAt,
      paymentMode: 'Cash',
    );

    state = [
      for (final customer in state)
        if (customer.id == customerId)
          LoanCustomer(
            id: customer.id,
            name: customer.name,
            phoneNumber: customer.phoneNumber,
            profilePicUrl: customer.profilePicUrl,
            loanDetails: LoanDetail(
              loanId: customer.loanDetails.loanId,
              principalAmount: customer.loanDetails.principalAmount,
              interestRate: customer.loanDetails.interestRate,
              tenureMonths: customer.loanDetails.tenureMonths,
              remainingAmount:
                  (customer.loanDetails.remainingAmount - amountPaid)
                      .clamp(0, double.infinity)
                      .toDouble(),
              nextEmiAmount: customer.loanDetails.nextEmiAmount,
              nextEmiDate: DateTime.now().add(const Duration(days: 30)),
              status: 'Active',
            ),
            transactions: [...customer.transactions, transaction],
          )
        else
          customer,
    ];
  }
}
