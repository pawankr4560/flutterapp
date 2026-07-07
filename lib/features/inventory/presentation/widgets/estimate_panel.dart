part of '../pages/inventory_directory_page.dart';

class _EstimatePanel extends StatelessWidget {
  const _EstimatePanel({required this.amount, required this.quoteOnly});

  final double? amount;
  final bool quoteOnly;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Row(
        children: [
          Icon(
            quoteOnly ? Icons.info_outline_rounded : Icons.payments_rounded,
            color: _amberDark,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              quoteOnly
                  ? 'Final price will be shared after supplier confirmation'
                  : 'Estimated amount: ${_money(amount ?? 0)}',
              style: AppTextStyles.titleMedium(context),
            ),
          ),
        ],
      ),
    );
  }
}

