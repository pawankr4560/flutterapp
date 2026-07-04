import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dairy/domain/entities/milk_collection_log.dart';

/// Compact row for a single dairy milk collection log.
class CollectionLogCard extends StatelessWidget {
  const CollectionLogCard({super.key, required this.log});

  final MilkCollectionLog log;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.farmerName, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${log.quantityInLiters.toStringAsFixed(1)} L - '
                  '${log.fatPercentage.toStringAsFixed(1)}% fat',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _ShiftBadge(shift: log.shift),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _formatCurrency(log.totalAmount),
                style: AppTextStyles.titleMedium(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) => 'Rs. ${value.toStringAsFixed(0)}';
}

class _ShiftBadge extends StatelessWidget {
  const _ShiftBadge({required this.shift});

  final String shift;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Text(
        shift,
        style: AppTextStyles.bodySmall(context).copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
