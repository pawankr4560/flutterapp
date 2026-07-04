import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';

/// Reports tab for dashboard business insights.
class ReportsTab extends StatelessWidget {
  const ReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Reports', style: AppTextStyles.headlineLarge(context)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Track performance across all active businesses.',
          style: AppTextStyles.bodyLarge(context).copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: const [
            _ReportMetric(
              label: 'Monthly income',
              value: 'Rs. 2,84,600',
              icon: Icons.trending_up_rounded,
              color: AppColors.success,
            ),
            _ReportMetric(
              label: 'Pending collections',
              value: 'Rs. 38,400',
              icon: Icons.pending_actions_rounded,
              color: AppColors.warning,
            ),
            _ReportMetric(
              label: 'Active bookings',
              value: '12',
              icon: Icons.event_available_rounded,
              color: AppColors.primary,
            ),
            _ReportMetric(
              label: 'Inventory alerts',
              value: '3',
              icon: Icons.inventory_2_rounded,
              color: AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Business breakdown', style: AppTextStyles.titleLarge(context)),
        const SizedBox(height: AppSpacing.md),
        const _BreakdownTile(
          title: 'Loan Management',
          subtitle: 'EMI collected this month',
          amount: 'Rs. 96,000',
          progress: 0.78,
          color: AppColors.primary,
        ),
        const _BreakdownTile(
          title: 'Inventory',
          subtitle: 'Current stock value',
          amount: 'Rs. 2,84,600',
          progress: 0.64,
          color: AppColors.success,
        ),
        const _BreakdownTile(
          title: 'Dairy Collection',
          subtitle: 'Milk payout pending',
          amount: 'Rs. 12,800',
          progress: 0.42,
          color: AppColors.secondary,
        ),
        const _BreakdownTile(
          title: 'Car Booking',
          subtitle: 'Rental revenue',
          amount: 'Rs. 38,400',
          progress: 0.56,
          color: AppColors.warning,
        ),
      ],
    );
  }
}

class _ReportMetric extends StatelessWidget {
  const _ReportMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSpacing.xl,
              height: AppSpacing.xl,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Icon(icon, color: color, size: AppSpacing.lg),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(value, style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: AppSpacing.xxs),
            Text(label, style: AppTextStyles.bodyMedium(context)),
          ],
        ),
      ),
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.progress,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String amount;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMedium(context)),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(subtitle, style: AppTextStyles.bodyMedium(context)),
                  ],
                ),
              ),
              Text(amount, style: AppTextStyles.titleMedium(context)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: progress,
            minHeight: AppSpacing.xs,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            backgroundColor: AppColors.border,
            color: color,
          ),
        ],
      ),
    );
  }
}
