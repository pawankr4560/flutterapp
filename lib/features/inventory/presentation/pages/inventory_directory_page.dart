import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';

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
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_titleForTab, style: AppTextStyles.titleMedium(context)),
              if (_tabIndex == 0)
                Text(
                  'Quality Materials, Delivered',
                  style: AppTextStyles.bodySmall(context),
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

class _ConstructionDashboard extends StatelessWidget {
  const _ConstructionDashboard({
    required this.categories,
    required this.onBrowse,
    required this.onQuote,
    required this.onOrders,
    required this.onDelivery,
    required this.onCategoryTap,
  });

  final List<_MaterialCategory> categories;
  final VoidCallback onBrowse;
  final VoidCallback onQuote;
  final VoidCallback onOrders;
  final VoidCallback onDelivery;
  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 560 ? 4 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.45,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ConstructionSummaryCard(
                  title: 'Total Products',
                  value: '48',
                  icon: Icons.inventory_2_rounded,
                ),
                ConstructionSummaryCard(
                  title: 'Pending Quotes',
                  value: '6',
                  icon: Icons.request_quote_rounded,
                ),
                ConstructionSummaryCard(
                  title: 'Active Orders',
                  value: '3',
                  icon: Icons.receipt_long_rounded,
                ),
                ConstructionSummaryCard(
                  title: 'Deliveries Today',
                  value: '2',
                  icon: Icons.local_shipping_rounded,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const _SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 560 ? 4 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.72,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ConstructionQuickActionCard(
                  title: 'Browse Materials',
                  icon: Icons.warehouse_rounded,
                  onTap: onBrowse,
                ),
                ConstructionQuickActionCard(
                  title: 'Request Quote',
                  icon: Icons.request_quote_rounded,
                  onTap: onQuote,
                ),
                ConstructionQuickActionCard(
                  title: 'My Orders',
                  icon: Icons.receipt_long_rounded,
                  onTap: onOrders,
                ),
                ConstructionQuickActionCard(
                  title: 'Track Delivery',
                  icon: Icons.local_shipping_rounded,
                  onTap: onDelivery,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const _SectionHeader(title: 'Categories'),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 168,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = categories[index];
              return SizedBox(
                width: 210,
                child: _MaterialCategoryCard(
                  category: category,
                  onTap: () => onCategoryTap(category.name),
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemCount: categories.length,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const _SectionHeader(title: 'Recent Activities'),
        const SizedBox(height: AppSpacing.sm),
        const _ActivityTile(
          icon: Icons.request_quote_rounded,
          title: 'Quote requested for TMT Steel',
          subtitle: 'Supplier confirmation pending',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _ActivityTile(
          icon: Icons.check_circle_rounded,
          title: 'Cement order confirmed',
          subtitle: '100 bags scheduled for dispatch',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _ActivityTile(
          icon: Icons.local_shipping_rounded,
          title: 'Sand delivery scheduled',
          subtitle: 'Expected today evening',
        ),
      ],
    );
  }
}

class _MaterialCategoriesScreen extends StatelessWidget {
  const _MaterialCategoriesScreen({
    required this.categories,
    required this.selectedCategory,
    required this.products,
    required this.onCategorySelected,
    required this.onQuote,
    required this.onOrder,
  });

  final List<_MaterialCategory> categories;
  final String selectedCategory;
  final List<_MaterialProduct> products;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<_MaterialProduct> onQuote;
  final ValueChanged<_MaterialProduct> onOrder;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 560 ? 3 : 2;
            return GridView.builder(
              itemCount: categories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 1.02,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _MaterialCategoryCard(
                  category: category,
                  selected: category.name == selectedCategory,
                  onTap: () => onCategorySelected(category.name),
                );
              },
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionHeader(title: selectedCategory),
        const SizedBox(height: AppSpacing.sm),
        for (final product in products) ...[
          _MaterialCard(
            product: product,
            onQuote: () => onQuote(product),
            onOrder: () => onOrder(product),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _RequestQuoteScreen extends StatelessWidget {
  const _RequestQuoteScreen({
    required this.formKey,
    required this.categories,
    required this.products,
    required this.selectedCategory,
    required this.selectedProduct,
    required this.selectedUnit,
    required this.requiredDate,
    required this.quantityController,
    required this.locationController,
    required this.phoneController,
    required this.notesController,
    required this.onCategoryChanged,
    required this.onProductChanged,
    required this.onUnitChanged,
    required this.onDateChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final List<_MaterialCategory> categories;
  final List<_MaterialProduct> products;
  final String selectedCategory;
  final String selectedProduct;
  final String selectedUnit;
  final DateTime requiredDate;
  final TextEditingController quantityController;
  final TextEditingController locationController;
  final TextEditingController phoneController;
  final TextEditingController notesController;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onProductChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final categoryProducts = products
        .where((product) => product.category == selectedCategory)
        .toList();
    final selected = products.firstWhere((product) {
      return product.name == selectedProduct;
    });
    final quantity = double.tryParse(quantityController.text.trim()) ?? 0;
    final estimatedAmount = selected.rate == null
        ? null
        : selected.rate! * quantity;

    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
        ),
        children: [
          _DropdownField(
            label: 'Material Category',
            value: selectedCategory,
            values: categories.map((category) => category.name).toList(),
            onChanged: onCategoryChanged,
          ),
          _DropdownField(
            label: 'Material/Product',
            value: selectedProduct,
            values: categoryProducts.map((product) => product.name).toList(),
            onChanged: onProductChanged,
          ),
          _InputField(
            controller: quantityController,
            label: 'Quantity',
            keyboardType: TextInputType.number,
            validator: _positiveValidator,
          ),
          _DropdownField(
            label: 'Unit',
            value: selectedUnit,
            values: const [
              'Bag',
              'Ton',
              'CFT',
              'Cubic Meter',
              '1000 pcs',
              'pcs',
              'Tractor / Ton / CFT',
            ],
            onChanged: onUnitChanged,
          ),
          _InputField(
            controller: locationController,
            label: 'Delivery Location',
            validator: _requiredValidator,
          ),
          _DateField(date: requiredDate, onChanged: onDateChanged),
          _InputField(
            controller: phoneController,
            label: 'Contact Number',
            keyboardType: TextInputType.phone,
            validator: _phoneValidator,
          ),
          _InputField(
            controller: notesController,
            label: 'Notes',
            minLines: 3,
            maxLines: 4,
            required: false,
          ),
          _EstimatePanel(
            amount: estimatedAmount,
            quoteOnly: selected.rate == null,
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.send_rounded),
            label: const Text('Submit Request'),
          ),
        ],
      ),
    );
  }
}

class _OrdersScreen extends StatelessWidget {
  const _OrdersScreen({required this.orders});

  final List<_OrderEntry> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemBuilder: (context, index) => _OrderCard(order: orders[index]),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemCount: orders.length,
    );
  }
}

class _DeliveryTrackingScreen extends StatelessWidget {
  const _DeliveryTrackingScreen({required this.deliveries});

  final List<_DeliveryEntry> deliveries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemBuilder: (context, index) {
        return _DeliveryTrackingCard(delivery: deliveries[index]);
      },
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemCount: deliveries.length,
    );
  }
}

class ConstructionSummaryCard extends StatelessWidget {
  const ConstructionSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SoftIcon(icon: icon),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall(context),
          ),
          const SizedBox(height: AppSpacing.xxs),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(value, style: AppTextStyles.titleLarge(context)),
          ),
        ],
      ),
    );
  }
}

class ConstructionQuickActionCard extends StatelessWidget {
  const ConstructionQuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: _ConstructionPanel(
          child: Row(
            children: [
              _SoftIcon(icon: icon),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MaterialCategoryCard extends StatelessWidget {
  const _MaterialCategoryCard({
    required this.category,
    required this.onTap,
    this.selected = false,
  });

  final _MaterialCategory category;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _amber.withValues(alpha: 0.12) : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: _ConstructionPanel(
          borderColor: selected ? _amber : _constructionBorder,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SoftIcon(icon: category.icon),
              const SizedBox(height: AppSpacing.sm),
              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium(context),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                category.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  const _MaterialCard({
    required this.product,
    required this.onQuote,
    required this.onOrder,
  });

  final _MaterialProduct product;
  final VoidCallback onQuote;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Column(
        children: [
          Row(
            children: [
              _SoftIcon(icon: _categoryIcon(product.category)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium(context),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${product.category} - ${product.unit}'
                      '${product.grade == null ? '' : ' - ${product.grade}'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ConstructionStatusBadge(label: product.stock),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.priceText,
                  style: AppTextStyles.titleMedium(context).copyWith(
                    color: product.rate == null ? _blueGray : _amberDark,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: onQuote,
                child: const Text('Request Quote'),
              ),
              const SizedBox(width: AppSpacing.xs),
              FilledButton(onPressed: onOrder, child: const Text('Order Now')),
            ],
          ),
        ],
      ),
    );
  }
}

class ConstructionStatusBadge extends StatelessWidget {
  const ConstructionStatusBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = switch (label.toLowerCase()) {
      'pending' => AppColors.warning,
      'confirmed' || 'out for delivery' || 'loading' => _blueGray,
      'delivered' || 'available' => AppColors.success,
      'cancelled' => AppColors.error,
      _ => _amberDark,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall(
          context,
        ).copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DeliveryTrackingCard extends StatelessWidget {
  const _DeliveryTrackingCard({required this.delivery});

  final _DeliveryEntry delivery;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Column(
        children: [
          Row(
            children: [
              const _SoftIcon(icon: Icons.local_shipping_rounded),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery.material,
                      style: AppTextStyles.titleMedium(context),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${delivery.vehicle} - ${delivery.driver}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ),
              ),
              ConstructionStatusBadge(label: delivery.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  'ETA: ${delivery.eta}',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ),
              Text(
                '${(delivery.progress * 100).round()}%',
                style: AppTextStyles.titleMedium(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          LinearProgressIndicator(
            value: delivery.progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final _OrderEntry order;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.id,
                  style: AppTextStyles.titleMedium(context),
                ),
              ),
              ConstructionStatusBadge(label: order.status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(order.material, style: AppTextStyles.titleLarge(context)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${order.quantity} - ${order.amount}',
            style: AppTextStyles.bodyMedium(context),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${order.deliveryDate} - ${order.location}',
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Row(
        children: [
          _SoftIcon(icon: icon),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EstimatePanel extends StatelessWidget {
  const _EstimatePanel({required this.amount, required this.quoteOnly});

  final double? amount;
  final bool quoteOnly;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Row(
        children: [
          Icon(
            quoteOnly ? Icons.info_outline_rounded : Icons.payments_rounded,
            color: _amberDark,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              quoteOnly
                  ? 'Final price will be shared after supplier confirmation'
                  : 'Estimated amount: ${_money(amount ?? 0)}',
              style: AppTextStyles.titleMedium(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.minLines,
    this.maxLines,
    this.required = true,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(labelText: label),
        validator: validator ?? (required ? _requiredValidator : null),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final safeValue = values.contains(value) ? value : values.first;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: DropdownButtonFormField<String>(
        initialValue: safeValue,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final item in values)
            DropdownMenuItem(value: item, child: Text(item)),
        ],
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onChanged});

  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.large),
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            firstDate: now,
            lastDate: now.add(const Duration(days: 60)),
            initialDate: date,
          );
          if (picked != null) onChanged(picked);
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Required Date',
            prefixIcon: Icon(Icons.calendar_month_rounded),
          ),
          child: Text(_date(date)),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.titleLarge(context));
  }
}

class _ConstructionPanel extends StatelessWidget {
  const _ConstructionPanel({
    required this.child,
    this.borderColor = _constructionBorder,
  });

  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: _amberDark.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: _amber.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Icon(icon, color: _amberDark, size: 22),
    );
  }
}

class _MaterialCategory {
  const _MaterialCategory(this.name, this.subtitle, this.icon);

  final String name;
  final String subtitle;
  final IconData icon;
}

class _MaterialProduct {
  const _MaterialProduct(
    this.name,
    this.category,
    this.unit,
    this.stock,
    this.rate, {
    this.grade,
  });

  final String name;
  final String category;
  final String unit;
  final String stock;
  final double? rate;
  final String? grade;

  String get priceText =>
      rate == null ? 'Request Quote' : '${_money(rate!)} / $unit';
}

class _OrderEntry {
  const _OrderEntry(
    this.id,
    this.material,
    this.quantity,
    this.amount,
    this.status,
    this.deliveryDate,
    this.location,
  );

  final String id;
  final String material;
  final String quantity;
  final String amount;
  final String status;
  final String deliveryDate;
  final String location;
}

class _DeliveryEntry {
  const _DeliveryEntry(
    this.material,
    this.vehicle,
    this.driver,
    this.status,
    this.eta,
    this.progress,
  );

  final String material;
  final String vehicle;
  final String driver;
  final String status;
  final String eta;
  final double progress;
}

class _QuoteRequest {
  const _QuoteRequest(
    this.product,
    this.category,
    this.quantity,
    this.location,
    this.date,
  );

  final String product;
  final String category;
  final String quantity;
  final String location;
  final DateTime date;
}

const Color _amber = Color(0xFFF59E0B);
const Color _amberDark = Color(0xFFD97706);
const Color _blueGray = Color(0xFF475569);
const Color _constructionBorder = Color(0xFFF1E6D4);
const Color _constructionTint = Color(0xFFFFF3D8);

ThemeData _constructionTheme(BuildContext context) {
  final base = Theme.of(context);
  final colorScheme = base.colorScheme.copyWith(
    primary: _amber,
    onPrimary: AppColors.surface,
    primaryContainer: _amber,
    onPrimaryContainer: AppColors.surface,
    secondary: _blueGray,
    surface: AppColors.surface,
    surfaceContainerHighest: _constructionTint,
    outline: _constructionBorder,
  );

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _amber,
        foregroundColor: AppColors.surface,
        minimumSize: const Size(64, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        textStyle: AppTextStyles.labelLarge(context),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _amberDark,
        side: const BorderSide(color: _constructionBorder),
        minimumSize: const Size(64, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        textStyle: AppTextStyles.labelLarge(context),
      ),
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      fillColor: AppColors.surface,
      prefixIconColor: _amberDark,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: const BorderSide(color: _amber, width: 1.4),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: _amber,
      elevation: 6,
      shadowColor: AppColors.overlay,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return AppTextStyles.bodyMedium(context).copyWith(
          color: states.contains(WidgetState.selected)
              ? AppColors.textPrimary
              : AppColors.textSecondary,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.surface
              : AppColors.textSecondary,
        );
      }),
    ),
    progressIndicatorTheme: base.progressIndicatorTheme.copyWith(
      color: _amber,
      linearTrackColor: _constructionTint,
    ),
  );
}

IconData _categoryIcon(String category) {
  return switch (category) {
    'Cement' => Icons.foundation_rounded,
    'Steel' => Icons.construction_rounded,
    'Sand' => Icons.landscape_rounded,
    'Gitti / Aggregate' => Icons.grain_rounded,
    'Concrete' => Icons.factory_rounded,
    _ => Icons.warehouse_rounded,
  };
}

String? _requiredValidator(String? value) {
  return (value ?? '').trim().isEmpty ? 'Required' : null;
}

String? _positiveValidator(String? value) {
  final number = double.tryParse((value ?? '').trim()) ?? 0;
  return number <= 0 ? 'Enter a valid quantity' : null;
}

String? _phoneValidator(String? value) {
  final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
  return digits.length < 10 ? 'Enter a valid phone number' : null;
}

String _money(double value) {
  final amount = value.round().toString();
  if (amount.length <= 3) return 'Rs. $amount';
  final lastThree = amount.substring(amount.length - 3);
  var leading = amount.substring(0, amount.length - 3);
  final groups = <String>[];
  while (leading.length > 2) {
    groups.insert(0, leading.substring(leading.length - 2));
    leading = leading.substring(0, leading.length - 2);
  }
  if (leading.isNotEmpty) groups.insert(0, leading);
  return 'Rs. ${groups.join(',')},$lastThree';
}

String _date(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
