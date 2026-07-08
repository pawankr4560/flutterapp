import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:finhub/core/constants/app_config.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_form_controls.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/core/widgets/error_view.dart';
import 'package:finhub/core/widgets/loading_indicator.dart';
import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';

part 'dairy_home_view.dart';
part 'collection_view.dart';
part 'sales_view.dart';
part 'payments_view.dart';
part 'reports_view.dart';
part 'customers_screen.dart';
part 'products_screen.dart';
part 'dairy_api_service.dart';
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

  final _service = _DairyApiService();
  var _loading = true;
  String? _errorMessage;

  _DairyDashboardData _dashboard = const _DairyDashboardData();
  _CollectionSummary _collectionSummary = const _CollectionSummary();
  _SalesSummary _salesSummary = const _SalesSummary();
  _PaymentsSummary _paymentsSummary = const _PaymentsSummary();
  List<_CollectionEntry> _collections = [];
  List<_SaleEntry> _sales = [];
  List<_CustomerEntry> _customers = [];
  List<_ProductEntry> _products = [];
  List<_PaymentEntry> _payments = [];
  List<_ReportEntry> _reports = [];

  @override
  void initState() {
    super.initState();
    _loadDairyData();
  }

  @override
  Widget build(BuildContext context) {
    final body = _bodyForState();
    final navDisabled = _loading || _errorMessage != null;

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
        body: SafeArea(child: body),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tabIndex,
          onDestinationSelected: navDisabled
              ? null
              : (value) => setState(() => _tabIndex = value),
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

  Widget _bodyForState() {
    if (_loading) {
      return const LoadingIndicator(text: 'Loading dairy data...');
    }

    final errorMessage = _errorMessage;
    if (errorMessage != null) {
      return ErrorView(
        title: 'Unable to load dairy data',
        message: errorMessage,
        retryButtonText: 'Retry',
        onRetry: _loadDairyData,
      );
    }

    final pages = [
      _DairyHomeView(
        dashboard: _dashboard,
        products: _products,
        onOpenCollection: () => setState(() => _tabIndex = 1),
        onOpenSales: () => setState(() => _tabIndex = 2),
        onOpenCustomers: () => _openCustomers(),
        onOpenProducts: () => _openProducts(),
      ),
      _CollectionView(
        entries: _filteredCollections,
        summary: _collectionSummary,
        onSearch: (value) => setState(() => _collectionQuery = value),
        onAdd: _showAddCollectionSheet,
      ),
      _SalesView(
        sales: _filteredSales,
        summary: _salesSummary,
        onSearch: (value) => setState(() => _salesQuery = value),
        onAdd: _showAddSaleSheet,
      ),
      _PaymentsView(payments: _payments, summary: _paymentsSummary),
      _ReportsView(
        period: _period,
        onPeriodChanged: (value) {
          setState(() => _period = value);
          _loadReports(value);
        },
        reports: _reports,
      ),
    ];

    return pages[_tabIndex];
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
    if (entry == null) return;
    try {
      final saved = await _service.createCollection(
        entry,
        AuthSession.instance.bearerToken,
      );
      setState(() => _collections.insert(0, saved));
      await _refreshSummaries();
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _showAddSaleSheet() async {
    final entry = await showModalBottomSheet<_SaleEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _SaleFormSheet(),
    );
    if (entry == null) return;
    try {
      final saved = await _service.createSale(
        entry,
        AuthSession.instance.bearerToken,
      );
      setState(() => _sales.insert(0, saved));
      await _refreshSummaries();
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _showAddCustomerSheet() async {
    final entry = await showModalBottomSheet<_CustomerEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _CustomerFormSheet(),
    );
    if (entry == null) return;
    try {
      final saved = await _service.createCustomer(
        entry,
        AuthSession.instance.bearerToken,
      );
      setState(() => _customers.insert(0, saved));
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _showAddProductSheet() async {
    final entry = await showModalBottomSheet<_ProductEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _ProductFormSheet(),
    );
    if (entry == null) return;
    try {
      final saved = await _service.createProduct(
        entry,
        AuthSession.instance.bearerToken,
      );
      setState(() => _products.insert(0, saved));
      await _refreshSummaries();
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _loadDairyData() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final token = AuthSession.instance.bearerToken;
      final results = await Future.wait([
        _service.fetchDashboard(token),
        _service.fetchProducts(token),
        _service.fetchCollections(token),
        _service.fetchSales(token),
        _service.fetchCustomers(token),
        _service.fetchPayments(token),
        _service.fetchReports(_period, token),
      ]);

      final collections = results[2] as _CollectionListResponse;
      final sales = results[3] as _SalesListResponse;
      final payments = results[5] as _PaymentsListResponse;
      final reports = results[6] as List<_ReportEntry>;

      if (!mounted) return;
      setState(() {
        _dashboard = results[0] as _DairyDashboardData;
        _products = results[1] as List<_ProductEntry>;
        _collectionSummary = collections.summary;
        _collections = collections.items;
        _salesSummary = sales.summary;
        _sales = sales.items;
        _customers = results[4] as List<_CustomerEntry>;
        _paymentsSummary = payments.summary;
        _payments = payments.items;
        _reports = reports;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = _friendlyError(error);
      });
    }
  }

  Future<void> _refreshSummaries() async {
    try {
      final token = AuthSession.instance.bearerToken;
      final results = await Future.wait([
        _service.fetchDashboard(token),
        _service.fetchCollections(token),
        _service.fetchSales(token),
        _service.fetchPayments(token),
        _service.fetchReports(_period, token),
      ]);
      final collections = results[1] as _CollectionListResponse;
      final sales = results[2] as _SalesListResponse;
      final payments = results[3] as _PaymentsListResponse;
      if (!mounted) return;
      setState(() {
        _dashboard = results[0] as _DairyDashboardData;
        _collectionSummary = collections.summary;
        _salesSummary = sales.summary;
        _paymentsSummary = payments.summary;
        _payments = payments.items;
        _reports = results[4] as List<_ReportEntry>;
      });
    } catch (_) {}
  }

  Future<void> _loadReports(String period) async {
    try {
      final reports = await _service.fetchReports(
        period,
        AuthSession.instance.bearerToken,
      );
      if (!mounted) return;
      setState(() => _reports = reports);
    } catch (error) {
      _showError(error);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_friendlyError(error))),
    );
  }

  String _friendlyError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    return message.isEmpty ? 'Something went wrong. Please try again.' : message;
  }
}

