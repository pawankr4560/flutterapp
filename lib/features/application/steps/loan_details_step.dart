import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../core/theme/app_theme.dart';

class LoanDetailsStep extends StatelessWidget {
  const LoanDetailsStep({
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
            Text('Loan details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Choose the loan terms that fit your need.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            FormBuilderDropdown<String>(
              name: 'loanType',
              decoration: const InputDecoration(
                labelText: 'Loan type',
                prefixIcon: Icon(Icons.account_balance_outlined),
              ),
              validator: _required('Loan type is required'),
              items: const [
                DropdownMenuItem(value: 'Home', child: Text('Home')),
                DropdownMenuItem(value: 'Auto', child: Text('Auto')),
                DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                DropdownMenuItem(value: 'Education', child: Text('Education')),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            FormBuilderTextField(
              name: 'amountRequested',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Amount requested',
                hintText: 'Enter loan amount',
                prefixIcon: Icon(Icons.currency_rupee_outlined),
              ),
              validator: _positiveNumber('Amount requested is required'),
            ),
            const SizedBox(height: AppSpacing.md),
            FormBuilderTextField(
              name: 'tenure',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Tenure',
                hintText: 'Tenure in months',
                prefixIcon: Icon(Icons.schedule_outlined),
              ),
              validator: _positiveNumber('Tenure is required'),
            ),
            const SizedBox(height: AppSpacing.md),
            FormBuilderTextField(
              name: 'purpose',
              minLines: 2,
              maxLines: 4,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Purpose',
                hintText: 'Tell us how you plan to use this loan',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
              validator: _required('Purpose is required'),
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
