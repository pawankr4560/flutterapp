import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/features/dashboard/domain/entities/business_module.dart';

/// Provides mock dashboard modules for the quick modules grid.
final businessModulesProvider = Provider<List<BusinessModule>>((ref) {
  return const [
    BusinessModule(
      id: 'loan',
      title: 'Loan',
      subtitle: 'Quick & Easy Loans',
      iconName: 'payments',
      hexColor: '#4F46E5',
      isEnabled: true,
      routePath: '/loans',
    ),
    BusinessModule(
      id: 'inventory',
      title: 'Store Inventory',
      subtitle: 'Manage Your Inventory',
      iconName: 'inventory',
      hexColor: '#2563EB',
      isEnabled: true,
      routePath: '/inventory',
    ),
    BusinessModule(
      id: 'car_booking',
      title: 'Car Booking',
      subtitle: 'Book Your Dream Car',
      iconName: 'directions_car',
      hexColor: '#22C55E',
      isEnabled: true,
      routePath: '/car-booking',
    ),
    BusinessModule(
      id: 'dairy',
      title: 'Dairy Products',
      subtitle: 'Fresh & Pure Dairy',
      iconName: 'water_drop',
      hexColor: '#06B6D4',
      isEnabled: true,
      routePath: '/dairy',
    ),
    BusinessModule(
      id: 'plot',
      title: 'Plot Purchase',
      subtitle: 'Find & Buy Best Plots',
      iconName: 'home',
      hexColor: '#F59E0B',
      isEnabled: true,
      routePath: '/plot',
    ),
    BusinessModule(
      id: 'agriculture_pestiside',
      title: 'Agriculture',
      subtitle: 'Field & Stock Records',
      iconName: 'agriculture',
      hexColor: '#16A34A',
      isEnabled: true,
      routePath: '/agriculture-pestiside',
    ),
  ];
});
