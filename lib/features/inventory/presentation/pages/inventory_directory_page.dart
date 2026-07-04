import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/inventory/domain/entities/inventory_item.dart';
import 'package:finhub/features/inventory/presentation/pages/add_product_page.dart';
import 'package:finhub/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:finhub/features/inventory/presentation/widgets/inventory_item_card.dart';

/// Directory page for stock overview and inventory filters.
class InventoryDirectoryPage extends ConsumerStatefulWidget {
  const InventoryDirectoryPage({super.key});

  @override
  ConsumerState<InventoryDirectoryPage> createState() =>
      _InventoryDirectoryPageState();
}

class _InventoryDirectoryPageState extends ConsumerState<InventoryDirectoryPage> {
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(inventoryProvider);
    final filteredItems = _selectedStatus == 'All'
        ? items
        : items.where((item) => item.stockStatus == _selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Inventory', style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: AppSpacing.md),
            _InventoryFilters(
              selectedStatus: _selectedStatus,
              onChanged: (status) => setState(() => _selectedStatus = status),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Add product',
                    icon: Icons.add_rounded,
                    isPrimary: true,
                    onTap: _openAddProduct,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ActionButton(
                    label: 'Summary',
                    icon: Icons.summarize_rounded,
                    onTap: () => _openSummary(items),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (filteredItems.isEmpty)
              _EmptyInventory(status: _selectedStatus)
            else
              for (final item in filteredItems) ...[
                InventoryItemCard(item: item),
                const SizedBox(height: AppSpacing.sm),
              ],
          ],
        ),
      ),
    );
  }

  void _openAddProduct() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AddProductPage()),
    );
  }

  void _openSummary(List<InventoryItem> items) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => InventorySummaryPage(items: items),
      ),
    );
  }
}

/// Summary screen for inventory value and restocking needs.
class InventorySummaryPage extends StatelessWidget {
  const InventorySummaryPage({super.key, required this.items});

  final List<InventoryItem> items;

  @override
  Widget build(BuildContext context) {
    final stockValue = items.fold<double>(
      0,
      (total, item) => total + item.currentStock * item.sellingPrice,
    );
    final lowStockItems = items.where((item) {
      return item.isLowStock && !item.isOutOfStock;
    }).toList();
    final outOfStockItems = items.where((item) => item.isOutOfStock).toList();
    final restockItems = [...lowStockItems, ...outOfStockItems];

    return Scaffold(
      appBar: AppBar(title: const Text('Stock summary')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Stock summary', style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _SummaryMetric(label: 'Total items', value: '${items.length}'),
                _SummaryMetric(
                  label: 'Total stock value',
                  value: _formatCurrency(stockValue),
                ),
                _SummaryMetric(
                  label: 'Low stock alerts',
                  value: '${lowStockItems.length}',
                  valueColor: AppColors.warning,
                ),
                _SummaryMetric(
                  label: 'Out of stock',
                  value: '${outOfStockItems.length}',
                  valueColor: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Needs restocking', style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: AppSpacing.md),
            if (restockItems.isEmpty)
              _EmptyInventory(status: 'restocking')
            else
              for (final item in restockItems) ...[
                _RestockTile(item: item),
                const SizedBox(height: AppSpacing.sm),
              ],
          ],
        ),
      ),
    );
  }
}

class _InventoryFilters extends StatelessWidget {
  const _InventoryFilters({
    required this.selectedStatus,
    required this.onChanged,
  });

  final String selectedStatus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final status in const [
            'All',
            'In stock',
            'Low stock',
            'Out of stock',
          ]) ...[
            ChoiceChip(
              label: Text(status),
              selected: selectedStatus == status,
              onSelected: (_) => onChanged(status),
              labelStyle: AppTextStyles.bodyLarge(context).copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              selectedColor: AppColors.primary.withValues(alpha: 0.12),
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                side: const BorderSide(color: AppColors.border),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.xxl,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : AppColors.surface,
          foregroundColor: isPrimary ? AppColors.surface : AppColors.primary,
          side: BorderSide(
            color: isPrimary ? AppColors.primary : AppColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          textStyle: AppTextStyles.labelLarge(context),
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

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
            Text(label, style: AppTextStyles.bodyMedium(context)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: AppTextStyles.titleLarge(context).copyWith(
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestockTile extends StatelessWidget {
  const _RestockTile({required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final color =
        item.isOutOfStock ? AppColors.error : AppColors.warning;

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
                Text(item.name, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${item.currentStock} left - reorder at '
                  '${item.lowStockThreshold}',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _StatusBadge(label: item.stockStatus, color: color),
        ],
      ),
    );
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

class _EmptyInventory extends StatelessWidget {
  const _EmptyInventory({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'No $status items found.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyLarge(context).copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

String _formatCurrency(double value) {
  final amount = value.round().toString();
  if (amount.length <= 3) {
    return 'Rs. $amount';
  }

  final lastThree = amount.substring(amount.length - 3);
  var leading = amount.substring(0, amount.length - 3);
  final groups = <String>[];

  while (leading.length > 2) {
    groups.insert(0, leading.substring(leading.length - 2));
    leading = leading.substring(0, leading.length - 2);
  }

  if (leading.isNotEmpty) {
    groups.insert(0, leading);
  }

  return 'Rs. ${groups.join(',')},$lastThree';
}
