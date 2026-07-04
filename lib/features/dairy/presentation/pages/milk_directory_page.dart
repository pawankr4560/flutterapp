import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dairy/presentation/pages/add_collection_page.dart';
import 'package:finhub/features/dairy/presentation/providers/dairy_provider.dart';
import 'package:finhub/features/dairy/presentation/widgets/collection_log_card.dart';

/// Directory page for daily dairy milk collection logs.
class MilkDirectoryPage extends ConsumerWidget {
  const MilkDirectoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(dairyProvider);
    final totalMilk = logs.fold<double>(
      0,
      (total, log) => total + log.quantityInLiters,
    );
    final totalPayout = logs.fold<double>(
      0,
      (total, log) => total + log.totalAmount,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Milk Collection Directory')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AddCollectionPage()),
        ),
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: logs.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _SummaryCard(
                totalMilk: totalMilk,
                totalPayout: totalPayout,
              );
            }

            return CollectionLogCard(log: logs[index - 1]);
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.totalMilk,
    required this.totalPayout,
  });

  final double totalMilk;
  final double totalPayout;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
      child: Row(
        children: [
          const Icon(
            Icons.water_drop_rounded,
            color: AppColors.secondary,
            size: AppSpacing.xl,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _Metric(
              label: 'Milk Today',
              value: '${totalMilk.toStringAsFixed(1)} L',
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _Metric(
              label: 'Total Payout',
              value: '₹${totalPayout.toStringAsFixed(2)}',
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium(context)),
        const SizedBox(height: AppSpacing.xxs),
        Text(value, style: AppTextStyles.titleLarge(context)),
      ],
    );
  }
}
