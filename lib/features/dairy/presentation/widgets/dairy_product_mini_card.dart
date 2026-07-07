part of '../pages/milk_directory_page.dart';

class _DairyProductMiniCard extends StatelessWidget {
  const _DairyProductMiniCard({required this.product});

  final _ProductEntry product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136,
      child: _DairyPanel(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SoftIcon(icon: _productIcon(product.name)),
            const Spacer(),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleMedium(context),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Stock: ${product.stockText}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall(context),
            ),
          ],
        ),
      ),
    );
  }
}

