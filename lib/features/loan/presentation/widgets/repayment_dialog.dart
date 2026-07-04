import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/app_text_field.dart';
import 'package:finhub/core/widgets/primary_button.dart';
import 'package:finhub/core/widgets/secondary_button.dart';

/// Dialog for confirming an EMI collection amount.
class RepaymentDialog extends StatefulWidget {
  const RepaymentDialog({super.key, required this.initialAmount});

  final double initialAmount;

  @override
  State<RepaymentDialog> createState() => _RepaymentDialogState();
}

class _RepaymentDialogState extends State<RepaymentDialog> {
  late final TextEditingController _amountController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialAmount.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Collect EMI', style: AppTextStyles.titleLarge(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount to Collect', style: AppTextStyles.bodyMedium(context)),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _amountController,
            labelText: 'Payment Amount',
            prefixIcon: Icons.currency_rupee_rounded,
            keyboardType: TextInputType.number,
            errorText: _errorText,
            onChanged: (_) {
              if (_errorText != null) {
                setState(() => _errorText = null);
              }
            },
          ),
        ],
      ),
      actions: [
        SecondaryButton(
          text: 'Cancel',
          fullWidth: false,
          onPressed: () => Navigator.of(context).pop(),
        ),
        PrimaryButton(
          text: 'Confirm Collection',
          fullWidth: false,
          onPressed: _confirm,
        ),
      ],
    );
  }

  void _confirm() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _errorText = 'Enter a valid amount');
      return;
    }

    Navigator.of(context).pop(amount);
  }
}
