import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/car_booking/domain/entities/vehicle.dart';

/// Compact card row for a vehicle in the rental fleet.
class CarBookingCard extends StatelessWidget {
  const CarBookingCard({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(vehicle.status);

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
                Text(vehicle.model, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  vehicle.registrationNumber,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Rs. ${vehicle.dailyRate.toStringAsFixed(0)}/day',
                  style: AppTextStyles.titleMedium(context),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _StatusBadge(label: vehicle.status, color: statusColor),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status.toLowerCase()) {
      'available' => AppColors.success,
      'booked' => AppColors.warning,
      'maintenance' => AppColors.error,
      _ => AppColors.primary,
    };
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall(context).copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
