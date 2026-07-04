import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/plot/domain/entities/plot_listing.dart';
import 'package:finhub/features/plot/presentation/providers/plot_provider.dart';
import 'package:finhub/features/plot/presentation/widgets/plot_listing_card.dart';

/// Directory page for plot and real estate inventory.
class PlotDirectoryPage extends ConsumerStatefulWidget {
  const PlotDirectoryPage({super.key});

  @override
  ConsumerState<PlotDirectoryPage> createState() => _PlotDirectoryPageState();
}

class _PlotDirectoryPageState extends ConsumerState<PlotDirectoryPage> {
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final plots = ref.watch(plotProvider);
    final filteredPlots = _selectedStatus == 'All'
        ? plots
        : plots.where((plot) => plot.status == _selectedStatus).toList();
    final availableCount = plots.where((plot) => plot.isAvailable).length;
    final inventoryValue = plots.fold<double>(
      0,
      (total, plot) => total + plot.price,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Plot Directory')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _PlotSummary(
              availableCount: availableCount,
              totalCount: plots.length,
              inventoryValue: inventoryValue,
            ),
            const SizedBox(height: AppSpacing.lg),
            _StatusFilters(
              selectedStatus: _selectedStatus,
              onChanged: (status) => setState(() => _selectedStatus = status),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openSiteVisitRequests,
                icon: const Icon(Icons.calendar_month_rounded),
                label: const Text('Site visit requests'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (filteredPlots.isEmpty)
              _EmptyPlots(status: _selectedStatus)
            else
              for (final plot in filteredPlots) ...[
                PlotListingCard(
                  plot: plot,
                  onBookVisit: plot.isAvailable
                      ? () => _requestSiteVisit(context, plot)
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        ),
      ),
    );
  }

  void _openSiteVisitRequests() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SiteVisitRequestsPage(),
      ),
    );
  }

  void _requestSiteVisit(BuildContext context, PlotListing plot) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Site visit requested for ${plot.projectName} ${plot.plotNumber}.'),
      ),
    );
  }
}

/// Site visit request list for plot bookings.
class SiteVisitRequestsPage extends StatelessWidget {
  const SiteVisitRequestsPage({super.key});

  static const List<_SiteVisitRequest> _requests = [
    _SiteVisitRequest(
      customerName: 'Rahul Mehta',
      plotLabel: 'Green Valley Plot 14',
      schedule: '5 Jul, 11:00 am',
      status: 'Pending',
    ),
    _SiteVisitRequest(
      customerName: 'Sunita Rao',
      plotLabel: 'Sunrise Plot 7',
      schedule: '4 Jul, 4:30 pm',
      status: 'Confirmed',
    ),
    _SiteVisitRequest(
      customerName: 'Vikram Singh',
      plotLabel: 'Lakeview Plot 2',
      schedule: '3 Jul, 9:15 am',
      status: 'Confirmed',
    ),
    _SiteVisitRequest(
      customerName: 'Farah Khan',
      plotLabel: 'Green Valley Plot 9',
      schedule: '6 Jul, 3:00 pm',
      status: 'Pending',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Site visit requests')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Site visit requests',
              style: AppTextStyles.titleLarge(context),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final request in _requests) ...[
              _SiteVisitRequestTile(request: request),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlotSummary extends StatelessWidget {
  const _PlotSummary({
    required this.availableCount,
    required this.totalCount,
    required this.inventoryValue,
  });

  final int availableCount;
  final int totalCount;
  final double inventoryValue;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.warning.withValues(alpha: 0.1),
      child: Row(
        children: [
          const Icon(
            Icons.real_estate_agent_rounded,
            color: AppColors.warning,
            size: AppSpacing.xl,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _Metric(
              label: 'Available',
              value: '$availableCount / $totalCount',
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _Metric(
              label: 'Portfolio Value',
              value: 'Rs. ${(inventoryValue / 100000).toStringAsFixed(1)}L',
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusFilters extends StatelessWidget {
  const _StatusFilters({
    required this.selectedStatus,
    required this.onChanged,
  });

  final String selectedStatus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final status in const ['All', 'Available', 'Booked', 'Sold']) ...[
            ChoiceChip(
              label: Text(status),
              selected: selectedStatus == status,
              onSelected: (_) => onChanged(status),
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
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _EmptyPlots extends StatelessWidget {
  const _EmptyPlots({required this.status});

  final String status;

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
        'No $status plots found.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyLarge(context).copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SiteVisitRequestTile extends StatelessWidget {
  const _SiteVisitRequestTile({required this.request});

  final _SiteVisitRequest request;

  @override
  Widget build(BuildContext context) {
    final isConfirmed = request.status == 'Confirmed';
    final color = isConfirmed ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.customerName, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${request.plotLabel} - ${request.schedule}',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Text(
              request.status,
              style: AppTextStyles.bodySmall(context).copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
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

class _SiteVisitRequest {
  const _SiteVisitRequest({
    required this.customerName,
    required this.plotLabel,
    required this.schedule,
    required this.status,
  });

  final String customerName;
  final String plotLabel;
  final String schedule;
  final String status;
}
