import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/loan/domain/entities/loan_customer.dart';

/// Premium list item showing a customer's active loan summary.
class CustomerLoanCard extends StatelessWidget {
  const CustomerLoanCard({
    super.key,
    required this.customer,
    this.onTap,
  });

  final LoanCustomer customer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(customer.loanDetails.status);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppRadius.xl,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            foregroundColor: AppColors.primary,
            child: Text(_initials(customer.name)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        customer.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium(context),
                      ),
                    ),
                    _StatusBadge(
                      label: customer.loanDetails.status,
                      color: statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  customer.phoneNumber,
                  style: AppTextStyles.bodyMedium(context),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Remaining ${_formatCurrency(customer.loanDetails.remainingAmount)}',
                  style: AppTextStyles.bodyLarge(context),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status.toLowerCase()) {
      'active' => AppColors.success,
      'overdue' => AppColors.warning,
      'closed' => AppColors.textSecondary,
      _ => AppColors.primary,
    };
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  String _formatCurrency(double value) {
    return '₹${value.toStringAsFixed(0)}';
  }
}

/// Small status badge used by customer loan cards.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall(context).copyWith(color: color),
      ),
    );
  }
}
