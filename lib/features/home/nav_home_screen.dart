import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';

class NavHomeScreen extends StatelessWidget {
  const NavHomeScreen({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _TabItem(label: 'Home', icon: Icons.home_outlined, route: AppRoutePaths.home),
    _TabItem(label: 'Loans', icon: Icons.account_balance_wallet_outlined, route: AppRoutePaths.loans),
    _TabItem(label: 'Payments', icon: Icons.payment_outlined, route: AppRoutePaths.payments),
    _TabItem(label: 'Profile', icon: Icons.person_outline, route: AppRoutePaths.profile),
  ];

  void _onItemTapped(BuildContext context, int index) {
    context.go(_tabs[index].route);
  }

  int _selectedIndex(String location) {
    final index = _tabs.indexWhere((tab) => location.startsWith(tab.route));
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    // GoRouter's `.location` getter was removed in recent versions;
    // use GoRouterState to read the current URI instead.
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _selectedIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: _tabs
            .map((tab) => NavigationDestination(
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(tab.icon, color: AppColors.accent),
                  label: tab.label,
                ))
            .toList(),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.label, required this.icon, required this.route});

  final String label;
  final IconData icon;
  final String route;
}