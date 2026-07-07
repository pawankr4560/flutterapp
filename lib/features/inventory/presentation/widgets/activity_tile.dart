part of '../pages/inventory_directory_page.dart';

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Row(
        children: [
          _SoftIcon(icon: icon),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

