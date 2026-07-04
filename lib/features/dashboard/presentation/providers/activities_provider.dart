import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/features/dashboard/domain/entities/recent_activity.dart';

/// Provides mock cross-business recent activities for the dashboard stream.
final recentActivitiesProvider = Provider<List<RecentActivity>>((ref) {
  return const [
    RecentActivity(
      id: 'loan-approved',
      title: 'Loan Approved',
      subtitle: 'Rahul Sharma - ₹50,000',
      timeAgo: '5 mins ago',
      iconName: 'check_circle',
      hexColor: '#4F46E5',
    ),
    RecentActivity(
      id: 'low-stock-alert',
      title: 'Low Stock Alert',
      subtitle: 'Parle-G Biscuit (5 items left)',
      timeAgo: '12 mins ago',
      iconName: 'warning',
      hexColor: '#2563EB',
    ),
    RecentActivity(
      id: 'milk-collected',
      title: 'Milk Collected',
      subtitle: 'Buffalo Milk - 45 Liters',
      timeAgo: '1 hr ago',
      iconName: 'water_drop',
      hexColor: '#06B6D4',
    ),
    RecentActivity(
      id: 'new-car-booking',
      title: 'New Car Booking',
      subtitle: 'Swift Dzire - 2 Days',
      timeAgo: '2 hrs ago',
      iconName: 'directions_car',
      hexColor: '#22C55E',
    ),
  ];
});
