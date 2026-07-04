import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/inventory/presentation/pages/add_product_page.dart';
import 'package:finhub/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:finhub/features/inventory/presentation/widgets/inventory_item_card.dart';

/// Directory page for stock overview and fast inventory adjustments.
class InventoryDirectoryPage extends ConsumerWidget {
  const InventoryDirectoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inventoryProvider);
    final lowStockCount = items.where((item) => item.isLowStock).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Directory')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AddProductPage()),
        ),
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: items.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _LowStockSummary(
                lowStockCount: lowStockCount,
                totalItems: items.length,
              );
            }

            return InventoryItemCard(item: items[index - 1]);
          },
        ),
      ),
    );
  }
}

class _LowStockSummary extends StatelessWidget {
  const _LowStockSummary({
    required this.lowStockCount,
    required this.totalItems,
  });

  final int lowStockCount;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    final hasLowStock = lowStockCount > 0;

    return AppCard(
      backgroundColor: hasLowStock
          ? AppColors.warning.withValues(alpha: 0.12)
          : AppColors.success.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            hasLowStock
                ? Icons.warning_amber_rounded
                : Icons.check_circle_rounded,
            color: hasLowStock ? AppColors.warning : AppColors.success,
            size: AppSpacing.xl,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$lowStockCount Low Stock Products',
                  style: AppTextStyles.titleLarge(context),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '$totalItems products tracked in inventory',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
