import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/inventory/domain/entities/inventory_item.dart';
import 'package:finhub/features/inventory/presentation/providers/inventory_provider.dart';

/// Form page for adding a new product to inventory.
class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitPriceController = TextEditingController(text: '420');
  String _category = 'Raw materials';
  double _quantity = 80;
  double _threshold = 20;

  @override
  void dispose() {
    _nameController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add product')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _FieldLabel(label: 'Product name'),
              const SizedBox(height: AppSpacing.xs),
              AppTextField(
                controller: _nameController,
                hintText: 'e.g. Cement 50kg bag',
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldLabel(label: 'Category'),
              const SizedBox(height: AppSpacing.xs),
              _CategoryDropdown(
                value: _category,
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              _ValueSlider(
                label: 'Quantity in stock',
                value: _quantity,
                min: 0,
                max: 200,
                divisions: 200,
                valueText: _quantity.round().toString(),
                onChanged: (value) => setState(() => _quantity = value),
              ),
              const SizedBox(height: AppSpacing.md),
              _ValueSlider(
                label: 'Reorder threshold',
                value: _threshold,
                min: 0,
                max: 100,
                divisions: 100,
                valueText: _threshold.round().toString(),
                onChanged: (value) => setState(() => _threshold = value),
              ),
              const SizedBox(height: AppSpacing.md),
              _FieldLabel(label: 'Unit price (Rs.)'),
              const SizedBox(height: AppSpacing.xs),
              AppTextField(
                controller: _unitPriceController,
                hintText: 'Unit price',
                keyboardType: TextInputType.number,
                validator: _positiveNumber,
              ),
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
    final unitPrice = double.parse(_unitPriceController.text);
    final item = InventoryItem(
      id: 'item-${now.microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      category: _category,
      currentStock: _quantity.round(),
      lowStockThreshold: _threshold.round(),
      costPrice: unitPrice,
      sellingPrice: unitPrice,
    );
    ref.read(inventoryProvider.notifier).addItem(item);
    Navigator.of(context).pop();
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty
        ? 'This field is required'
        : null;
  }

  String? _positiveNumber(String? value) {
    final number = double.tryParse(value ?? '');
    return number == null || number <= 0 ? 'Enter a valid price' : null;
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.bodyLarge(context).copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  static const List<String> _categories = [
    'Raw materials',
    'Plumbing',
    'Finishing',
    'Electrical',
    'Tools',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: _inputDecoration(),
      style: AppTextStyles.bodyLarge(context),
      items: [
        for (final category in _categories)
          DropdownMenuItem(value: category, child: Text(category)),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _ValueSlider extends StatelessWidget {
  const _ValueSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueText,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String valueText;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _FieldLabel(label: label)),
            Text(valueText, style: AppTextStyles.titleMedium(context)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    border: _border(AppColors.border),
    enabledBorder: _border(AppColors.border),
    focusedBorder: _border(AppColors.primary),
  );
}

OutlineInputBorder _border(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.large),
    borderSide: BorderSide(color: color),
  );
}
