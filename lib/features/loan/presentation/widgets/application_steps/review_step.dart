import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_theme.dart';

class ReviewStep extends StatelessWidget {
  const ReviewStep({
    super.key,
    required this.data,
    required this.onEditSection,
  });

  final Map<String, dynamic> data;
  final ValueChanged<int> onEditSection;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('Review', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Confirm your details before submitting.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        _ReviewSection(
          title: 'Personal details',
          onEdit: () => onEditSection(0),
          rows: [
            _ReviewRow('Name', _read('name')),
            _ReviewRow('DOB', _formatDate(data['dob'])),
            _ReviewRow('Address', _read('address')),
            _ReviewRow('PAN number', _read('panNumber')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _ReviewSection(
          title: 'Employment details',
          onEdit: () => onEditSection(1),
          rows: [
            _ReviewRow('Employment type', _read('employmentType')),
            _ReviewRow('Employer name', _read('employerName')),
            _ReviewRow('Monthly income', _read('monthlyIncome')),
            _ReviewRow('Work experience', '${_read('workExperience')} years'),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _ReviewSection(
          title: 'Loan details',
          onEdit: () => onEditSection(2),
          rows: [
            _ReviewRow('Loan type', _read('loanType')),
            _ReviewRow('Amount requested', _read('amountRequested')),
            _ReviewRow('Tenure', '${_read('tenure')} months'),
            _ReviewRow('Purpose', _read('purpose')),
          ],
        ),
      ],
    );
  }

  String _read(String key) {
    final value = data[key];
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }
    return value.toString();
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.title,
    required this.rows,
    required this.onEdit,
  });

  final String title;
  final List<_ReviewRow> rows;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit'),
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: row,
              )),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

String _formatDate(Object? value) {
  if (value is! DateTime) {
    return '-';
  }

  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  return '$day/$month/${value.year}';
}


