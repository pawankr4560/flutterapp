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
    required this.submitting,
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
  final bool submitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final category = _firstOrNull(
      categories.where((item) => item.name == selectedCategory),
    );
    final categoryProducts = products.where((product) {
      return product.category == selectedCategory ||
          (category != null && product.categoryId == category.id);
    }).toList();
    if (products.isEmpty || categoryProducts.isEmpty) {
      return const _EmptyConstructionMessage(
        message: 'No materials are available for quote requests yet',
      );
    }
    final selected = products.firstWhere(
      (product) => product.name == selectedProduct,
      orElse: () => categoryProducts.first,
    );
    final quantity = double.tryParse(quantityController.text.trim()) ?? 0;
    final estimatedAmount = selected.rate == null
        ? null
        : selected.rate! * quantity;
    final unitOptions = <String>{
      selectedUnit,
      selected.unit,
      for (final product in categoryProducts) product.unit,
      'Bag',
      'Ton',
      'CFT',
      'Cubic Meter',
      '1000 pcs',
      'pcs',
      'Pieces',
      'Kilogram',
      'Gram',
      'Litre',
      'Millilitre',
      'Tractor / Ton / CFT',
    }.where((unit) => unit.isNotEmpty).toList();

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
            items: unitOptions,
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
            onPressed: submitting ? null : onSubmit,
            icon: submitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(submitting ? 'Submitting...' : 'Submit Request'),
          ),
        ],
      ),
    );
  }
}

