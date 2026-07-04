import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/dairy/domain/entities/milk_collection_log.dart';
import 'package:finhub/features/dairy/presentation/providers/dairy_provider.dart';

/// Form page for adding a new dairy milk collection entry.
class AddCollectionPage extends ConsumerStatefulWidget {
  const AddCollectionPage({super.key});

  @override
  ConsumerState<AddCollectionPage> createState() => _AddCollectionPageState();
}

class _AddCollectionPageState extends ConsumerState<AddCollectionPage> {
  final _formKey = GlobalKey<FormState>();
  final _farmerController = TextEditingController();
  final _quantityController = TextEditingController();
  final _fatController = TextEditingController();
  final _rateController = TextEditingController();
  String _shift = 'Morning';

  @override
  void dispose() {
    _farmerController.dispose();
    _quantityController.dispose();
    _fatController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final payout = quantity * rate;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Collection')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              AppTextField(
                controller: _farmerController,
                labelText: 'Farmer Name',
                prefixIcon: Icons.person_outline_rounded,
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.md),
              _ShiftDropdown(
                  value: _shift,
                  onChanged: (value) => setState(() => _shift = value)),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _quantityController,
                labelText: 'Quantity in Liters',
                prefixIcon: Icons.water_drop_outlined,
                keyboardType: TextInputType.number,
                validator: _positiveNumber,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _fatController,
                labelText: 'Fat Percentage',
                prefixIcon: Icons.percent_rounded,
                keyboardType: TextInputType.number,
                validator: _positiveNumber,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _rateController,
                labelText: 'Rate Per Liter (Rs.)',
                prefixIcon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
                validator: _positiveNumber,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.lg),
              _PayoutCard(amount: payout),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'Save Entry',
                icon: Icons.check_circle_outline_rounded,
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
    final log = MilkCollectionLog(
      id: 'milk-log-${now.microsecondsSinceEpoch}',
      farmerName: _farmerController.text.trim(),
      shift: _shift,
      quantityInLiters: double.parse(_quantityController.text),
      fatPercentage: double.parse(_fatController.text),
      ratePerLiter: double.parse(_rateController.text),
      date: now,
    );
    ref.read(dairyProvider.notifier).addLog(log);
    Navigator.of(context).pop();
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty
        ? 'This field is required'
        : null;
  }

  String? _positiveNumber(String? value) {
    final number = double.tryParse(value ?? '');
    return number == null || number <= 0 ? 'Enter a valid value' : null;
  }
}

class _ShiftDropdown extends StatelessWidget {
  const _ShiftDropdown({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: 'Shift',
        prefixIcon: const Icon(Icons.schedule_rounded),
        filled: true,
        fillColor: AppColors.surface,
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary),
      ),
      style: AppTextStyles.bodyLarge(context),
      items: const [
        DropdownMenuItem(value: 'Morning', child: Text('Morning')),
        DropdownMenuItem(value: 'Evening', child: Text('Evening')),
      ],
      onChanged: (value) => value == null ? null : onChanged(value),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
      borderSide: BorderSide(color: color),
    );
  }
}

class _PayoutCard extends StatelessWidget {
  const _PayoutCard({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
      child: Row(
        children: [
          const Icon(Icons.payments_rounded, color: AppColors.secondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimated Payout', style: AppTextStyles.bodyMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text('₹${amount.toStringAsFixed(2)}',
                  style: AppTextStyles.titleLarge(context).copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
