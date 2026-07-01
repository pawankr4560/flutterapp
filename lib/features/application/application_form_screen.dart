import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/step_progress_bar.dart';
import 'loan_requests.dart';
import 'loan_service.dart';
import 'steps/employment_details_step.dart';
import 'steps/loan_details_step.dart';
import 'steps/personal_details_step.dart';
import 'steps/review_step.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final PageController _pageController = PageController();
  final List<GlobalKey<FormBuilderState>> _formKeys = List.generate(
    3,
    (_) => GlobalKey<FormBuilderState>(),
  );
  final Map<String, dynamic> _formData = {};
  final LoanService _loanService = LoanService();
  bool _isSubmitting = false;

  static const String _userId = 'd853e508-a345-46aa-8aee-552a3329afaa';
  static const String _bearerToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InBhd2FuQGdtYWlsLmNvbSIsIkVtYWlsIjoicGF3YW5AZ21haWwuY29tIiwiSWQiOiJkODUzZTUwOC1hMzQ1LTQ2YWEtOGFlZS01NTJhMzMyOWFmYWEiLCJQaG9uZSI6IjQ3MjM5Mjc5Mjc4MzkyMzgiLCJGaXJzdE5hbWUiOiJQYXdhbiIsIkxhc3ROYW1lIjoiS3VtYXIiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJVc2VyIiwiZXhwIjoxNzgyOTM2MDY5LCJpc3MiOiJsb2NhbGhvc3QiLCJhdWQiOiJsb2NhbGhvc3QifQ.xuazIu5sXyatxU6pTelDaJqNcfTix55PHd4G8EdbUbU';

  int _currentStep = 0;

  bool get _isReviewStep => _currentStep == 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _saveCurrentStep() {
    if (_currentStep >= _formKeys.length) {
      return;
    }

    final formState = _formKeys[_currentStep].currentState;
    formState?.save();
    _formData.addAll(formState?.value ?? {});
  }

  bool _validateCurrentStep() {
    if (_currentStep >= _formKeys.length) {
      return true;
    }

    final formState = _formKeys[_currentStep].currentState;
    if (formState == null || !formState.saveAndValidate()) {
      return false;
    }

    _formData.addAll(formState.value);
    return true;
  }

  void _goToStep(int step) {
    _saveCurrentStep();
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  Future<void> _submitApplication() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = LoanApplicationRequest(
        userId: _userId,
        fullName: _formData['name']?.toString() ?? '',
        dob: (_formData['dob'] as DateTime).toUtc().toIso8601String(),
        address: _formData['address']?.toString() ?? '',
        panNumber: _formData['panNumber']?.toString() ?? '',
        employmentType: _formData['employmentType']?.toString() ?? '',
        employerName: _formData['employerName']?.toString() ?? '',
        monthlyIncome: int.tryParse(_formData['monthlyIncome']?.toString() ?? '') ?? 0,
        workExperience: int.tryParse(_formData['workExperience']?.toString() ?? '') ?? 0,
        loanType: _formData['loanType']?.toString() ?? '',
        amountRequested: int.tryParse(_formData['amountRequested']?.toString() ?? '') ?? 0,
        tenure: int.tryParse(_formData['tenure']?.toString() ?? '') ?? 0,
        purpose: _formData['purpose']?.toString() ?? '',
      );

      final response = await _loanService.submitApplication(
        request,
        _bearerToken,
      );
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>?;
      final success = responseBody?['success'] == true;
      final message = responseBody?['message'] as String?;

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Loan application submitted successfully')),
        );
        context.push('/documents');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Failed to submit loan application.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to submit loan application.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _continue() async {
    if (!_validateCurrentStep()) {
      return;
    }

    if (_isReviewStep) {
      await _submitApplication();
      return;
    }

    _goToStep(_currentStep + 1);
  }

  void _goBack() {
    if (_currentStep == 0) {
      Navigator.of(context).maybePop();
      return;
    }

    _goToStep(_currentStep - 1);
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      PersonalDetailsStep(
        formKey: _formKeys[0],
        initialValue: _formData,
      ),
      EmploymentDetailsStep(
        formKey: _formKeys[1],
        initialValue: _formData,
      ),
      LoanDetailsStep(
        formKey: _formKeys[2],
        initialValue: _formData,
      ),
      ReviewStep(
        data: _formData,
        onEditSection: _goToStep,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Loan application')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StepProgressBar(
                currentStep: _currentStep,
                totalSteps: steps.length,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Step ${_currentStep + 1} of ${steps.length}',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: steps,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Back',
                      variant: AppButtonVariant.secondary,
                      onPressed: _goBack,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: _isSubmitting
                          ? 'Submitting...'
                          : _isReviewStep
                              ? 'Submit'
                              : 'Continue',
                      onPressed: _isSubmitting ? null : _continue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
