import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/features/dashboard/domain/entities/dashboard_summary.dart';

/// Provides mock dashboard summary metrics for the foundation UI.
final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  return const DashboardSummary(
    totalIncome: 125000,
    pendingEmi: 18,
    bookings: 12,
    inventoryAlerts: 4,
  );
});
