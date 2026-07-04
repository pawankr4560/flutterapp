import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';

/// Placeholder dashboard for the first FinHub business overview.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const List<_DashboardModule> _modules = [
    _DashboardModule('Loans', Icons.account_balance_rounded),
    _DashboardModule('Bookings', Icons.directions_car_rounded),
    _DashboardModule('Inventory', Icons.inventory_2_rounded),
    _DashboardModule('Plots', Icons.map_rounded),
    _DashboardModule('Dairy', Icons.agriculture_rounded),
    _DashboardModule('Reports', Icons.bar_chart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FinHub')),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: _modules.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.12,
          ),
          itemBuilder: (context, index) {
            final module = _modules[index];
            return AppCard(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(module.icon, color: AppColors.primary, size: 32),
                  const Spacer(),
                  Text(module.title, style: AppTextStyles.titleMedium(context)),
                  const SizedBox(height: 6),
                  Text('Coming soon', style: AppTextStyles.bodyMedium(context)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Dashboard module metadata for placeholder tiles.
class _DashboardModule {
  const _DashboardModule(this.title, this.icon);

  final String title;
  final IconData icon;
}


