part of '../pages/plot_directory_page.dart';

class _VisitHero extends StatelessWidget {
  const _VisitHero({required this.plot});

  final _PlotData plot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_available_rounded, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plot.title, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(plot.location, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

