part of 'inventory_directory_page.dart';

class _RequestQuoteScreen extends StatelessWidget {
  const _RequestQuoteScreen({
    required this.formKey,
    required this.categories,
    required this.products,
    required this.selectedCategory,
    required this.selectedProduct,
    required this.selectedUnit,
    required this.requiredDate,
    required this.quantityController,
    required this.locationController,
    required this.phoneController,
    required this.notesController,
    required this.onCategoryChanged,
    required this.onProductChanged,
    required this.onUnitChanged,
    required this.onDateChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final List<_MaterialCategory> categories;
  final List<_MaterialProduct> products;
  final String selectedCategory;
  final String selectedProduct;
  final String selectedUnit;
  final DateTime requiredDate;
  final TextEditingController quantityController;
  final TextEditingController locationController;
  final TextEditingController phoneController;
  final TextEditingController notesController;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onProductChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final categoryProducts = products
        .where((product) => product.category == selectedCategory)
        .toList();
    final selected = products.firstWhere((product) {
      return product.name == selectedProduct;
    });
    final quantity = double.tryParse(quantityController.text.trim()) ?? 0;
    final estimatedAmount = selected.rate == null
        ? null
        : selected.rate! * quantity;

    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
        ),
        children: [
          AppDropdownField<String>(
            label: 'Material Category',
            value: selectedCategory,
            items: categories.map((category) => category.name).toList(),
            onChanged: onCategoryChanged,
            fallbackToFirst: true,
          ),
          AppDropdownField<String>(
            label: 'Material/Product',
            value: selectedProduct,
            items: categoryProducts.map((product) => product.name).toList(),
            onChanged: onProductChanged,
            fallbackToFirst: true,
          ),
          AppFormTextField(
            controller: quantityController,
            label: 'Quantity',
            keyboardType: TextInputType.number,
            validator: _positiveValidator,
          ),
          AppDropdownField<String>(
            label: 'Unit',
            value: selectedUnit,
            items: const [
              'Bag',
              'Ton',
              'CFT',
              'Cubic Meter',
              '1000 pcs',
              'pcs',
              'Tractor / Ton / CFT',
            ],
            onChanged: onUnitChanged,
            fallbackToFirst: true,
          ),
          AppFormTextField(
            controller: locationController,
            label: 'Delivery Location',
            validator: _requiredValidator,
          ),
          AppDatePickerField(
            date: requiredDate,
            onChanged: onDateChanged,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 60)),
            formatDate: _date,
            label: 'Required Date',
            icon: Icons.calendar_month_rounded,
          ),
          AppFormTextField(
            controller: phoneController,
            label: 'Contact Number',
            keyboardType: TextInputType.phone,
            validator: _phoneValidator,
          ),
          AppFormTextField(
            controller: notesController,
            label: 'Notes',
            minLines: 3,
            maxLines: 4,
            required: false,
          ),
          _EstimatePanel(
            amount: estimatedAmount,
            quoteOnly: selected.rate == null,
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.send_rounded),
            label: const Text('Submit Request'),
          ),
        ],
      ),
    );
  }
}

