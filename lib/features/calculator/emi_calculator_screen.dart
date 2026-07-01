import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';

class EmiCalculatorScreen extends StatefulWidget {
  const EmiCalculatorScreen({super.key});

  @override
  State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {
  double _loanAmount = 500000;
  double _tenureMonths = 60;
  double _annualInterestRate = 9.5;

  double get _monthlyInterestRate => _annualInterestRate / 12 / 100;

  double get _monthlyEmi {
    final principal = _loanAmount;
    final rate = _monthlyInterestRate;
    final tenure = _tenureMonths.round();

    if (rate == 0) {
      return principal / tenure;
    }

    final growth = math.pow(1 + rate, tenure).toDouble();
    return principal * rate * growth / (growth - 1);
  }

  double get _totalPayable => _monthlyEmi * _tenureMonths.round();

  double get _totalInterest => _totalPayable - _loanAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMI Calculator')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Plan your loan',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Adjust the values below to estimate your monthly payment.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            _CalculatorSlider(
              title: 'Loan amount',
              valueText: _formatCurrency(_loanAmount),
              value: _loanAmount,
              min: 50000,
              max: 2000000,
              divisions: 39,
              onChanged: (value) => setState(() => _loanAmount = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            _CalculatorSlider(
              title: 'Tenure',
              valueText: '${_tenureMonths.round()} months',
              value: _tenureMonths,
              min: 6,
              max: 120,
              divisions: 114,
              onChanged: (value) => setState(() => _tenureMonths = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            _CalculatorSlider(
              title: 'Interest rate',
              valueText: '${_annualInterestRate.toStringAsFixed(1)}% p.a.',
              value: _annualInterestRate,
              min: 5,
              max: 24,
              divisions: 190,
              onChanged: (value) {
                setState(() => _annualInterestRate = value);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            _ResultCard(
              monthlyEmi: _monthlyEmi,
              principal: _loanAmount,
              totalInterest: _totalInterest,
              totalPayable: _totalPayable,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Apply for this loan',
              onPressed: () => context.push('/apply'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculatorSlider extends StatelessWidget {
  const _CalculatorSlider({
    required this.title,
    required this.valueText,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String title;
  final String valueText;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                valueText,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: valueText,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.monthlyEmi,
    required this.principal,
    required this.totalInterest,
    required this.totalPayable,
  });

  final double monthlyEmi;
  final double principal;
  final double totalInterest;
  final double totalPayable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Monthly EMI',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _formatCurrency(monthlyEmi),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: IntrinsicColumnWidth(),
            },
            children: [
              _breakdownTableRow('Principal', _formatCurrency(principal)),
              _breakdownSpacerRow(),
              _breakdownTableRow(
                'Total interest',
                _formatCurrency(totalInterest),
              ),
              _breakdownSpacerRow(),
              _breakdownTableRow(
                'Total payable',
                _formatCurrency(totalPayable),
                isEmphasized: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

TableRow _breakdownTableRow(
  String label,
  String value, {
  bool isEmphasized = false,
}) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: isEmphasized ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      ),
    ],
  );
}

TableRow _breakdownSpacerRow() {
  return const TableRow(
    children: [
      Divider(height: 24),
      Divider(height: 24),
    ],
  );
}

String _formatCurrency(double value) {
  final amount = value.round().toString();

  if (amount.length <= 3) {
    return 'Rs. $amount';
  }

  final lastThree = amount.substring(amount.length - 3);
  var leading = amount.substring(0, amount.length - 3);
  final groups = <String>[];

  while (leading.length > 2) {
    groups.insert(0, leading.substring(leading.length - 2));
    leading = leading.substring(0, leading.length - 2);
  }

  if (leading.isNotEmpty) {
    groups.insert(0, leading);
  }

  return 'Rs. ${groups.join(',')},$lastThree';
}
