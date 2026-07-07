part of '../pages/milk_directory_page.dart';

class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({required this.product});

  final _ProductEntry product;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SoftIcon(icon: _productIcon(product.name)),
              const Spacer(),
              if (product.stock <= 8) const _LowStockBadge(),
            ],
          ),
          const Spacer(),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium(context),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Stock: ${product.stockText}',
            style: AppTextStyles.bodySmall(context),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Price: ${_money(product.sellingPrice)}/${product.unit}',
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      ),
    );
  }
}

