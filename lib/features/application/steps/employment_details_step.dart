import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../core/theme/app_theme.dart';

class EmploymentDetailsStep extends StatelessWidget {
  const EmploymentDetailsStep({
    super.key,
    required this.formKey,
    required this.initialValue,
  });

  final GlobalKey<FormBuilderState> formKey;
  final Map<String, dynamic> initialValue;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: formKey,
        initialValue: initialValue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Employment details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Help us understand your income profile.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            FormBuilderDropdown<String>(
              name: 'employmentType',
              decoration: const InputDecoration(
                labelText: 'Employment type',
                prefixIcon: Icon(Icons.work_outline),
              ),
              validator: _required('Employment type is required'),
              items: const [
                DropdownMenuItem(value: 'Salaried', child: Text('Salaried')),
                DropdownMenuItem(
                  value: 'Self-employed',
                  child: Text('Self-employed'),
                ),
                DropdownMenuItem(value: 'Business', child: Text('Business')),
                DropdownMenuItem(value: 'Student', child: Text('Student')),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            FormBuilderTextField(
              name: 'employerName',
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Employer name',
                hintText: 'Enter employer or business name',
                prefixIcon: Icon(Icons.apartment_outlined),
              ),
              validator: _required('Employer name is required'),
            ),
            const SizedBox(height: AppSpacing.md),
            FormBuilderTextField(
              name: 'monthlyIncome',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Monthly income',
                hintText: 'Enter monthly income',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              validator: _positiveNumber('Monthly income is required'),
            ),
            const SizedBox(height: AppSpacing.md),
            FormBuilderTextField(
              name: 'workExperience',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Work experience',
                hintText: 'Years of experience',
                prefixIcon: Icon(Icons.timeline_outlined),
              ),
              validator: _positiveNumber('Work experience is required'),
            ),
          ],
        ),
      ),
    );
  }
}

FormFieldValidator<T> _required<T>(String message) {
  return (value) {
    if (value == null) {
      return message;
    }
    if (value is String && value.trim().isEmpty) {
      return message;
    }
    return null;
  };
}

FormFieldValidator<String> _positiveNumber(String message) {
  return (value) {
    final text = value?.trim() ?? '';
    final number = num.tryParse(text);
    if (number == null || number <= 0) {
      return message;
    }
    return null;
  };
}
