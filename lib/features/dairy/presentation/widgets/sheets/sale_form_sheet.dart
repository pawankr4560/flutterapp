part of '../../pages/milk_directory_page.dart';

class _SaleFormSheet extends StatefulWidget {
  const _SaleFormSheet();

  @override
  State<_SaleFormSheet> createState() => _SaleFormSheetState();
}

class _SaleFormSheetState extends State<_SaleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _customer = TextEditingController();
  final _quantity = TextEditingController(text: '10');
  final _rate = TextEditingController(text: '60');
  String _product = 'Milk';
  String _status = 'Paid';
  DateTime _date = DateTime.now();

  double get _total => _number(_quantity.text) * _number(_rate.text);

  @override
  void initState() {
    super.initState();
    _quantity.addListener(() => setState(() {}));
    _rate.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _customer.dispose();
    _quantity.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormShell(
      title: 'New Sale',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppFormTextField(controller: _customer, label: 'Customer'),
            AppDropdownField<String>(
              label: 'Product',
              value: _product,
              items: const ['Milk', 'Paneer', 'Ghee', 'Curd', 'Butter'],
              onChanged: (value) => setState(() => _product = value),
            ),
            AppFormTextField(
              controller: _quantity,
              label: 'Quantity',
              keyboardType: TextInputType.number,
              validatePositiveNumber: true,
            ),
            AppFormTextField(
              controller: _rate,
              label: 'Rate',
              keyboardType: TextInputType.number,
              validatePositiveNumber: true,
            ),
            AppDropdownField<String>(
              label: 'Payment Status',
              value: _status,
              items: const ['Paid', 'Pending'],
              onChanged: (value) => setState(() => _status = value),
            ),
            AppDatePickerField(
              date: _date,
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              formatDate: _formatShortDate,
              onChanged: (date) {
                setState(() => _date = date);
              },
            ),
            _TotalBanner(label: 'Total Amount', amount: _total),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: _submit, child: const Text('Save Sale')),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _SaleEntry(
        _customer.text.trim(),
        _product,
        _number(_quantity.text),
        _number(_rate.text),
        _status,
        _date,
      ),
    );
  }
}


