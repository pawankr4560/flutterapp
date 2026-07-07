part of 'milk_directory_page.dart';

class _ReportsView extends StatelessWidget {
  const _ReportsView({required this.period, required this.onPeriodChanged});

  final String period;
  final ValueChanged<String> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final reports = const [
      ('Daily Collection', '120 L', 0.82, Icons.water_drop_rounded),
      ('Sales Report', 'Rs. 8,500', 0.74, Icons.point_of_sale_rounded),
      ('Pending Payments', 'Rs. 12,000', 0.52, Icons.pending_actions_rounded),
      ('Product Stock', '131 units', 0.68, Icons.inventory_2_rounded),
      ('Profit Summary', 'Rs. 3,200', 0.61, Icons.trending_up_rounded),
    ];

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
        for (final report in reports) ...[
          _ReportCard(
            title: report.$1,
            value: report.$2,
            progress: report.$3,
            icon: report.$4,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

