import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/loan/domain/entities/loan_customer.dart';
import 'package:finhub/features/loan/domain/entities/loan_transaction.dart';
import 'package:finhub/features/loan/presentation/providers/loan_provider.dart';
import 'package:finhub/features/loan/presentation/widgets/repayment_dialog.dart';
/// Displays live loan details, EMI collection, and payment history.
class LoanDetailPage extends ConsumerWidget {
  const LoanDetailPage({super.key, required this.customer});
  final LoanCustomer customer;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveCustomer = ref.watch(loanCustomersProvider).firstWhere(
          (item) => item.id == customer.id,
          orElse: () => customer,
        );
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Details')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _header(context, liveCustomer),
            const SizedBox(height: AppSpacing.lg),
            _metrics(context, liveCustomer),
            const SizedBox(height: AppSpacing.lg),
            _nextEmi(context, liveCustomer),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: 'Collect EMI Payment',
              icon: Icons.payments_rounded,
              onPressed: () => _collectEmi(context, ref, liveCustomer),
            ),
            const SizedBox(height: AppSpacing.xl),
            _history(context, liveCustomer),
          ],
        ),
      ),
    );
  }
  Future<void> _collectEmi(BuildContext context, WidgetRef ref, LoanCustomer liveCustomer) async {
    final amount = await showDialog<double>(
      context: context,
      builder: (_) => RepaymentDialog(initialAmount: liveCustomer.loanDetails.nextEmiAmount),
    );
    if (amount != null) {
      ref.read(loanCustomersProvider.notifier).payEmi(liveCustomer.id, amount);
    }
  }
  Widget _header(BuildContext context, LoanCustomer customer) {
    return AppCard(
      child: Row(children: [
        CircleAvatar(
          radius: AppRadius.xl, backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          child: Text(_initials(customer.name)),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(customer.name, style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: AppSpacing.xxs),
            Text(customer.phoneNumber, style: AppTextStyles.bodyMedium(context)),
          ]),
        ),
      ]),
    );
  }
  Widget _metrics(BuildContext context, LoanCustomer customer) {
    final loan = customer.loanDetails;
    final metrics = [
      ('Principal Amount', money(loan.principalAmount)),
      ('Remaining Principal', money(loan.remainingAmount)),
      ('Interest Rate', '${loan.interestRate.toStringAsFixed(2)}%'),
      ('Tenure', '${loan.tenureMonths} months'),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= AppSpacing.xxl * 10 ? 4 : 2;
      final width = (constraints.maxWidth - AppSpacing.md * (columns - 1)) /
          columns;
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          for (final metric in metrics)
            SizedBox(
                width: width, child: _metricCard(context, metric.$1, metric.$2)),
        ],
      );
    });
  }
  Widget _metricCard(BuildContext context, String title, String value) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.bodyMedium(context)),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTextStyles.titleMedium(context)),
      ]),
    );
  }
  Widget _nextEmi(BuildContext context, LoanCustomer customer) {
    final loan = customer.loanDetails;
    return AppCard(
      backgroundColor: AppColors.warning.withValues(alpha: 0.08),
      child: Row(children: [
        const Icon(Icons.calendar_month_rounded, color: AppColors.warning),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Next EMI Details', style: AppTextStyles.titleMedium(context)),
            const SizedBox(height: AppSpacing.xxs),
            Text('${money(loan.nextEmiAmount)} due on ${date(loan.nextEmiDate)}',
                style: AppTextStyles.bodyMedium(context)),
          ]),
        ),
        Icon(Icons.circle,
            color: loan.status.toLowerCase() == 'overdue'
                ? AppColors.warning
                : AppColors.success,
            size: AppSpacing.sm),
      ]),
    );
  }
  Widget _history(BuildContext context, LoanCustomer customer) {
    final transactions = customer.transactions.reversed.toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Payment History', style: AppTextStyles.titleLarge(context)),
      const SizedBox(height: AppSpacing.md),
      if (transactions.isEmpty)
        Text('No payments recorded yet.', style: AppTextStyles.bodyMedium(context))
      else
        AppCard(
          padding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.border),
            itemBuilder: (_, index) =>
                _transactionTile(context, customer, transactions[index]),
          ),
        ),
    ]);
  }
  Widget _transactionTile(BuildContext context, LoanCustomer customer,
      LoanTransaction transaction) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      title: Text('+${money(transaction.amountPaid)}',
          style: AppTextStyles.titleMedium(context)
              .copyWith(color: AppColors.success)),
      subtitle: Text(
          '${transaction.paymentMode} • ${date(transaction.paymentDate)}',
          style: AppTextStyles.bodyMedium(context)),
      trailing: IconButton(
        tooltip: 'Share receipt',
        icon: const Icon(Icons.share_rounded),
        color: AppColors.primary,
        onPressed: () => _shareReceipt(context, customer, transaction),
      ),
    );
  }
  void _shareReceipt(BuildContext context, LoanCustomer customer,
      LoanTransaction transaction) {
    final receipt = '''
FinHub Payment Receipt
Customer: ${customer.name}
Amount Paid: ${money(transaction.amountPaid)}
Payment Mode: ${transaction.paymentMode}
Date: ${date(transaction.paymentDate)}
Transaction ID: ${transaction.transactionId}
Remaining Principal: ${money(customer.loanDetails.remainingAmount)}
''';
    debugPrint(receipt);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Receipt ready to share for ${customer.name}')),
    );
  }
  static String money(double value) => '₹${value.toStringAsFixed(0)}';
  static String date(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }
  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
