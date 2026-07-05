import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';

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
        backgroundColor: _dairyBackground,
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
                  'Manage your dairy business',
                  style: AppTextStyles.bodySmall(context),
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

class _DairyHomeView extends StatelessWidget {
  const _DairyHomeView({
    required this.products,
    required this.onOpenCollection,
    required this.onOpenSales,
    required this.onOpenCustomers,
    required this.onOpenProducts,
  });

  final List<_ProductEntry> products;
  final VoidCallback onOpenCollection;
  final VoidCallback onOpenSales;
  final VoidCallback onOpenCustomers;
  final VoidCallback onOpenProducts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 520 ? 4 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.42,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _DairySummaryCard(
                  title: 'Today Collection',
                  value: '120 L',
                  icon: Icons.water_drop_rounded,
                ),
                _DairySummaryCard(
                  title: 'Today Sales',
                  value: 'Rs. 8,500',
                  icon: Icons.payments_rounded,
                ),
                _DairySummaryCard(
                  title: 'Pending Payment',
                  value: 'Rs. 12,000',
                  icon: Icons.pending_actions_rounded,
                ),
                _DairySummaryCard(
                  title: 'Products',
                  value: '15',
                  icon: Icons.inventory_2_rounded,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const _DairySectionHeader(title: 'Quick Actions'),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 520 ? 4 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _DairyQuickActionCard(
                  title: 'Add Collection',
                  icon: Icons.add_rounded,
                  onTap: onOpenCollection,
                ),
                _DairyQuickActionCard(
                  title: 'New Sale',
                  icon: Icons.receipt_long_rounded,
                  onTap: onOpenSales,
                ),
                _DairyQuickActionCard(
                  title: 'Add Customer',
                  icon: Icons.person_add_alt_1_rounded,
                  onTap: onOpenCustomers,
                ),
                _DairyQuickActionCard(
                  title: 'Add Product',
                  icon: Icons.add_business_rounded,
                  onTap: onOpenProducts,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const _DairySectionHeader(title: 'Products'),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 126,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) =>
                _DairyProductMiniCard(product: products[index]),
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemCount: products.length,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const _DairySectionHeader(title: 'Recent Activities'),
        const SizedBox(height: AppSpacing.sm),
        const _DairyActivityTile(
          icon: Icons.water_drop_rounded,
          title: 'Milk collected',
          subtitle: 'Rahul Sharma - 20 L',
          time: '5 mins ago',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _DairyActivityTile(
          icon: Icons.point_of_sale_rounded,
          title: 'Sale completed',
          subtitle: 'Paneer - Rs. 500',
          time: '20 mins ago',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _DairyActivityTile(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Payment received',
          subtitle: 'Amit Kumar - Rs. 1,000',
          time: '1 hour ago',
        ),
      ],
    );
  }
}

class _CollectionView extends StatelessWidget {
  const _CollectionView({
    required this.entries,
    required this.onSearch,
    required this.onAdd,
  });

  final List<_CollectionEntry> entries;
  final ValueChanged<String> onSearch;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Collection'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          96,
        ),
        children: [
          const Row(
            children: [
              Expanded(
                child: _DairySummaryCard(
                  title: 'Today Collection',
                  value: '120 L',
                  icon: Icons.water_drop_rounded,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DairySummaryCard(
                  title: 'Total Amount',
                  value: 'Rs. 6,400',
                  icon: Icons.payments_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SearchAndFilter(
            hint: 'Search farmer or milk type',
            onChanged: onSearch,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final entry in entries) ...[
            _CollectionCard(entry: entry),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _SalesView extends StatelessWidget {
  const _SalesView({
    required this.sales,
    required this.onSearch,
    required this.onAdd,
  });

  final List<_SaleEntry> sales;
  final ValueChanged<String> onSearch;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Sale'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          96,
        ),
        children: [
          const Row(
            children: [
              Expanded(
                child: _DairySummaryCard(
                  title: 'Today Sales',
                  value: 'Rs. 8,500',
                  icon: Icons.payments_rounded,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DairySummaryCard(
                  title: 'Orders',
                  value: '24',
                  icon: Icons.shopping_bag_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SearchAndFilter(
            hint: 'Search customer or product',
            onChanged: onSearch,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final sale in sales) ...[
            _SaleCard(sale: sale),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _PaymentsView extends StatelessWidget {
  const _PaymentsView({required this.payments});

  final List<_PaymentEntry> payments;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const Row(
          children: [
            Expanded(
              child: _DairySummaryCard(
                title: 'Received',
                value: 'Rs. 15,500',
                icon: Icons.check_circle_rounded,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _DairySummaryCard(
                title: 'Pending',
                value: 'Rs. 12,000',
                icon: Icons.pending_actions_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final payment in payments) ...[
          _PaymentCard(payment: payment),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView({required this.period, required this.onPeriodChanged});

  final String period;
  final ValueChanged<String> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final reports = const [
      ('Daily Collection', '120 L', 0.82, Icons.water_drop_rounded),
      ('Sales Report', 'Rs. 8,500', 0.74, Icons.point_of_sale_rounded),
      ('Pending Payments', 'Rs. 12,000', 0.52, Icons.pending_actions_rounded),
      ('Product Stock', '131 units', 0.68, Icons.inventory_2_rounded),
      ('Profit Summary', 'Rs. 3,200', 0.61, Icons.trending_up_rounded),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'Today', label: Text('Today')),
            ButtonSegment(value: 'Week', label: Text('Week')),
            ButtonSegment(value: 'Month', label: Text('Month')),
          ],
          selected: {period},
          onSelectionChanged: (value) => onPeriodChanged(value.first),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final report in reports) ...[
          _ReportCard(
            title: report.$1,
            value: report.$2,
            progress: report.$3,
            icon: report.$4,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _CustomersScreen extends StatefulWidget {
  const _CustomersScreen({required this.customers, required this.onAdd});

  final List<_CustomerEntry> customers;
  final Future<void> Function() onAdd;

  @override
  State<_CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<_CustomersScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final customers = widget.customers.where((customer) {
      final query = _query.trim().toLowerCase();
      if (query.isEmpty) return true;
      return customer.name.toLowerCase().contains(query) ||
          customer.phone.contains(query) ||
          customer.type.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await widget.onAdd();
          if (mounted) setState(() {});
        },
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add Customer'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            96,
          ),
          children: [
            _SearchAndFilter(
              hint: 'Search customers',
              onChanged: (value) => setState(() => _query = value),
              showFilter: false,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final customer in customers) ...[
              _CustomerCard(customer: customer),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProductsScreen extends StatefulWidget {
  const _ProductsScreen({required this.products, required this.onAdd});

  final List<_ProductEntry> products;
  final Future<void> Function() onAdd;

  @override
  State<_ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<_ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await widget.onAdd();
          if (mounted) setState(() {});
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Product'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 520 ? 3 : 2;
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                96,
              ),
              itemCount: widget.products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 0.92,
              ),
              itemBuilder: (context, index) {
                return _ProductGridCard(product: widget.products[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _CollectionFormSheet extends StatefulWidget {
  const _CollectionFormSheet();

  @override
  State<_CollectionFormSheet> createState() => _CollectionFormSheetState();
}

class _CollectionFormSheetState extends State<_CollectionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _farmer = TextEditingController();
  final _quantity = TextEditingController(text: '20');
  final _fat = TextEditingController(text: '4.5');
  final _rate = TextEditingController(text: '42');
  String _milkType = 'Cow';
  DateTime _date = DateTime.now();

  double get _total => (_number(_quantity.text) * _number(_rate.text));

  @override
  void initState() {
    super.initState();
    _quantity.addListener(() => setState(() {}));
    _rate.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _farmer.dispose();
    _quantity.dispose();
    _fat.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormShell(
      title: 'Add Collection',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _Input(controller: _farmer, label: 'Farmer Name'),
            _Dropdown(
              label: 'Milk Type',
              value: _milkType,
              values: const ['Cow', 'Buffalo'],
              onChanged: (value) => setState(() => _milkType = value),
            ),
            _Input(
              controller: _quantity,
              label: 'Quantity in liters',
              keyboardType: TextInputType.number,
            ),
            _Input(
              controller: _fat,
              label: 'Fat %',
              keyboardType: TextInputType.number,
            ),
            _Input(
              controller: _rate,
              label: 'Rate per liter',
              keyboardType: TextInputType.number,
            ),
            _DatePickerTile(
              date: _date,
              onPicked: (date) {
                setState(() => _date = date);
              },
            ),
            _TotalBanner(label: 'Total Amount', amount: _total),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: _submit,
              child: const Text('Save Collection'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _CollectionEntry(
        _farmer.text.trim(),
        _milkType,
        _number(_quantity.text),
        _number(_fat.text),
        _number(_rate.text),
        _date,
      ),
    );
  }
}

class _SaleFormSheet extends StatefulWidget {
  const _SaleFormSheet();

  @override
  State<_SaleFormSheet> createState() => _SaleFormSheetState();
}

class _SaleFormSheetState extends State<_SaleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _customer = TextEditingController();
  final _quantity = TextEditingController(text: '10');
  final _rate = TextEditingController(text: '60');
  String _product = 'Milk';
  String _status = 'Paid';
  DateTime _date = DateTime.now();

  double get _total => _number(_quantity.text) * _number(_rate.text);

  @override
  void initState() {
    super.initState();
    _quantity.addListener(() => setState(() {}));
    _rate.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _customer.dispose();
    _quantity.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormShell(
      title: 'New Sale',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _Input(controller: _customer, label: 'Customer'),
            _Dropdown(
              label: 'Product',
              value: _product,
              values: const ['Milk', 'Paneer', 'Ghee', 'Curd', 'Butter'],
              onChanged: (value) => setState(() => _product = value),
            ),
            _Input(
              controller: _quantity,
              label: 'Quantity',
              keyboardType: TextInputType.number,
            ),
            _Input(
              controller: _rate,
              label: 'Rate',
              keyboardType: TextInputType.number,
            ),
            _Dropdown(
              label: 'Payment Status',
              value: _status,
              values: const ['Paid', 'Pending'],
              onChanged: (value) => setState(() => _status = value),
            ),
            _DatePickerTile(
              date: _date,
              onPicked: (date) {
                setState(() => _date = date);
              },
            ),
            _TotalBanner(label: 'Total Amount', amount: _total),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: _submit, child: const Text('Save Sale')),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _SaleEntry(
        _customer.text.trim(),
        _product,
        _number(_quantity.text),
        _number(_rate.text),
        _status,
        _date,
      ),
    );
  }
}

class _CustomerFormSheet extends StatefulWidget {
  const _CustomerFormSheet();

  @override
  State<_CustomerFormSheet> createState() => _CustomerFormSheetState();
}

class _CustomerFormSheetState extends State<_CustomerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _balance = TextEditingController(text: '0');
  String _type = 'Farmer';

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _balance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormShell(
      title: 'Add Customer',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _Input(controller: _name, label: 'Full Name'),
            _Input(
              controller: _phone,
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
            _Dropdown(
              label: 'Customer Type',
              value: _type,
              values: const [
                'Farmer',
                'Customer',
                'Shop',
                'Distributor',
                'Business',
              ],
              onChanged: (value) => setState(() => _type = value),
            ),
            _Input(controller: _address, label: 'Address'),
            _Input(
              controller: _balance,
              label: 'Opening Balance',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: _submit,
              child: const Text('Save Customer'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _CustomerEntry(
        _name.text.trim(),
        _phone.text.trim(),
        _type,
        _number(_balance.text),
        _address.text.trim(),
      ),
    );
  }
}

class _ProductFormSheet extends StatefulWidget {
  const _ProductFormSheet();

  @override
  State<_ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<_ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _stock = TextEditingController(text: '10');
  final _purchase = TextEditingController(text: '40');
  final _selling = TextEditingController(text: '60');
  String _unit = 'L';

  @override
  void dispose() {
    _name.dispose();
    _stock.dispose();
    _purchase.dispose();
    _selling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormShell(
      title: 'Add Product',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _Input(controller: _name, label: 'Product Name'),
            _Dropdown(
              label: 'Unit',
              value: _unit,
              values: const ['L', 'kg', 'pcs'],
              onChanged: (value) => setState(() => _unit = value),
            ),
            _Input(
              controller: _stock,
              label: 'Current Stock',
              keyboardType: TextInputType.number,
            ),
            _Input(
              controller: _purchase,
              label: 'Purchase Price',
              keyboardType: TextInputType.number,
            ),
            _Input(
              controller: _selling,
              label: 'Selling Price',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: _submit, child: const Text('Save Product')),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _ProductEntry(
        _name.text.trim(),
        _unit,
        _number(_stock.text),
        _number(_purchase.text),
        _number(_selling.text),
      ),
    );
  }
}

class _DairySummaryCard extends StatelessWidget {
  const _DairySummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
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

class _DairyQuickActionCard extends StatelessWidget {
  const _DairyQuickActionCard({
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
        child: _DairyPanel(
          padding: const EdgeInsets.all(AppSpacing.md),
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

class _DairyProductMiniCard extends StatelessWidget {
  const _DairyProductMiniCard({required this.product});

  final _ProductEntry product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136,
      child: _DairyPanel(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SoftIcon(icon: _productIcon(product.name)),
            const Spacer(),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleMedium(context),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Stock: ${product.stockText}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({required this.entry});

  final _CollectionEntry entry;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Column(
        children: [
          Row(
            children: [
              const _SoftIcon(icon: Icons.water_drop_rounded),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.farmer,
                      style: AppTextStyles.titleMedium(context),
                    ),
                    Text(
                      '${entry.milkType} milk - ${entry.quantityText}',
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ),
              ),
              Text(entry.amountText, style: AppTextStyles.titleMedium(context)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _DetailPill('Fat', '${entry.fat.toStringAsFixed(1)}%'),
              const SizedBox(width: AppSpacing.xs),
              _DetailPill('Rate', '${entry.rateText}/L'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SaleCard extends StatelessWidget {
  const _SaleCard({required this.sale});

  final _SaleEntry sale;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Row(
        children: [
          const _SoftIcon(icon: Icons.receipt_long_rounded),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sale.customer, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${sale.product} - ${sale.quantityText}',
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _DairyStatusBadge(label: sale.status),
              const SizedBox(height: AppSpacing.xs),
              Text(sale.amountText, style: AppTextStyles.titleMedium(context)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer});

  final _CustomerEntry customer;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _teal.withValues(alpha: 0.12),
            foregroundColor: _teal,
            child: Text(customer.name.characters.first),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(customer.phone, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _DairyStatusBadge(label: customer.type),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _money(customer.balance),
                style: AppTextStyles.bodySmall(context),
              ),
            ],
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({required this.product});

  final _ProductEntry product;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SoftIcon(icon: _productIcon(product.name)),
              const Spacer(),
              if (product.stock <= 8) const _LowStockBadge(),
            ],
          ),
          const Spacer(),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium(context),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Stock: ${product.stockText}',
            style: AppTextStyles.bodySmall(context),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Price: ${_money(product.sellingPrice)}/${product.unit}',
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final _PaymentEntry payment;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Row(
        children: [
          const _SoftIcon(icon: Icons.account_balance_wallet_rounded),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.party, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${payment.mode} - ${_formatShortDate(payment.date)}',
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _money(payment.amount),
                style: AppTextStyles.titleMedium(context),
              ),
              const SizedBox(height: AppSpacing.xs),
              _DairyStatusBadge(label: payment.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.value,
    required this.progress,
    required this.icon,
  });

  final String title;
  final String value;
  final double progress;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Column(
        children: [
          Row(
            children: [
              _SoftIcon(icon: icon),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(title, style: AppTextStyles.titleMedium(context)),
              ),
              Text(value, style: AppTextStyles.titleMedium(context)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            backgroundColor: _teal.withValues(alpha: 0.1),
            color: _teal,
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter({
    required this.hint,
    required this.onChanged,
    this.showFilter = true,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final bool showFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
        ),
        if (showFilter) ...[
          const SizedBox(width: AppSpacing.sm),
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ],
    );
  }
}

class _FormShell extends StatelessWidget {
  const _FormShell({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.88,
        minChildSize: 0.5,
        maxChildSize: 0.96,
        builder: (context, controller) {
          return ListView(
            controller: controller,
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(title, style: AppTextStyles.titleLarge(context)),
              const SizedBox(height: AppSpacing.md),
              child,
            ],
          );
        },
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if ((value ?? '').trim().isEmpty) return 'Required';
          if (keyboardType == TextInputType.number && _number(value!) <= 0) {
            return 'Enter a valid value';
          }
          return null;
        },
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: DropdownButtonFormField<String>(
        initialValue: value,
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

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({required this.date, required this.onPicked});

  final DateTime date;
  final ValueChanged<DateTime> onPicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.large),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now().add(const Duration(days: 30)),
            initialDate: date,
          );
          if (picked != null) onPicked(picked);
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Date',
            prefixIcon: Icon(Icons.calendar_today_rounded),
          ),
          child: Text(_formatShortDate(date)),
        ),
      ),
    );
  }
}

class _DairyPanel extends StatelessWidget {
  const _DairyPanel({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: const Color(0xFFE2F2EF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.07),
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
        color: _teal.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Icon(icon, color: _teal, size: 22),
    );
  }
}

class _DairyActivityTile extends StatelessWidget {
  const _DairyActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Row(
        children: [
          _SoftIcon(icon: icon),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium(context)),
                Text(subtitle, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
          Text(time, style: AppTextStyles.bodySmall(context)),
        ],
      ),
    );
  }
}

class _DairySectionHeader extends StatelessWidget {
  const _DairySectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.titleLarge(context));
  }
}

class _DairyStatusBadge extends StatelessWidget {
  const _DairyStatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final lower = label.toLowerCase();
    final color = lower == 'paid' || lower == 'received'
        ? AppColors.success
        : lower == 'pending'
        ? AppColors.warning
        : _teal;

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

class _DetailPill extends StatelessWidget {
  const _DetailPill(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFEFFAF7),
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Text(
          '$label: $value',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall(
            context,
          ).copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _TotalBanner extends StatelessWidget {
  const _TotalBanner({required this.label, required this.amount});

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.titleMedium(context)),
          ),
          Text(
            _money(amount),
            style: AppTextStyles.titleLarge(context).copyWith(color: _teal),
          ),
        ],
      ),
    );
  }
}

class _LowStockBadge extends StatelessWidget {
  const _LowStockBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        'Low',
        style: AppTextStyles.bodySmall(
          context,
        ).copyWith(color: AppColors.warning, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _CollectionEntry {
  const _CollectionEntry(
    this.farmer,
    this.milkType,
    this.quantity,
    this.fat,
    this.rate,
    this.date,
  );

  final String farmer;
  final String milkType;
  final double quantity;
  final double fat;
  final double rate;
  final DateTime date;

  double get amount => quantity * rate;
  String get quantityText => '${_trim(quantity)} L';
  String get rateText => _money(rate);
  String get amountText => _money(amount);
}

class _SaleEntry {
  const _SaleEntry(
    this.customer,
    this.product,
    this.quantity,
    this.rate,
    this.status,
    this.date,
  );

  final String customer;
  final String product;
  final double quantity;
  final double rate;
  final String status;
  final DateTime date;

  double get amount => quantity * rate;
  String get quantityText =>
      '${_trim(quantity)} ${product == 'Milk' ? 'L' : 'kg'}';
  String get amountText => _money(amount);
}

class _CustomerEntry {
  const _CustomerEntry(
    this.name,
    this.phone,
    this.type,
    this.balance,
    this.address,
  );

  final String name;
  final String phone;
  final String type;
  final double balance;
  final String address;
}

class _ProductEntry {
  const _ProductEntry(
    this.name,
    this.unit,
    this.stock,
    this.purchasePrice,
    this.sellingPrice,
  );

  final String name;
  final String unit;
  final double stock;
  final double purchasePrice;
  final double sellingPrice;

  String get stockText => '${_trim(stock)} $unit';
}

class _PaymentEntry {
  const _PaymentEntry(
    this.party,
    this.amount,
    this.mode,
    this.status,
    this.date,
  );

  final String party;
  final double amount;
  final String mode;
  final String status;
  final DateTime date;
}

const Color _teal = Color(0xFF14B8D0);
const Color _tealDark = Color(0xFF0891B2);
const Color _dairyBackground = Color(0xFFF7FCFB);
const Color _dairyTint = Color(0xFFE7F8FB);

ThemeData _dairyTheme(BuildContext context) {
  final base = Theme.of(context);
  final colorScheme = base.colorScheme.copyWith(
    primary: _teal,
    onPrimary: AppColors.surface,
    primaryContainer: _teal,
    onPrimaryContainer: AppColors.surface,
    secondary: _tealDark,
    surface: AppColors.surface,
    surfaceContainerHighest: _dairyTint,
    outline: const Color(0xFFD7EEF2),
  );

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: _dairyBackground,
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: _dairyBackground,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
      backgroundColor: _teal,
      foregroundColor: AppColors.surface,
      extendedTextStyle: AppTextStyles.labelLarge(
        context,
      ).copyWith(color: AppColors.surface),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _teal,
        foregroundColor: AppColors.surface,
        disabledBackgroundColor: AppColors.border,
        disabledForegroundColor: AppColors.textSecondary,
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        textStyle: AppTextStyles.labelLarge(context),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColors.textPrimary),
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      fillColor: AppColors.surface,
      prefixIconColor: _teal,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: const BorderSide(color: _teal, width: 1.4),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? _teal
              : AppColors.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.surface
              : AppColors.textPrimary;
        }),
        iconColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.surface
              : AppColors.textSecondary;
        }),
        side: WidgetStateProperty.all(
          const BorderSide(color: Color(0xFFD7EEF2)),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: _teal,
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
      color: _teal,
      linearTrackColor: _dairyTint,
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
    ),
  );
}

double _number(String value) => double.tryParse(value.trim()) ?? 0;

String _money(double value) => 'Rs. ${value.toStringAsFixed(0)}';

String _trim(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}

String _formatShortDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

IconData _productIcon(String product) {
  return switch (product.toLowerCase()) {
    'paneer' => Icons.inventory_2_rounded,
    'ghee' => Icons.opacity_rounded,
    'curd' => Icons.icecream_rounded,
    'butter' => Icons.breakfast_dining_rounded,
    _ => Icons.local_drink_rounded,
  };
}
