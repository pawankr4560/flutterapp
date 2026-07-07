part of '../pages/milk_directory_page.dart';

class _SaleCard extends StatelessWidget {
  const _SaleCard({required this.sale});

  final _SaleEntry sale;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Row(
        children: [
          const _SoftIcon(icon: Icons.receipt_long_rounded),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sale.customer, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${sale.product} - ${sale.quantityText}',
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _DairyStatusBadge(label: sale.status),
              const SizedBox(height: AppSpacing.xs),
              Text(sale.amountText, style: AppTextStyles.titleMedium(context)),
            ],
          ),
        ],
      ),
    );
  }
}

