part of '../pages/inventory_directory_page.dart';

class ConstructionStatusBadge extends StatelessWidget {
  const ConstructionStatusBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = switch (label.toLowerCase()) {
      'pending' => AppColors.warning,
      'confirmed' || 'out for delivery' || 'loading' => AppColors.textSecondary,
      'delivered' || 'available' => AppColors.success,
      'cancelled' => AppColors.error,
      _ => AppColors.accentDark,
    };
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
        style: AppTextStyles.bodySmall(
          context,
        ).copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
