/// Immutable dashboard overview metrics for FinHub.
class DashboardSummary {
  const DashboardSummary({
    required this.totalIncome,
    required this.pendingEmi,
    required this.bookings,
    required this.inventoryAlerts,
  });

  final int totalIncome;
  final int pendingEmi;
  final int bookings;
  final int inventoryAlerts;
}
