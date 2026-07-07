part of '../../pages/milk_directory_page.dart';

class _CollectionFormSheet extends StatefulWidget {
  const _CollectionFormSheet();

  @override
  State<_CollectionFormSheet> createState() => _CollectionFormSheetState();
}

class _CollectionFormSheetState extends State<_CollectionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _farmer = TextEditingController();
  final _quantity = TextEditingController(text: '20');
  final _fat = TextEditingController(text: '4.5');
  final _rate = TextEditingController(text: '42');
  String _milkType = 'Cow';
  DateTime _date = DateTime.now();

  double get _total => (_number(_quantity.text) * _number(_rate.text));

  @override
  void initState() {
    super.initState();
    _quantity.addListener(() => setState(() {}));
    _rate.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _farmer.dispose();
    _quantity.dispose();
    _fat.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormShell(
      title: 'Add Collection',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppFormTextField(controller: _farmer, label: 'Farmer Name'),
            AppDropdownField<String>(
              label: 'Milk Type',
              value: _milkType,
              items: const ['Cow', 'Buffalo'],
              onChanged: (value) => setState(() => _milkType = value),
            ),
            AppFormTextField(
              controller: _quantity,
              label: 'Quantity in liters',
              keyboardType: TextInputType.number,
              validatePositiveNumber: true,
            ),
            AppFormTextField(
              controller: _fat,
              label: 'Fat %',
              keyboardType: TextInputType.number,
              validatePositiveNumber: true,
            ),
            AppFormTextField(
              controller: _rate,
              label: 'Rate per liter',
              keyboardType: TextInputType.number,
              validatePositiveNumber: true,
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
            FilledButton(
              onPressed: _submit,
              child: const Text('Save Collection'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _CollectionEntry(
        _farmer.text.trim(),
        _milkType,
        _number(_quantity.text),
        _number(_fat.text),
        _number(_rate.text),
        _date,
      ),
    );
  }
}


