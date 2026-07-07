import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_form_controls.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';

part 'dairy_home_view.dart';
part 'collection_view.dart';
part 'sales_view.dart';
part 'payments_view.dart';
part 'reports_view.dart';
part 'customers_screen.dart';
part 'products_screen.dart';
part '../widgets/sheets/collection_form_sheet.dart';
part '../widgets/sheets/sale_form_sheet.dart';
part '../widgets/sheets/customer_form_sheet.dart';
part '../widgets/sheets/product_form_sheet.dart';
part '../widgets/dairy_summary_card.dart';
part '../widgets/dairy_quick_action_card.dart';
part '../widgets/dairy_product_mini_card.dart';
part '../widgets/collection_card.dart';
part '../widgets/sale_card.dart';
part '../widgets/customer_card.dart';
part '../widgets/product_grid_card.dart';
part '../widgets/payment_card.dart';
part '../widgets/report_card.dart';
part '../widgets/sheets/form_widgets.dart';
part '../widgets/dairy_panel.dart';
part '../widgets/soft_icon.dart';
part '../widgets/dairy_activity_tile.dart';
part '../widgets/dairy_section_header.dart';
part '../widgets/dairy_status_badge.dart';
part '../widgets/detail_pill.dart';
part '../widgets/total_banner.dart';
part '../widgets/low_stock_badge.dart';
part '../widgets/dairy_entries.dart';
part '../widgets/dairy_theme_helpers.dart';

class MilkDirectoryPage extends StatefulWidget {
  const MilkDirectoryPage({super.key});

  @override
  State<MilkDirectoryPage> createState() => _MilkDirectoryPageState();
}

class _MilkDirectoryPageState extends State<MilkDirectoryPage> {
  int _tabIndex = 0;
  String _collectionQuery = '';
  String _salesQuery = '';
  String _period = 'Today';

  final List<_CollectionEntry> _collections = [
    _CollectionEntry('Rahul Sharma', 'Cow', 20, 4.5, 42, DateTime.now()),
    _CollectionEntry('Suresh Kumar', 'Buffalo', 15, 6.8, 58, DateTime.now()),
    _CollectionEntry('Amit Singh', 'Cow', 18, 4.2, 40, DateTime.now()),
  ];

  final List<_SaleEntry> _sales = [
    _SaleEntry('Mohit Store', 'Milk', 10, 60, 'Paid', DateTime.now()),
    _SaleEntry('Sharma Sweets', 'Paneer', 5, 400, 'Pending', DateTime.now()),
    _SaleEntry('Fresh Mart', 'Curd', 8, 120, 'Paid', DateTime.now()),
  ];

  final List<_CustomerEntry> _customers = [
    _CustomerEntry(
      'Rahul Sharma',
      '9876543210',
      'Farmer',
      2500,
      'Village Road',
    ),
    _CustomerEntry('Mohit Store', '9876501234', 'Shop', 0, 'Main Market'),
    _CustomerEntry('Sharma Sweets', '9812345678', 'Business', 4200, 'MG Road'),
  ];

  final List<_ProductEntry> _products = [
    _ProductEntry('Milk', 'L', 85, 48, 60),
    _ProductEntry('Paneer', 'kg', 12, 320, 400),
    _ProductEntry('Ghee', 'kg', 8, 540, 650),
    _ProductEntry('Curd', 'kg', 20, 90, 120),
    _ProductEntry('Butter', 'kg', 6, 410, 500),
  ];

  final List<_PaymentEntry> _payments = [
    _PaymentEntry('Rahul Sharma', 2000, 'Cash', 'Received', DateTime.now()),
    _PaymentEntry('Sharma Sweets', 4200, 'UPI', 'Pending', DateTime.now()),
    _PaymentEntry(
      'Mohit Store',
      1500,
      'Bank Transfer',
      'Received',
      DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DairyHomeView(
        products: _products,
        onOpenCollection: () => setState(() => _tabIndex = 1),
        onOpenSales: () => setState(() => _tabIndex = 2),
        onOpenCustomers: () => _openCustomers(),
        onOpenProducts: () => _openProducts(),
      ),
      _CollectionView(
        entries: _filteredCollections,
        onSearch: (value) => setState(() => _collectionQuery = value),
        onAdd: _showAddCollectionSheet,
      ),
      _SalesView(
        sales: _filteredSales,
        onSearch: (value) => setState(() => _salesQuery = value),
        onAdd: _showAddSaleSheet,
      ),
      _PaymentsView(payments: _payments),
      _ReportsView(
        period: _period,
        onPeriodChanged: (value) {
          setState(() => _period = value);
        },
      ),
    ];

    return Theme(
      data: _dairyTheme(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _titleForTab,
                style: AppTextStyles.titleMedium(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (_tabIndex == 0)
                Text(
                  'Manage your dairy business',
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          actions: [
            if (_tabIndex == 0)
              IconButton(
                tooltip: 'Notifications',
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {},
              ),
            const SizedBox(width: AppSpacing.xs),
          ],
        ),
        body: SafeArea(child: pages[_tabIndex]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tabIndex,
          onDestinationSelected: (value) => setState(() => _tabIndex = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.water_drop_outlined),
              selectedIcon: Icon(Icons.water_drop_rounded),
              label: 'Collection',
            ),
            NavigationDestination(
              icon: Icon(Icons.point_of_sale_outlined),
              selectedIcon: Icon(Icons.point_of_sale_rounded),
              label: 'Sales',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Payments',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights_rounded),
              label: 'Reports',
            ),
          ],
        ),
      ),
    );
  }

  String get _titleForTab {
    return switch (_tabIndex) {
      0 => 'Dairy Products',
      1 => 'Milk Collection',
      2 => 'Dairy Sales',
      3 => 'Payments',
      _ => 'Reports',
    };
  }

  List<_CollectionEntry> get _filteredCollections {
    final query = _collectionQuery.toLowerCase().trim();
    if (query.isEmpty) return _collections;
    return _collections.where((entry) {
      return entry.farmer.toLowerCase().contains(query) ||
          entry.milkType.toLowerCase().contains(query);
    }).toList();
  }

  List<_SaleEntry> get _filteredSales {
    final query = _salesQuery.toLowerCase().trim();
    if (query.isEmpty) return _sales;
    return _sales.where((entry) {
      return entry.customer.toLowerCase().contains(query) ||
          entry.product.toLowerCase().contains(query);
    }).toList();
  }

  void _openCustomers() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _CustomersScreen(
          customers: _customers,
          onAdd: _showAddCustomerSheet,
        ),
      ),
    );
  }

  void _openProducts() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            _ProductsScreen(products: _products, onAdd: _showAddProductSheet),
      ),
    );
  }

  Future<void> _showAddCollectionSheet() async {
    final entry = await showModalBottomSheet<_CollectionEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _CollectionFormSheet(),
    );
    if (entry != null) setState(() => _collections.insert(0, entry));
  }

  Future<void> _showAddSaleSheet() async {
    final entry = await showModalBottomSheet<_SaleEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _SaleFormSheet(),
    );
    if (entry != null) setState(() => _sales.insert(0, entry));
  }

  Future<void> _showAddCustomerSheet() async {
    final entry = await showModalBottomSheet<_CustomerEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _CustomerFormSheet(),
    );
    if (entry != null) setState(() => _customers.insert(0, entry));
  }

  Future<void> _showAddProductSheet() async {
    final entry = await showModalBottomSheet<_ProductEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _ProductFormSheet(),
    );
    if (entry != null) setState(() => _products.insert(0, entry));
  }
}

