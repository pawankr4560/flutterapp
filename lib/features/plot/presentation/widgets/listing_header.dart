part of '../pages/plot_directory_page.dart';

class _ListingHeader extends StatelessWidget {
  const _ListingHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommended Plots',
                style: AppTextStyles.titleLarge(context),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '$count verified options near you',
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            'SmartSathi',
            style: AppTextStyles.bodySmall(
              context,
            ).copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

