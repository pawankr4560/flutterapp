import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/inventory/domain/entities/inventory_item.dart';
import 'package:finhub/features/inventory/presentation/providers/inventory_provider.dart';

/// Product stock row with fast increment and decrement actions.
class InventoryItemCard extends ConsumerWidget {
  const InventoryItemCard({super.key, required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(item.category, style: AppTextStyles.bodyMedium(context)),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Stock: ${item.currentStock} items',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: item.isLowStock
                            ? AppColors.error
                            : AppColors.textSecondary,
                      ),
                    ),
                    if (item.isLowStock) const _LowStockBadge(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _StockButton(
            icon: Icons.remove_rounded,
            enabled: item.currentStock > 0,
            onTap: () => ref
                .read(inventoryProvider.notifier)
                .updateStock(item.id, item.currentStock - 1),
          ),
          const SizedBox(width: AppSpacing.xs),
          _StockButton(
            icon: Icons.add_rounded,
            onTap: () => ref
                .read(inventoryProvider.notifier)
                .updateStock(item.id, item.currentStock + 1),
          ),
        ],
      ),
    );
  }
}

class _LowStockBadge extends StatelessWidget {
  const _LowStockBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        'Low Stock',
        style: AppTextStyles.labelLarge(context).copyWith(
          color: AppColors.error,
        ),
      ),
    );
  }
}

class _StockButton extends StatelessWidget {
  const _StockButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.primary : AppColors.border,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: SizedBox.square(
          dimension: AppSpacing.xl,
          child: Icon(
            icon,
            color: enabled ? AppColors.surface : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
