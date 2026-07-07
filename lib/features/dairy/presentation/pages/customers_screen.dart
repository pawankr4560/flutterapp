part of 'milk_directory_page.dart';

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
            AppSearchAndFilter(
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


