part of '../pages/inventory_directory_page.dart';

class _DirectOrderInput {
  const _DirectOrderInput({
    required this.quantity,
    required this.deliveryLocation,
    required this.requiredDate,
    required this.contactNumber,
    required this.notes,
  });

  final double quantity;
  final String deliveryLocation;
  final DateTime requiredDate;
  final String contactNumber;
  final String notes;
}

class _DirectOrderSheet extends StatefulWidget {
  const _DirectOrderSheet({required this.product, required this.onSubmit});

  final _MaterialProduct product;
  final Future<void> Function(_DirectOrderInput input) onSubmit;

  @override
  State<_DirectOrderSheet> createState() => _DirectOrderSheetState();
}

class _DirectOrderSheetState extends State<_DirectOrderSheet> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _requiredDate = DateTime.now().add(const Duration(days: 1));
  var _submitting = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 0;
    final amount = widget.product.rate == null
        ? null
        : widget.product.rate! * quantity;

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
        ),
        children: [
          Text(
            'Order ${widget.product.name}',
            style: AppTextStyles.titleLarge(context),
          ),
          const SizedBox(height: AppSpacing.md),
          AppFormTextField(
            controller: _quantityController,
            label: 'Quantity (${widget.product.unit})',
            keyboardType: TextInputType.number,
            validator: _positiveValidator,
            onChanged: (_) => setState(() {}),
          ),
          AppFormTextField(
            controller: _locationController,
            label: 'Delivery Location',
            validator: _requiredValidator,
          ),
          AppDatePickerField(
            date: _requiredDate,
            onChanged: (date) => setState(() => _requiredDate = date),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 60)),
            formatDate: _date,
            label: 'Required Date',
            icon: Icons.calendar_month_rounded,
          ),
          AppFormTextField(
            controller: _phoneController,
            label: 'Contact Number',
            keyboardType: TextInputType.phone,
            validator: _phoneValidator,
          ),
          AppFormTextField(
            controller: _notesController,
            label: 'Notes',
            minLines: 3,
            maxLines: 4,
            required: false,
          ),
          _EstimatePanel(amount: amount, priceUnavailable: amount == null),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: _submitting ? null : _submit,
            icon: _submitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.shopping_cart_checkout_rounded),
            label: Text(_submitting ? 'Placing order...' : 'Place Order'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(
        _DirectOrderInput(
          quantity: double.parse(_quantityController.text.trim()),
          deliveryLocation: _locationController.text.trim(),
          requiredDate: _requiredDate,
          contactNumber: _phoneController.text.trim(),
          notes: _notesController.text.trim(),
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
      setState(() => _submitting = false);
    }
  }
}
