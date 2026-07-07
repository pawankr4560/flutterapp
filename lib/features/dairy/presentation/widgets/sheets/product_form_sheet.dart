part of '../../pages/milk_directory_page.dart';

class _ProductFormSheet extends StatefulWidget {
  const _ProductFormSheet();

  @override
  State<_ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<_ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _stock = TextEditingController(text: '10');
  final _purchase = TextEditingController(text: '40');
  final _selling = TextEditingController(text: '60');
  String _unit = 'L';

  @override
  void dispose() {
    _name.dispose();
    _stock.dispose();
    _purchase.dispose();
    _selling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormShell(
      title: 'Add Product',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppFormTextField(controller: _name, label: 'Product Name'),
            AppDropdownField<String>(
              label: 'Unit',
              value: _unit,
              items: const ['L', 'kg', 'pcs'],
              onChanged: (value) => setState(() => _unit = value),
            ),
            AppFormTextField(
              controller: _stock,
              label: 'Current Stock',
              keyboardType: TextInputType.number,
              validatePositiveNumber: true,
            ),
            AppFormTextField(
              controller: _purchase,
              label: 'Purchase Price',
              keyboardType: TextInputType.number,
              validatePositiveNumber: true,
            ),
            AppFormTextField(
              controller: _selling,
              label: 'Selling Price',
              keyboardType: TextInputType.number,
              validatePositiveNumber: true,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: _submit, child: const Text('Save Product')),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _ProductEntry(
        _name.text.trim(),
        _unit,
        _number(_stock.text),
        _number(_purchase.text),
        _number(_selling.text),
      ),
    );
  }
}


