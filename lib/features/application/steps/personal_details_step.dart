import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../core/theme/app_theme.dart';

class PersonalDetailsStep extends StatelessWidget {
  const PersonalDetailsStep({
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
            Text('Personal details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tell us who is applying for the loan.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            FormBuilderTextField(
              name: 'name',
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: _required('Name is required'),
            ),
            const SizedBox(height: AppSpacing.md),
            FormBuilderDateTimePicker(
              name: 'dob',
              inputType: InputType.date,
              decoration: const InputDecoration(
                labelText: 'DOB',
                hintText: 'Select date of birth',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              validator: _required('DOB is required'),
            ),
            const SizedBox(height: AppSpacing.md),
            FormBuilderTextField(
              name: 'address',
              minLines: 2,
              maxLines: 4,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Enter your residential address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: _required('Address is required'),
            ),
            const SizedBox(height: AppSpacing.md),
            FormBuilderTextField(
              name: 'panNumber',
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'PAN number',
                hintText: 'ABCDE1234F',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return 'PAN number is required';
                }
                final panPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
                if (!panPattern.hasMatch(text.toUpperCase())) {
                  return 'Enter a valid PAN number';
                }
                return null;
              },
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
