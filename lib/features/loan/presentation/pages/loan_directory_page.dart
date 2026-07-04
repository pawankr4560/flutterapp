import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/loan/domain/entities/loan_customer.dart';
import 'package:finhub/features/loan/presentation/pages/add_loan_page.dart';
import 'package:finhub/features/loan/presentation/pages/loan_detail_page.dart';
import 'package:finhub/features/loan/presentation/providers/loan_provider.dart';
import 'package:finhub/features/loan/presentation/widgets/customer_loan_card.dart';

/// Directory page listing loan customers and portfolio summary.
class LoanDirectoryPage extends ConsumerWidget {
  const LoanDirectoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(loanCustomersProvider);
    final activeLoans = customers
        .where((customer) => customer.loanDetails.status == 'Active')
        .length;
    final totalPortfolio = customers.fold<double>(
      0,
      (total, customer) => total + customer.loanDetails.remainingAmount,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Loan Directory')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddLoan(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: customers.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: _PortfolioBanner(
                  activeLoans: activeLoans,
                  totalPortfolio: totalPortfolio,
                ),
              );
            }

            final customer = customers[index - 1];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: CustomerLoanCard(
                customer: customer,
                onTap: () => _openLoanDetail(context, customer),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openAddLoan(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AddLoanPage(),
      ),
    );
  }

  void _openLoanDetail(BuildContext context, LoanCustomer customer) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LoanDetailPage(customer: customer),
      ),
    );
  }
}

/// Summary banner for loan portfolio statistics.
class _PortfolioBanner extends StatelessWidget {
  const _PortfolioBanner({
    required this.activeLoans,
    required this.totalPortfolio,
  });

  final int activeLoans;
  final double totalPortfolio;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Portfolio',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.surface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _formatCurrency(totalPortfolio),
            style: AppTextStyles.headlineLarge(context).copyWith(
              color: AppColors.surface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Total Active Loans: $activeLoans',
            style: AppTextStyles.titleMedium(context).copyWith(
              color: AppColors.surface,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) => '₹${value.toStringAsFixed(0)}';
}
