part of '../pages/inventory_directory_page.dart';

class _MaterialCard extends StatelessWidget {
  const _MaterialCard({
    required this.product,
    required this.onQuote,
    required this.onOrder,
  });

  final _MaterialProduct product;
  final VoidCallback onQuote;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Column(
        children: [
          Row(
            children: [
              _SoftIcon(icon: _categoryIcon(product.category)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium(context),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${product.category} - ${product.unit}'
                      '${product.grade == null ? '' : ' - ${product.grade}'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ConstructionStatusBadge(label: product.stock),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.priceText,
                  style: AppTextStyles.titleMedium(context).copyWith(
                    color: product.rate == null
                        ? AppColors.textSecondary
                        : AppColors.accentDark,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: onQuote,
                child: const Text('Request Quote'),
              ),
              const SizedBox(width: AppSpacing.xs),
              FilledButton(onPressed: onOrder, child: const Text('Order Now')),
            ],
          ),
        ],
      ),
    );
  }
}
