import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/agriculture/domain/entities/field_record.dart';
import 'package:finhub/features/agriculture/presentation/providers/agriculture_provider.dart';

/// Form for logging pesticide or fertilizer spray application.
class LogSprayPage extends ConsumerStatefulWidget {
  const LogSprayPage({super.key});

  @override
  ConsumerState<LogSprayPage> createState() => _LogSprayPageState();
}

class _LogSprayPageState extends ConsumerState<LogSprayPage> {
  String? _fieldId;
  String _product = 'Chlorpyrifos 20% EC - 200 ml/acre';
  DateTime? _applicationDate;

  @override
  Widget build(BuildContext context) {
    final fields = ref.watch(agricultureProvider).fields;
    _fieldId ??= fields.first.id;
    final selectedField = fields.firstWhere((field) => field.id == _fieldId);
    final dosageMl = selectedField.areaAcres * 200;

    return Scaffold(
      appBar: AppBar(title: const Text('Log spray application')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _FieldLabel(label: 'Field'),
            const SizedBox(height: AppSpacing.xs),
            _FieldDropdown(
              value: _fieldId!,
              fields: fields,
              onChanged: (value) => setState(() => _fieldId = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            _FieldLabel(label: 'Pesticide or fertilizer'),
            const SizedBox(height: AppSpacing.xs),
            _ProductDropdown(
              value: _product,
              onChanged: (value) => setState(() => _product = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            _FieldLabel(label: 'Application date'),
            const SizedBox(height: AppSpacing.xs),
            _DatePickerTile(
              date: _applicationDate,
              onTap: _pickDate,
            ),
            const SizedBox(height: AppSpacing.lg),
            _DosageCard(
              field: selectedField,
              product: _product,
              dosageMl: dosageMl,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: 'Save spray log',
              icon: Icons.check_rounded,
              onPressed: _saveLog,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _applicationDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() => _applicationDate = picked);
    }
  }

  void _saveLog() {
    final date = _applicationDate;
    if (date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select application date.')),
      );
      return;
    }

    ref.read(agricultureProvider.notifier).logSpray(
          fieldId: _fieldId!,
          applicationDate: date,
        );
    Navigator.of(context).pop();
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

class _FieldDropdown extends StatelessWidget {
  const _FieldDropdown({
    required this.value,
    required this.fields,
    required this.onChanged,
  });

  final String value;
  final List<FieldRecord> fields;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: _inputDecoration(),
      style: AppTextStyles.bodyLarge(context),
      items: [
        for (final field in fields)
          DropdownMenuItem(
            value: field.id,
            child: Text(
              '${field.name} - ${field.areaAcres.toStringAsFixed(1)} acres',
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _ProductDropdown extends StatelessWidget {
  const _ProductDropdown({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  static const List<String> _products = [
    'Chlorpyrifos 20% EC - 200 ml/acre',
    'Urea granules - 25 kg/acre',
    'Neem oil concentrate - 1 L/acre',
    'DAP fertilizer - 50 kg/acre',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: _inputDecoration(),
      style: AppTextStyles.bodyLarge(context),
      items: [
        for (final product in _products)
          DropdownMenuItem(value: product, child: Text(product)),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({required this.date, required this.onTap});

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.large),
      onTap: onTap,
      child: InputDecorator(
        decoration: _inputDecoration(
          suffixIcon: const Icon(Icons.calendar_month_rounded),
        ),
        child: Text(
          date == null ? 'dd-mm-yyyy' : _formatDate(date!),
          style: AppTextStyles.bodyLarge(context).copyWith(
            color: date == null ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _DosageCard extends StatelessWidget {
  const _DosageCard({
    required this.field,
    required this.product,
    required this.dosageMl,
  });

  final FieldRecord field;
  final String product;
  final double dosageMl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dosage calculation',
                  style: AppTextStyles.titleMedium(context).copyWith(
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${field.areaAcres.toStringAsFixed(1)} acres x $product',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Estimated dosage: ${dosageMl.toStringAsFixed(0)} ml',
                  style: AppTextStyles.titleMedium(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration({Widget? suffixIcon}) {
  return InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    suffixIcon: suffixIcon,
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

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day-$month-${date.year}';
}
