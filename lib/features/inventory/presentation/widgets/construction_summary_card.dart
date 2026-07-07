part of '../pages/inventory_directory_page.dart';

class ConstructionSummaryCard extends StatelessWidget {
  const ConstructionSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SoftIcon(icon: icon),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall(context),
          ),
          const SizedBox(height: AppSpacing.xxs),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(value, style: AppTextStyles.titleLarge(context)),
          ),
        ],
      ),
    );
  }
}

