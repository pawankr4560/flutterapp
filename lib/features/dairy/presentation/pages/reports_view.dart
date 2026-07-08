part of 'milk_directory_page.dart';

class _ReportsView extends StatelessWidget {
  const _ReportsView({
    required this.period,
    required this.onPeriodChanged,
    required this.reports,
  });

  final String period;
  final ValueChanged<String> onPeriodChanged;
  final List<_ReportEntry> reports;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'Today', label: Text('Today')),
            ButtonSegment(value: 'Week', label: Text('Week')),
            ButtonSegment(value: 'Month', label: Text('Month')),
          ],
          selected: {period},
          onSelectionChanged: (value) => onPeriodChanged(value.first),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (reports.isEmpty)
          const _DairyEmptyMessage(message: 'No reports available')
        else
          for (final report in reports) ...[
            _ReportCard(
              title: report.title,
              value: report.value,
              progress: report.progress,
              icon: _reportIcon(report.key),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
      ],
    );
  }
}

IconData _reportIcon(String key) {
  return switch (key) {
    'dailyCollection' => Icons.water_drop_rounded,
    'salesReport' => Icons.point_of_sale_rounded,
    'pendingPayments' => Icons.pending_actions_rounded,
    'productStock' => Icons.inventory_2_rounded,
    'profitSummary' => Icons.trending_up_rounded,
    _ => Icons.insights_rounded,
  };
}

