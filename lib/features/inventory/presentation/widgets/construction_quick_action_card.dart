part of '../pages/inventory_directory_page.dart';

class ConstructionQuickActionCard extends StatelessWidget {
  const ConstructionQuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: _ConstructionPanel(
          child: Row(
            children: [
              _SoftIcon(icon: icon),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

