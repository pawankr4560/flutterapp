import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_form_controls.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';

part 'construction_dashboard.dart';
part 'material_categories_screen.dart';
part 'request_quote_screen.dart';
part 'orders_screen.dart';
part 'delivery_tracking_screen.dart';
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

  final List<_QuoteRequest> _quotes = [];

  static const List<_MaterialCategory> _categories = [
    _MaterialCategory('Cement', 'OPC, PPC, bags', Icons.foundation_rounded),
    _MaterialCategory(
      'Steel',
      'TMT bars, rods, sheets',
      Icons.construction_rounded,
    ),
    _MaterialCategory('Sand', 'River sand, M-Sand', Icons.landscape_rounded),
    _MaterialCategory(
      'Gitti / Aggregate',
      '10mm, 20mm, 40mm',
      Icons.grain_rounded,
    ),
    _MaterialCategory(
      'Concrete',
      'Ready-mix M20, M25, M30',
      Icons.factory_rounded,
    ),
    _MaterialCategory(
      'Bricks & Blocks',
      'Red bricks, fly-ash, AAC',
      Icons.warehouse_rounded,
    ),
  ];

  static const List<_MaterialProduct> _products = [
    _MaterialProduct('UltraTech PPC Cement', 'Cement', 'Bag', 'Available', 380),
    _MaterialProduct('ACC OPC Cement', 'Cement', 'Bag', 'Available', 410),
    _MaterialProduct(
      'TMT Steel Bar 12mm',
      'Steel',
      'Ton',
      'Available',
      58000,
      grade: 'Fe 500D',
    ),
    _MaterialProduct(
      'TMT Steel Bar 16mm',
      'Steel',
      'Ton',
      'Available',
      57500,
      grade: 'Fe 500D',
    ),
    _MaterialProduct(
      'River Sand',
      'Sand',
      'Tractor / Ton / CFT',
      'Available',
      null,
    ),
    _MaterialProduct('M-Sand', 'Sand', 'Ton', 'Available', 1250),
    _MaterialProduct(
      '20mm Aggregate',
      'Gitti / Aggregate',
      'Ton',
      'Available',
      950,
    ),
    _MaterialProduct(
      '40mm Aggregate',
      'Gitti / Aggregate',
      'Ton',
      'Available',
      850,
    ),
    _MaterialProduct(
      'Ready Mix Concrete M20',
      'Concrete',
      'Cubic Meter',
      'Available',
      null,
    ),
    _MaterialProduct(
      'Ready Mix Concrete M25',
      'Concrete',
      'Cubic Meter',
      'Available',
      null,
    ),
    _MaterialProduct(
      'Red Brick',
      'Bricks & Blocks',
      '1000 pcs',
      'Available',
      7500,
    ),
    _MaterialProduct('AAC Block', 'Bricks & Blocks', 'pcs', 'Available', 55),
  ];

  static const List<_OrderEntry> _orders = [
    _OrderEntry(
      'CM-2026-0001',
      'TMT Steel Bar 12mm',
      '2 Ton',
      'Rs. 1,16,000',
      'Confirmed',
      '08/07/2026',
      'Site A, Indore',
    ),
    _OrderEntry(
      'CM-2026-0002',
      'PPC Cement',
      '100 Bags',
      'Rs. 38,000',
      'Pending',
      '09/07/2026',
      'Warehouse Road',
    ),
    _OrderEntry(
      'CM-2026-0003',
      'M-Sand',
      '10 Ton',
      'Rs. 12,500',
      'Delivered',
      '05/07/2026',
      'Plot 21, Rau',
    ),
  ];

  static const List<_DeliveryEntry> _deliveries = [
    _DeliveryEntry(
      'Cement',
      'UP65 AB 1234',
      'Ramesh Kumar',
      'Out for Delivery',
      '2 hours',
      0.72,
    ),
    _DeliveryEntry(
      'Steel',
      'UP65 CD 5678',
      'Suresh Yadav',
      'Loading',
      'Today evening',
      0.38,
    ),
    _DeliveryEntry(
      'Sand',
      'UP65 EF 9012',
      'Amit Singh',
      'Delivered',
      'Completed',
      1,
    ),
  ];

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
    final pages = [
      _ConstructionDashboard(
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
        onSubmit: () => _submitQuote('Quote request submitted successfully'),
      ),
      const _OrdersScreen(orders: _orders),
      const _DeliveryTrackingScreen(deliveries: _deliveries),
    ];

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
    final firstProduct = _products.firstWhere((product) {
      return product.category == category;
    });
    setState(() {
      _quoteCategory = category;
      _quoteProduct = firstProduct.name;
      _quoteUnit = firstProduct.unit;
    });
  }

  void _setQuoteProduct(String productName) {
    final product = _products.firstWhere((item) => item.name == productName);
    setState(() {
      _quoteCategory = product.category;
      _quoteProduct = product.name;
      _quoteUnit = product.unit;
    });
  }

  void _submitQuote(String message) {
    if (!_formKey.currentState!.validate()) return;
    final product = _selectedQuoteProduct;
    _quotes.insert(
      0,
      _QuoteRequest(
        product.name,
        _quoteCategory,
        '${_quantityController.text.trim()} $_quoteUnit',
        _locationController.text.trim(),
        _requiredDate,
      ),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    _formKey.currentState!.reset();
    _quantityController.text = '10';
    _locationController.clear();
    _phoneController.clear();
    _notesController.clear();
    setState(() {});
  }

  _MaterialProduct get _selectedQuoteProduct {
    return _products.firstWhere((product) => product.name == _quoteProduct);
  }
}

