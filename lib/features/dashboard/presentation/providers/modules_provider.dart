import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/features/dashboard/domain/entities/business_module.dart';

/// Provides mock dashboard modules for the quick modules grid.
final businessModulesProvider = Provider<List<BusinessModule>>((ref) {
  return const [
    BusinessModule(
      id: 'loan',
      title: 'Loan Management',
      subtitle: '128 Active',
      iconName: 'payments',
      hexColor: '#4F46E5',
      isEnabled: true,
      routePath: '/loans',
    ),
    BusinessModule(
      id: 'inventory',
      title: 'Inventory Status',
      subtitle: '4 Low Stock',
      iconName: 'inventory',
      hexColor: '#2563EB',
      isEnabled: true,
      routePath: '/inventory',
    ),
    BusinessModule(
      id: 'car_booking',
      title: 'Car Rentals',
      subtitle: '3 Booked Today',
      iconName: 'directions_car',
      hexColor: '#22C55E',
      isEnabled: true,
      routePath: '/car-booking',
    ),
    BusinessModule(
      id: 'dairy',
      title: 'Dairy Collection',
      subtitle: 'Ready',
      iconName: 'water_drop',
      hexColor: '#06B6D4',
      isEnabled: true,
      routePath: '/dairy',
    ),
    BusinessModule(
      id: 'plot',
      title: 'Plot & Real Estate',
      subtitle: '12 Available',
      iconName: 'home',
      hexColor: '#F59E0B',
      isEnabled: false,
      routePath: '/plot',
    ),
  ];
});
