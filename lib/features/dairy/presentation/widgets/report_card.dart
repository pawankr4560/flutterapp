part of '../pages/milk_directory_page.dart';

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.value,
    required this.progress,
    required this.icon,
  });

  final String title;
  final String value;
  final double progress;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Column(
        children: [
          Row(
            children: [
              _SoftIcon(icon: icon),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(title, style: AppTextStyles.titleMedium(context)),
              ),
              Text(value, style: AppTextStyles.titleMedium(context)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            backgroundColor: _teal.withValues(alpha: 0.1),
            color: _teal,
          ),
        ],
      ),
    );
  }
}

