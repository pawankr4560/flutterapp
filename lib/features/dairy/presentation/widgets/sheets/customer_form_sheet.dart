part of '../../pages/milk_directory_page.dart';

class _CustomerFormSheet extends StatefulWidget {
  const _CustomerFormSheet();

  @override
  State<_CustomerFormSheet> createState() => _CustomerFormSheetState();
}

class _CustomerFormSheetState extends State<_CustomerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _balance = TextEditingController(text: '0');
  String _type = 'Farmer';

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _balance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormShell(
      title: 'Add Customer',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppFormTextField(controller: _name, label: 'Full Name'),
            AppFormTextField(
              controller: _phone,
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
            AppDropdownField<String>(
              label: 'Customer Type',
              value: _type,
              items: const [
                'Farmer',
                'Customer',
                'Shop',
                'Distributor',
                'Business',
              ],
              onChanged: (value) => setState(() => _type = value),
            ),
            AppFormTextField(controller: _address, label: 'Address'),
            AppFormTextField(
              controller: _balance,
              label: 'Opening Balance',
              keyboardType: TextInputType.number,
              validatePositiveNumber: true,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: _submit,
              child: const Text('Save Customer'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _CustomerEntry(
        _name.text.trim(),
        _phone.text.trim(),
        _type,
        _number(_balance.text),
        _address.text.trim(),
      ),
    );
  }
}


