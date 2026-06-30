import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/step_progress_bar.dart';
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

  void _continue() {
    if (!_validateCurrentStep()) {
      return;
    }

    if (_isReviewStep) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application details saved')),
      );
      context.go('/documents');
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
                      label: _isReviewStep ? 'Submit' : 'Continue',
                      onPressed: _continue,
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
