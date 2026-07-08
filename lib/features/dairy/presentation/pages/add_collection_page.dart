import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_form_controls.dart';
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
  final _rateController = TextEditingController(text: '38');
  String? _farmerName;
  String _shift = 'Morning';
  double _quantity = 12;
  double _fat = 4.5;

  double get _rate => double.tryParse(_rateController.text) ?? 0;

  double get _amountPayable => _quantity * _rate;

  @override
  void initState() {
    super.initState();
    _rateController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final farmers = _farmerNames(
      ref.watch(dairyProvider).valueOrNull ?? const [],
    );
    _farmerName ??= farmers.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Add collection')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              AppFieldLabel(label: 'Farmer'),
              const SizedBox(height: AppSpacing.xs),
              AppDropdownField<String>(
                label: null,
                value: _farmerName!,
                items: farmers,
                decoration: AppFormDecorations.filled(),
                style: AppTextStyles.bodyLarge(context),
                bottomSpacing: 0,
                onChanged: (value) => setState(() => _farmerName = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppFieldLabel(label: 'Shift'),
              const SizedBox(height: AppSpacing.xs),
              _ShiftSelector(
                selectedShift: _shift,
                onChanged: (shift) => setState(() => _shift = shift),
              ),
              const SizedBox(height: AppSpacing.lg),
              _ValueSlider(
                label: 'Quantity (litres)',
                valueText: '${_quantity.toStringAsFixed(1)} L',
                value: _quantity,
                min: 1,
                max: 30,
                divisions: 58,
                onChanged: (value) => setState(() => _quantity = value),
              ),
              const SizedBox(height: AppSpacing.md),
              _ValueSlider(
                label: 'Fat content (%)',
                valueText: '${_fat.toStringAsFixed(1)}%',
                value: _fat,
                min: 3,
                max: 8,
                divisions: 50,
                onChanged: (value) => setState(() => _fat = value),
              ),
              const SizedBox(height: AppSpacing.md),
              AppFieldLabel(label: 'Rate per litre (Rs.)'),
              const SizedBox(height: AppSpacing.xs),
              AppTextField(
                controller: _rateController,
                hintText: 'Rate per litre',
                keyboardType: TextInputType.number,
                validator: _positiveNumber,
              ),
              const SizedBox(height: AppSpacing.lg),
              _PayableBanner(amount: _amountPayable),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'Save Entry',
                icon: Icons.check_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _farmerNames(List<MilkCollectionLog> logs) {
    final names = logs.map((log) => log.farmerName).toSet().toList()..sort();
    return names.isEmpty ? ['Suresh Patel'] : names;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final log = MilkCollectionLog(
      id: 'milk-log-${now.microsecondsSinceEpoch}',
      farmerName: _farmerName!,
      shift: _shift,
      quantityInLiters: _quantity,
      fatPercentage: _fat,
      ratePerLiter: _rate,
      date: now,
    );
    await ref.read(dairyProvider.notifier).addLog(log);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  String? _positiveNumber(String? value) {
    final number = double.tryParse(value ?? '');
    return number == null || number <= 0 ? 'Enter a valid value' : null;
  }
}

class _ShiftSelector extends StatelessWidget {
  const _ShiftSelector({required this.selectedShift, required this.onChanged});

  final String selectedShift;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final shift in const ['Morning', 'Evening']) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () => onChanged(shift),
              style: OutlinedButton.styleFrom(
                backgroundColor: selectedShift == shift
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                textStyle: AppTextStyles.titleMedium(context),
              ),
              child: Text(shift),
            ),
          ),
          if (shift == 'Morning') const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _ValueSlider extends StatelessWidget {
  const _ValueSlider({
    required this.label,
    required this.valueText,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final String valueText;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: AppFieldLabel(label: label)),
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

class _PayableBanner extends StatelessWidget {
  const _PayableBanner({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Amount payable',
              style: AppTextStyles.titleMedium(context).copyWith(
                color: AppColors.success,
              ),
            ),
          ),
          Text(
            'Rs. ${amount.toStringAsFixed(0)}',
            style: AppTextStyles.titleLarge(context).copyWith(
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

