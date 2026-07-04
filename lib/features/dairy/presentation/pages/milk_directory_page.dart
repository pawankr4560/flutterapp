import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dairy/domain/entities/milk_collection_log.dart';
import 'package:finhub/features/dairy/presentation/pages/add_collection_page.dart';
import 'package:finhub/features/dairy/presentation/providers/dairy_provider.dart';
import 'package:finhub/features/dairy/presentation/widgets/collection_log_card.dart';

/// Directory page for daily dairy milk collection logs.
class MilkDirectoryPage extends ConsumerStatefulWidget {
  const MilkDirectoryPage({super.key});

  @override
  ConsumerState<MilkDirectoryPage> createState() => _MilkDirectoryPageState();
}

class _MilkDirectoryPageState extends ConsumerState<MilkDirectoryPage> {
  String _selectedShift = 'All';

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(dairyProvider);
    final filteredLogs = _selectedShift == 'All'
        ? logs
        : logs.where((log) => log.shift == _selectedShift).toList();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _HeaderRow(date: _formatDate(DateTime.now())),
            const SizedBox(height: AppSpacing.md),
            _ShiftFilters(
              selectedShift: _selectedShift,
              onChanged: (shift) => setState(() => _selectedShift = shift),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Add collection',
                    icon: Icons.add_rounded,
                    isPrimary: true,
                    onTap: _openAddCollection,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ActionButton(
                    label: 'Summary',
                    icon: Icons.insights_rounded,
                    onTap: () => _openSummary(logs),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (filteredLogs.isEmpty)
              _EmptyCollection(selectedShift: _selectedShift)
            else
              for (final log in filteredLogs) ...[
                CollectionLogCard(log: log),
                const SizedBox(height: AppSpacing.sm),
              ],
          ],
        ),
      ),
    );
  }

  void _openAddCollection() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AddCollectionPage()),
    );
  }

  void _openSummary(List<MilkCollectionLog> logs) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MilkSummaryPage(logs: logs),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }
}

/// Summary screen for today's dairy collection metrics.
class MilkSummaryPage extends StatelessWidget {
  const MilkSummaryPage({super.key, required this.logs});

  final List<MilkCollectionLog> logs;

  @override
  Widget build(BuildContext context) {
    final totalMilk = logs.fold<double>(0, (total, log) {
      return total + log.quantityInLiters;
    });
    final totalPayable = logs.fold<double>(0, (total, log) {
      return total + log.totalAmount;
    });
    final avgFat = logs.isEmpty
        ? 0
        : logs.fold<double>(0, (total, log) => total + log.fatPercentage) /
            logs.length;
    final morningMilk = _shiftTotal('Morning');
    final eveningMilk = _shiftTotal('Evening');

    return Scaffold(
      appBar: AppBar(title: const Text("Today's summary")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              '${_formatDate(DateTime.now())} - both shifts',
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _SummaryMetric(
                  label: 'Total collected',
                  value: '${totalMilk.toStringAsFixed(1)} L',
                ),
                _SummaryMetric(label: 'Entries', value: logs.length.toString()),
                _SummaryMetric(
                  label: 'Avg fat content',
                  value: '${avgFat.toStringAsFixed(1)}%',
                ),
                _SummaryMetric(
                  label: 'Total payable',
                  value: _formatCurrency(totalPayable),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Collection by shift', style: AppTextStyles.titleLarge(context)),
            const SizedBox(height: AppSpacing.md),
            _ShiftProgress(
              label: 'Morning',
              value: morningMilk,
              total: totalMilk,
            ),
            const SizedBox(height: AppSpacing.md),
            _ShiftProgress(
              label: 'Evening',
              value: eveningMilk,
              total: totalMilk,
            ),
          ],
        ),
      ),
    );
  }

  double _shiftTotal(String shift) {
    return logs
        .where((log) => log.shift == shift)
        .fold<double>(0, (total, log) => total + log.quantityInLiters);
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('Milk collection', style: AppTextStyles.titleLarge(context)),
        ),
        Text(
          date,
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ShiftFilters extends StatelessWidget {
  const _ShiftFilters({required this.selectedShift, required this.onChanged});

  final String selectedShift;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        for (final shift in const ['All', 'Morning', 'Evening'])
          ChoiceChip(
            label: Text(shift),
            selected: selectedShift == shift,
            onSelected: (_) => onChanged(shift),
            labelStyle: AppTextStyles.bodyLarge(context).copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            selectedColor: AppColors.primary.withValues(alpha: 0.12),
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              side: const BorderSide(color: AppColors.border),
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final background = isPrimary ? AppColors.primary : AppColors.surface;
    final foreground = isPrimary ? AppColors.surface : AppColors.primary;

    return SizedBox(
      height: AppSpacing.xxl,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          side: BorderSide(color: isPrimary ? AppColors.primary : AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          textStyle: AppTextStyles.labelLarge(context),
        ),
      ),
    );
  }
}

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection({required this.selectedShift});

  final String selectedShift;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'No $selectedShift collection entries yet.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyLarge(context).copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodyMedium(context)),
            const SizedBox(height: AppSpacing.xs),
            Text(value, style: AppTextStyles.titleLarge(context)),
          ],
        ),
      ),
    );
  }
}

class _ShiftProgress extends StatelessWidget {
  const _ShiftProgress({
    required this.label,
    required this.value,
    required this.total,
  });

  final String label;
  final double value;
  final double total;

  @override
  Widget build(BuildContext context) {
    final progress = total <= 0 ? 0.0 : value / total;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)} L',
              style: AppTextStyles.titleMedium(context),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0).toDouble(),
          minHeight: AppSpacing.xs,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          backgroundColor: AppColors.border,
          color: AppColors.primary,
        ),
      ],
    );
  }
}

String _formatCurrency(double value) => 'Rs. ${value.toStringAsFixed(0)}';

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
