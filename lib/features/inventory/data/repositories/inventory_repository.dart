import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/inventory_item.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InMemoryInventoryRepository();
});

abstract class InventoryRepository {
  List<InventoryItem> listItems();

  void addItem(InventoryItem item);

  void updateStock(String itemId, int newStock);
}

class InMemoryInventoryRepository implements InventoryRepository {
  List<InventoryItem> _items = const [
    InventoryItem(
      id: 'item-cement-50kg',
      name: 'Cement 50kg bag',
      category: 'Raw materials',
      currentStock: 80,
      lowStockThreshold: 20,
      costPrice: 390,
      sellingPrice: 420,
    ),
    InventoryItem(
      id: 'item-steel-rods-12mm',
      name: 'Steel rods 12mm',
      category: 'Raw materials',
      currentStock: 6,
      lowStockThreshold: 15,
      costPrice: 790,
      sellingPrice: 850,
    ),
    InventoryItem(
      id: 'item-pvc-pipe-fittings',
      name: 'PVC pipe fittings',
      category: 'Plumbing',
      currentStock: 0,
      lowStockThreshold: 25,
      costPrice: 45,
      sellingPrice: 60,
    ),
    InventoryItem(
      id: 'item-paint-20l',
      name: 'Paint 20L drum',
      category: 'Finishing',
      currentStock: 24,
      lowStockThreshold: 10,
      costPrice: 1900,
      sellingPrice: 2200,
    ),
    InventoryItem(
      id: 'item-sand-truck',
      name: 'River sand truck',
      category: 'Raw materials',
      currentStock: 12,
      lowStockThreshold: 8,
      costPrice: 5200,
      sellingPrice: 5800,
    ),
    InventoryItem(
      id: 'item-electric-wire',
      name: 'Electric wire bundle',
      category: 'Electrical',
      currentStock: 4,
      lowStockThreshold: 12,
      costPrice: 1100,
      sellingPrice: 1350,
    ),
  ];

  @override
  List<InventoryItem> listItems() => List.unmodifiable(_items);

  @override
  void addItem(InventoryItem item) {
    _items = [..._items, item];
  }

  @override
  void updateStock(String itemId, int newStock) {
    _items = [
      for (final item in _items)
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
