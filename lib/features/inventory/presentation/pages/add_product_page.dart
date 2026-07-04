import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/inventory/domain/entities/inventory_item.dart';
import 'package:finhub/features/inventory/presentation/providers/inventory_provider.dart';

/// Form page for adding a new product with live profit calculation.
class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stockController = TextEditingController();
  final _thresholdController = TextEditingController();
  final _costController = TextEditingController();
  final _sellingController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    _thresholdController.dispose();
    _costController.dispose();
    _sellingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final costPrice = double.tryParse(_costController.text) ?? 0;
    final sellingPrice = double.tryParse(_sellingController.text) ?? 0;
    final netProfit = sellingPrice - costPrice;
    final margin = sellingPrice <= 0 ? 0.0 : netProfit / sellingPrice * 100;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              AppTextField(
                controller: _nameController,
                labelText: 'Product Name',
                prefixIcon: Icons.inventory_2_outlined,
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _categoryController,
                labelText: 'Category',
                prefixIcon: Icons.category_outlined,
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _stockController,
                labelText: 'Current Stock',
                prefixIcon: Icons.storefront_outlined,
                keyboardType: TextInputType.number,
                validator: _nonNegativeInt,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _thresholdController,
                labelText: 'Low Stock Threshold',
                prefixIcon: Icons.warning_amber_rounded,
                keyboardType: TextInputType.number,
                validator: _nonNegativeInt,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _costController,
                labelText: 'Cost Price (Rs.)',
                prefixIcon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
                validator: _positiveNumber,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _sellingController,
                labelText: 'Selling Price (Rs.)',
                prefixIcon: Icons.sell_outlined,
                keyboardType: TextInputType.number,
                validator: _positiveNumber,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.lg),
              _ProfitMatrix(netProfit: netProfit, margin: margin),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'Add Product',
                icon: Icons.add_circle_outline_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final item = InventoryItem(
      id: 'item-${now.microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      currentStock: int.parse(_stockController.text),
      lowStockThreshold: int.parse(_thresholdController.text),
      costPrice: double.parse(_costController.text),
      sellingPrice: double.parse(_sellingController.text),
    );
    ref.read(inventoryProvider.notifier).addItem(item);
    Navigator.of(context).pop();
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty
        ? 'This field is required'
        : null;
  }

  String? _nonNegativeInt(String? value) {
    final number = int.tryParse(value ?? '');
    return number == null || number < 0 ? 'Enter a valid stock value' : null;
  }

  String? _positiveNumber(String? value) {
    final number = double.tryParse(value ?? '');
    return number == null || number <= 0 ? 'Enter a valid price' : null;
  }
}

class _ProfitMatrix extends StatelessWidget {
  const _ProfitMatrix({required this.netProfit, required this.margin});

  final double netProfit;
  final double margin;

  @override
  Widget build(BuildContext context) {
    final isPositive = netProfit > 0;
    final valueColor = isPositive ? AppColors.success : AppColors.error;

    return AppCard(
      backgroundColor: AppColors.primary.withValues(alpha: 0.06),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: valueColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            child: Icon(Icons.trending_up_rounded, color: valueColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Live Profit Matrix', style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Net Profit: Rs. ${netProfit.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: valueColor,
                  ),
                ),
                Text(
                  'Profit Margin: ${margin.toStringAsFixed(2)}%',
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
