part of '../pages/inventory_directory_page.dart';

class _EstimatePanel extends StatelessWidget {
  const _EstimatePanel({required this.amount, required this.priceUnavailable});

  final double? amount;
  final bool priceUnavailable;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Row(
        children: [
          Icon(
            priceUnavailable
                ? Icons.info_outline_rounded
                : Icons.payments_rounded,
            color: AppColors.accentDark,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              priceUnavailable
                  ? 'The final amount will be calculated when the order is placed'
                  : 'Estimated amount: ${_money(amount ?? 0)}',
              style: AppTextStyles.titleMedium(context),
            ),
          ),
        ],
      ),
    );
  }
}
