part of '../pages/milk_directory_page.dart';

class _DairySummaryCard extends StatelessWidget {
  const _DairySummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
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

