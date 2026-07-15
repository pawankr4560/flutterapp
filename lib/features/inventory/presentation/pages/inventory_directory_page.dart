import 'dart:async';
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

part 'construction_dashboard.dart';
part 'material_categories_screen.dart';
part 'orders_screen.dart';
part 'delivery_tracking_screen.dart';
part 'construction_api_service.dart';
part '../widgets/construction_summary_card.dart';
part '../widgets/construction_quick_action_card.dart';
part '../widgets/material_category_card.dart';
part '../widgets/material_card.dart';
part '../widgets/construction_status_badge.dart';
part '../widgets/delivery_tracking_card.dart';
part '../widgets/order_card.dart';
part '../widgets/direct_order_sheet.dart';
part '../widgets/activity_tile.dart';
part '../widgets/estimate_panel.dart';
part '../widgets/section_header.dart';
part '../widgets/construction_panel.dart';
part '../widgets/soft_icon.dart';
part '../widgets/inventory_models.dart';
part '../widgets/inventory_theme_helpers.dart';

class InventoryDirectoryPage extends StatefulWidget {
  const InventoryDirectoryPage({super.key});

  @override
  State<InventoryDirectoryPage> createState() => _InventoryDirectoryPageState();
}

class _InventoryDirectoryPageState extends State<InventoryDirectoryPage>
    with WidgetsBindingObserver {
  static const _refreshInterval = Duration(seconds: 10);

  int _tabIndex = 0;
  String _selectedCategory = 'Cement';
  final _service = _ConstructionApiService();
  var _loading = true;
  var _refreshingOrders = false;
  var _refreshingDeliveries = false;
  Timer? _refreshTimer;
  String? _errorMessage;

  _ConstructionDashboardData _dashboard = const _ConstructionDashboardData();
  List<_MaterialCategory> _categories = const [];
  List<_MaterialProduct> _products = const [];
  List<_OrderEntry> _orders = const [];
  List<_DeliveryEntry> _deliveries = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshTimer = Timer.periodic(
      _refreshInterval,
      (_) {
        unawaited(_refreshOrders());
        unawaited(_refreshDeliveries());
      },
    );
    _loadConstructionData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshOrders());
      unawaited(_refreshDeliveries());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = _bodyForState();
    final navDisabled = _loading || _errorMessage != null;

    return Theme(
      data: _constructionTheme(context),
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
                style: AppTextStyles.titleMedium(
                  context,
                ).copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              if (_tabIndex == 0)
                Text(
                  'Quality Materials, Delivered',
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        body: SafeArea(child: body),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tabIndex,
          onDestinationSelected: navDisabled ? null : _selectTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2_rounded),
              label: 'Materials',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_shipping_outlined),
              selectedIcon: Icon(Icons.local_shipping_rounded),
              label: 'Delivery',
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyForState() {
    if (_loading) {
      return const LoadingIndicator(text: 'Loading construction materials...');
    }

    final errorMessage = _errorMessage;
    if (errorMessage != null) {
      return ErrorView(
        title: 'Unable to load materials',
        message: errorMessage,
        retryButtonText: 'Retry',
        onRetry: _loadConstructionData,
      );
    }

    final pages = [
      _ConstructionDashboard(
        dashboard: _dashboard,
        categories: _categories,
        onBrowse: () => _selectTab(1),
        onOrders: () => _selectTab(2),
        onDelivery: () => _selectTab(3),
        onCategoryTap: (category) {
          setState(() {
            _selectedCategory = category;
            _tabIndex = 1;
          });
        },
      ),
      _MaterialCategoriesScreen(
        categories: _categories,
        selectedCategory: _selectedCategory,
        products: _productsForCategory(_selectedCategory),
        onCategorySelected: (category) {
          setState(() => _selectedCategory = category);
        },
        onOrder: _startOrder,
      ),
      _OrdersScreen(orders: _orders),
      _DeliveryTrackingScreen(deliveries: _deliveries),
    ];

    return pages[_tabIndex];
  }

  String get _titleForTab {
    return switch (_tabIndex) {
      1 => 'Browse Materials',
      2 => 'My Orders',
      3 => 'Track Delivery',
      _ => 'Construction Materials',
    };
  }

  void _selectTab(int value) {
    setState(() => _tabIndex = value);
    if (value == 2) unawaited(_refreshOrders());
    if (value == 3) unawaited(_refreshDeliveries());
  }

  Future<void> _startOrder(_MaterialProduct product) async {
    if (product.rate == null || product.rate! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Price is unavailable for this material.')),
      );
      return;
    }
    if (product.unitId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This material does not have a unit ID.')),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => _DirectOrderSheet(
        product: product,
        onSubmit: (input) async {
          await _service.createOrder(
            bearerToken: AuthSession.instance.bearerToken,
            categoryId: product.categoryId,
            productId: product.id,
            quantity: input.quantity,
            price: product.rate!,
            unitId: product.unitId,
            deliveryLocation: input.deliveryLocation,
            requiredDate: input.requiredDate,
            contactNumber: input.contactNumber,
            notes: input.notes,
          );
          await _refreshDashboardAndOrders();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order placed successfully')),
          );
        },
      ),
    );
  }

  Future<void> _loadConstructionData() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final token = AuthSession.instance.bearerToken;
      final results = await Future.wait<Object>([
        _service.fetchDashboard(token),
        _service.fetchCategories(token),
        _service.fetchOrders(token),
        _service.fetchDeliveries(token),
      ]);

      final categories = results[1] as List<_MaterialCategory>;
      final products = await _service.fetchProductsForCategories(
        token,
        categories,
      );
      final firstCategory = _firstOrNull(categories);

      if (!mounted) return;
      setState(() {
        _dashboard = results[0] as _ConstructionDashboardData;
        _categories = categories;
        _products = products;
        _orders = results[2] as List<_OrderEntry>;
        _deliveries = results[3] as List<_DeliveryEntry>;
        if (firstCategory != null) {
          _selectedCategory = firstCategory.name;
        }
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

  Future<void> _refreshDashboardAndOrders() async {
    try {
      final token = AuthSession.instance.bearerToken;
      final results = await Future.wait([
        _service.fetchDashboard(token),
        _service.fetchOrders(token),
        _service.fetchDeliveries(token),
      ]);
      if (!mounted) return;
      setState(() {
        _dashboard = results[0] as _ConstructionDashboardData;
        _orders = results[1] as List<_OrderEntry>;
        _deliveries = results[2] as List<_DeliveryEntry>;
      });
    } catch (_) {}
  }

  Future<void> _refreshOrders() async {
    if (_loading || _refreshingOrders || !mounted) return;
    final token = AuthSession.instance.bearerToken;
    if (token.isEmpty) return;

    _refreshingOrders = true;
    try {
      final orders = await _service.fetchOrders(token);
      if (!mounted) return;
      setState(() => _orders = orders);
    } catch (_) {
      // Background refresh failures should not interrupt the active screen.
    } finally {
      _refreshingOrders = false;
    }
  }

  Future<void> _refreshDeliveries() async {
    if (_loading || _refreshingDeliveries || !mounted) return;
    final token = AuthSession.instance.bearerToken;
    if (token.isEmpty) return;

    _refreshingDeliveries = true;
    try {
      final deliveries = await _service.fetchDeliveries(token);
      if (!mounted) return;
      setState(() => _deliveries = deliveries);
    } catch (_) {
      // Background refresh failures should not interrupt the active screen.
    } finally {
      _refreshingDeliveries = false;
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    return message.isEmpty
        ? 'Something went wrong. Please try again.'
        : message;
  }

  List<_MaterialProduct> _productsForCategory(String categoryName) {
    final category = _firstOrNull(
      _categories.where((item) => item.name == categoryName),
    );
    return _products.where((product) {
      return product.category == categoryName ||
          (category != null && product.categoryId == category.id);
    }).toList();
  }

}

T? _firstOrNull<T>(Iterable<T> values) {
  final iterator = values.iterator;
  return iterator.moveNext() ? iterator.current : null;
}
