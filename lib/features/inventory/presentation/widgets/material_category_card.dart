part of '../pages/inventory_directory_page.dart';

class _MaterialCategoryCard extends StatelessWidget {
  const _MaterialCategoryCard({
    required this.category,
    required this.onTap,
    this.selected = false,
  });

  final _MaterialCategory category;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.12)
          : Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: _ConstructionPanel(
          borderColor: selected ? AppColors.primary : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SoftIcon(icon: category.icon),
              const SizedBox(height: AppSpacing.sm),
              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium(context),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Flexible(
                child: Text(
                  category.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
