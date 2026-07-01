import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  static const _paymentHistory = [
    _PaymentItem(title: 'EMI payment', date: '27 Jun 2026', amount: '₹15,400', status: 'Completed'),
    _PaymentItem(title: 'Processing fee', date: '12 Jun 2026', amount: '₹1,200', status: 'Completed'),
    _PaymentItem(title: 'EMI payment', date: '28 May 2026', amount: '₹15,400', status: 'Completed'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Payment overview',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Next due payment',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    '₹15,400',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Due in 8 days',
                    style: TextStyle(fontSize: 14, color: AppColors.accent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Recent payments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._paymentHistory.map(
              (payment) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _PaymentCard(payment: payment),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Pay next EMI',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final _PaymentItem payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  payment.date,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                payment.amount,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                payment.status,
                style: TextStyle(
                  color: payment.status == 'Completed' ? AppColors.accent : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentItem {
  const _PaymentItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
  });

  final String title;
  final String date;
  final String amount;
  final String status;
}
