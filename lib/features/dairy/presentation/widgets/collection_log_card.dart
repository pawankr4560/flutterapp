import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dairy/domain/entities/milk_collection_log.dart';

/// Card row for a single dairy milk collection log.
class CollectionLogCard extends StatelessWidget {
  const CollectionLogCard({super.key, required this.log});

  final MilkCollectionLog log;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.farmerName, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _ShiftBadge(shift: log.shift),
                    Text(_formatDate(log.date),
                        style: AppTextStyles.bodySmall(context)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${log.quantityInLiters.toStringAsFixed(1)} L',
                  style: AppTextStyles.titleMedium(context)),
              const SizedBox(height: AppSpacing.xxs),
              Text('${log.fatPercentage.toStringAsFixed(1)}% Fat',
                  style: AppTextStyles.bodySmall(context)),
              const SizedBox(height: AppSpacing.sm),
              Text(_formatCurrency(log.totalAmount),
                  style: AppTextStyles.titleMedium(context).copyWith(
                    color: AppColors.success,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) => '₹${value.toStringAsFixed(2)}';

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _ShiftBadge extends StatelessWidget {
  const _ShiftBadge({required this.shift});

  final String shift;

  @override
  Widget build(BuildContext context) {
    final isMorning = shift.toLowerCase() == 'morning';
    final color = isMorning ? AppColors.warning : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        shift,
        style: AppTextStyles.labelLarge(context).copyWith(color: color),
      ),
    );
  }
}
