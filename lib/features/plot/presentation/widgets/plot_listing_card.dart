import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/plot/domain/entities/plot_listing.dart';

/// Card row for a single plot listing.
class PlotListingCard extends StatelessWidget {
  const PlotListingCard({
    super.key,
    required this.plot,
    this.onBookVisit,
  });

  final PlotListing plot;
  final VoidCallback? onBookVisit;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(plot.status);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.xxl,
                height: AppSpacing.xxl,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(Icons.map_rounded, color: statusColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${plot.projectName} - ${plot.plotNumber}',
                      style: AppTextStyles.titleMedium(context),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${plot.location} - ${plot.facing} facing',
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${plot.areaSqFt.toStringAsFixed(0)} sq.ft',
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatusBadge(label: plot.status, color: statusColor),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _formatCurrency(plot.price),
                    style: AppTextStyles.titleMedium(context),
                  ),
                ],
              ),
            ],
          ),
          if (plot.isAvailable && onBookVisit != null) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onBookVisit,
                icon: const Icon(Icons.event_available_rounded),
                label: const Text('Book site visit'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status.toLowerCase()) {
      'available' => AppColors.success,
      'booked' => AppColors.warning,
      'sold' => AppColors.error,
      _ => AppColors.primary,
    };
  }

  String _formatCurrency(double value) {
    if (value >= 100000) {
      return 'Rs. ${(value / 100000).toStringAsFixed(1)}L';
    }

    return 'Rs. ${value.toStringAsFixed(0)}';
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
