part of '../pages/plot_directory_page.dart';

class _SavedPlotCard extends StatelessWidget {
  const _SavedPlotCard({required this.plot, required this.onRemove});

  final _PlotData plot;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.overlay,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Image.network(
                plot.images.first,
                width: 92,
                height: 92,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(
                    width: 92,
                    height: 92,
                    color: AppColors.surfaceMuted,
                    child: const Icon(Icons.landscape_rounded),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plot.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium(context),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  PriceTag(price: plot.price),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    plot.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall(context),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Remove favourite',
              onPressed: onRemove,
              icon: const Icon(Icons.favorite_rounded, color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
}

