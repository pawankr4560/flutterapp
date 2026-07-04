import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/features/loan/domain/entities/loan_customer.dart';
import 'package:finhub/features/loan/domain/entities/loan_detail.dart';
import 'package:finhub/features/loan/presentation/providers/loan_provider.dart';

/// Form page for disbursing a new loan to a customer.
class AddLoanPage extends ConsumerStatefulWidget {
  const AddLoanPage({super.key});

  @override
  ConsumerState<AddLoanPage> createState() => _AddLoanPageState();
}

class _AddLoanPageState extends ConsumerState<AddLoanPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _principalController = TextEditingController();
  final _interestController = TextEditingController();
  final _tenureController = TextEditingController();

  double _emi = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _principalController.dispose();
    _interestController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Loan')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              AppTextField(
                controller: _nameController,
                labelText: 'Full Name',
                prefixIcon: Icons.person_outline_rounded,
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _principalController,
                labelText: 'Principal Amount',
                prefixIcon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
                validator: _positiveNumber,
                onChanged: (_) => _calculateEmi(),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _interestController,
                labelText: 'Annual Interest Rate (%)',
                prefixIcon: Icons.percent_rounded,
                keyboardType: TextInputType.number,
                validator: _positiveNumber,
                onChanged: (_) => _calculateEmi(),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _tenureController,
                labelText: 'Tenure (Months)',
                prefixIcon: Icons.calendar_month_rounded,
                keyboardType: TextInputType.number,
                validator: _positiveWholeNumber,
                onChanged: (_) => _calculateEmi(),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Calculated EMI',
                        style: AppTextStyles.bodyMedium(context)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(_formatCurrency(_emi),
                        style: AppTextStyles.headlineMedium(context)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'Disburse Loan',
                icon: Icons.check_circle_outline_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calculateEmi() {
    final principal = double.tryParse(_principalController.text) ?? 0;
    final annualRate = double.tryParse(_interestController.text) ?? 0;
    final tenure = int.tryParse(_tenureController.text) ?? 0;

    if (principal <= 0 || annualRate <= 0 || tenure <= 0) {
      setState(() => _emi = 0);
      return;
    }

    final monthlyRate = annualRate / 12 / 100;
    final factor = math.pow(1 + monthlyRate, tenure).toDouble();
    setState(() {
      _emi = principal * monthlyRate * factor / (factor - 1);
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _calculateEmi();
    final principal = double.parse(_principalController.text);
    final interestRate = double.parse(_interestController.text);
    final tenure = int.parse(_tenureController.text);
    final now = DateTime.now();

    final customer = LoanCustomer(
      id: 'customer-${now.microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      profilePicUrl: '',
      loanDetails: LoanDetail(
        loanId: 'LN-${now.millisecondsSinceEpoch}',
        principalAmount: principal,
        interestRate: interestRate,
        tenureMonths: tenure,
        remainingAmount: principal,
        nextEmiAmount: _emi,
        nextEmiDate: now.add(const Duration(days: 30)),
        status: 'Active',
      ),
    );

    ref.read(loanCustomersProvider.notifier).addCustomer(customer);
    Navigator.of(context).pop();
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty
        ? 'This field is required'
        : null;
  }

  String? _positiveNumber(String? value) {
    final number = double.tryParse(value ?? '');
    return number == null || number <= 0 ? 'Enter a valid amount' : null;
  }

  String? _positiveWholeNumber(String? value) {
    final number = int.tryParse(value ?? '');
    return number == null || number <= 0 ? 'Enter valid months' : null;
  }

  String _formatCurrency(double value) => '₹${value.toStringAsFixed(0)}';
}
