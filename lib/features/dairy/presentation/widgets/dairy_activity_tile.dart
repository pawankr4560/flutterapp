part of '../pages/milk_directory_page.dart';

class _DairyActivityTile extends StatelessWidget {
  const _DairyActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Row(
        children: [
          _SoftIcon(icon: icon),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium(context)),
                Text(subtitle, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
          Text(time, style: AppTextStyles.bodySmall(context)),
        ],
      ),
    );
  }
}

