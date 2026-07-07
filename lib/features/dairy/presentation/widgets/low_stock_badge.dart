part of '../pages/milk_directory_page.dart';

class _LowStockBadge extends StatelessWidget {
  const _LowStockBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        'Low',
        style: AppTextStyles.bodySmall(
          context,
        ).copyWith(color: AppColors.warning, fontWeight: FontWeight.w700),
      ),
    );
  }
}

