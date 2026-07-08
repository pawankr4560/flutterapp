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
part 'request_quote_screen.dart';
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

class _InventoryDirectoryPageState extends State<InventoryDirectoryPage> {
  int _tabIndex = 0;
  String _selectedCategory = 'Cement';
  String _quoteCategory = 'Cement';
  String _quoteProduct = 'UltraTech PPC Cement';
  String _quoteUnit = 'Bag';
  DateTime _requiredDate = DateTime.now().add(const Duration(days: 1));

  final _quantityController = TextEditingController(text: '10');
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _service = _ConstructionApiService();
  var _loading = true;
  var _submittingQuote = false;
  String? _errorMessage;

  _ConstructionDashboardData _dashboard = const _ConstructionDashboardData();
  List<_MaterialCategory> _categories = const [];
  List<_MaterialProduct> _products = const [];
  List<_OrderEntry> _orders = const [];
  List<_DeliveryEntry> _deliveries = const [];
  final List<_QuoteRequest> _quotes = [];

  @override
  void initState() {
    super.initState();
    _loadConstructionData();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
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
                style: AppTextStyles.titleMedium(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2_rounded),
              label: 'Materials',
            ),
            NavigationDestination(
              icon: Icon(Icons.request_quote_outlined),
              selectedIcon: Icon(Icons.request_quote_rounded),
              label: 'Quote',
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
        onBrowse: () => setState(() => _tabIndex = 1),
        onQuote: () => setState(() => _tabIndex = 2),
        onOrders: () => setState(() => _tabIndex = 3),
        onDelivery: () => setState(() => _tabIndex = 4),
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
        products: _products
            .where((product) => product.category == _selectedCategory)
            .toList(),
        onCategorySelected: (category) {
          setState(() => _selectedCategory = category);
        },
        onQuote: _startQuote,
        onOrder: _startOrder,
      ),
      _RequestQuoteScreen(
        formKey: _formKey,
        categories: _categories,
        products: _products,
        selectedCategory: _quoteCategory,
        selectedProduct: _quoteProduct,
        selectedUnit: _quoteUnit,
        requiredDate: _requiredDate,
        quantityController: _quantityController,
        locationController: _locationController,
        phoneController: _phoneController,
        notesController: _notesController,
        onCategoryChanged: _setQuoteCategory,
        onProductChanged: _setQuoteProduct,
        onUnitChanged: (unit) => setState(() => _quoteUnit = unit),
        onDateChanged: (date) => setState(() => _requiredDate = date),
        submitting: _submittingQuote,
        onSubmit: _submitQuote,
      ),
      _OrdersScreen(orders: _orders),
      _DeliveryTrackingScreen(deliveries: _deliveries),
    ];

    return pages[_tabIndex];
  }

  String get _titleForTab {
    return switch (_tabIndex) {
      1 => 'Browse Materials',
      2 => 'Request Quote',
      3 => 'My Orders',
      4 => 'Track Delivery',
      _ => 'Construction Materials',
    };
  }

  void _startQuote(_MaterialProduct product) {
    _setQuoteProduct(product.name);
    setState(() => _tabIndex = 2);
  }

  void _startOrder(_MaterialProduct product) {
    _setQuoteProduct(product.name);
    setState(() => _tabIndex = 2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Use this form to place your order')),
        );
      }
    });
  }

  void _setQuoteCategory(String category) {
    final firstProduct = _firstOrNull(_products.where((product) {
      return product.category == category;
    }));
    if (firstProduct == null) return;
    setState(() {
      _quoteCategory = category;
      _quoteProduct = firstProduct.name;
      _quoteUnit = firstProduct.unit;
    });
  }

  void _setQuoteProduct(String productName) {
    final product = _firstOrNull(
      _products.where((item) => item.name == productName),
    );
    if (product == null) return;
    setState(() {
      _quoteCategory = product.category;
      _quoteProduct = product.name;
      _quoteUnit = product.unit;
    });
  }

  Future<void> _submitQuote() async {
    if (!_formKey.currentState!.validate()) return;
    final product = _selectedQuoteProduct;
    setState(() => _submittingQuote = true);

    try {
      final quote = await _service.createQuote(
        bearerToken: AuthSession.instance.bearerToken,
        categoryId: product.categoryId,
        productId: product.id,
        quantity: double.parse(_quantityController.text.trim()),
        unit: _quoteUnit,
        deliveryLocation: _locationController.text.trim(),
        requiredDate: _requiredDate,
        contactNumber: _phoneController.text.trim(),
        notes: _notesController.text.trim(),
      );
      _quotes.insert(0, quote);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote request submitted successfully')),
      );
      _formKey.currentState!.reset();
      _quantityController.text = '10';
      _locationController.clear();
      _phoneController.clear();
      _notesController.clear();
      await _refreshDashboardAndOrders();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_friendlyError(error))),
      );
      setState(() => _submittingQuote = false);
    }
  }

  Future<void> _loadConstructionData() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final token = AuthSession.instance.bearerToken;
      final results = await Future.wait([
        _service.fetchDashboard(token),
        _service.fetchCategories(token),
        _service.fetchProducts(token),
        _service.fetchOrders(token),
        _service.fetchDeliveries(token),
      ]);

      final categories = results[1] as List<_MaterialCategory>;
      final products = results[2] as List<_MaterialProduct>;
      final firstCategory = _firstOrNull(categories);
      final firstProduct = _firstOrNull(products);

      if (!mounted) return;
      setState(() {
        _dashboard = results[0] as _ConstructionDashboardData;
        _categories = categories;
        _products = products;
        _orders = results[3] as List<_OrderEntry>;
        _deliveries = results[4] as List<_DeliveryEntry>;
        if (firstCategory != null) {
          _selectedCategory = firstCategory.name;
          _quoteCategory = firstCategory.name;
        }
        if (firstProduct != null) {
          _quoteCategory = firstProduct.category;
          _quoteProduct = firstProduct.name;
          _quoteUnit = firstProduct.unit;
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
        _submittingQuote = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _submittingQuote = false);
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    return message.isEmpty ? 'Something went wrong. Please try again.' : message;
  }

  _MaterialProduct get _selectedQuoteProduct {
    return _products.firstWhere(
      (product) => product.name == _quoteProduct,
      orElse: () => _products.first,
    );
  }
}

T? _firstOrNull<T>(Iterable<T> values) {
  final iterator = values.iterator;
  return iterator.moveNext() ? iterator.current : null;
}

