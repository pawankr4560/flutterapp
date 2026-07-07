part of '../pages/milk_directory_page.dart';

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({required this.entry});

  final _CollectionEntry entry;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Column(
        children: [
          Row(
            children: [
              const _SoftIcon(icon: Icons.water_drop_rounded),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.farmer,
                      style: AppTextStyles.titleMedium(context),
                    ),
                    Text(
                      '${entry.milkType} milk - ${entry.quantityText}',
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ),
              ),
              Text(entry.amountText, style: AppTextStyles.titleMedium(context)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _DetailPill('Fat', '${entry.fat.toStringAsFixed(1)}%'),
              const SizedBox(width: AppSpacing.xs),
              _DetailPill('Rate', '${entry.rateText}/L'),
            ],
          ),
        ],
      ),
    );
  }
}

