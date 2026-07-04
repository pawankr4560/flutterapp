import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/inventory_item.dart';

/// Provides and mutates inventory products for the Inventory Management module.
final inventoryProvider =
    NotifierProvider<InventoryNotifier, List<InventoryItem>>(
  InventoryNotifier.new,
);

/// Manages the in-memory product stock ledger.
class InventoryNotifier extends Notifier<List<InventoryItem>> {
  @override
  List<InventoryItem> build() {
    return const [
      InventoryItem(
        id: 'item-parle-g-biscuit',
        name: 'Parle-G Biscuit',
        category: 'Groceries',
        currentStock: 5,
        lowStockThreshold: 10,
        costPrice: 4.50,
        sellingPrice: 5,
      ),
      InventoryItem(
        id: 'item-fortune-mustard-oil',
        name: 'Fortune Mustard Oil',
        category: 'Oil & Ghee',
        currentStock: 2,
        lowStockThreshold: 5,
        costPrice: 128,
        sellingPrice: 145,
      ),
      InventoryItem(
        id: 'item-aashirvaad-atta-5kg',
        name: 'Aashirvaad Atta 5kg',
        category: 'Flour',
        currentStock: 25,
        lowStockThreshold: 8,
        costPrice: 195,
        sellingPrice: 225,
      ),
      InventoryItem(
        id: 'item-tata-salt-1kg',
        name: 'Tata Salt 1kg',
        category: 'Groceries',
        currentStock: 40,
        lowStockThreshold: 12,
        costPrice: 22,
        sellingPrice: 28,
      ),
    ];
  }

  void addItem(InventoryItem item) {
    state = [...state, item];
  }

  void updateStock(String itemId, int newStock) {
    state = [
      for (final item in state)
        if (item.id == itemId)
          InventoryItem(
            id: item.id,
            name: item.name,
            category: item.category,
            currentStock: newStock,
            lowStockThreshold: item.lowStockThreshold,
            costPrice: item.costPrice,
            sellingPrice: item.sellingPrice,
          )
        else
          item,
    ];
  }
}
