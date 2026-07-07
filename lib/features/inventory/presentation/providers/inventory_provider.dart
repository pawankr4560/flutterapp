import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/inventory_repository.dart';
import '../../domain/entities/inventory_item.dart';

/// Provides and mutates inventory products for the Inventory Management module.
final inventoryProvider =
    NotifierProvider<InventoryNotifier, List<InventoryItem>>(
  InventoryNotifier.new,
);

/// Manages the in-memory product stock ledger.
class InventoryNotifier extends Notifier<List<InventoryItem>> {
  late final InventoryRepository _repository;

  @override
  List<InventoryItem> build() {
    _repository = ref.read(inventoryRepositoryProvider);
    return _repository.listItems();
  }

  void addItem(InventoryItem item) {
    _repository.addItem(item);
    state = _repository.listItems();
  }

  void updateStock(String itemId, int newStock) {
    _repository.updateStock(itemId, newStock);
    state = _repository.listItems();
  }
}
