import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/inventory_repository.dart';
import '../../domain/entities/inventory_item.dart';

/// Provides and mutates inventory products for the Inventory Management module.
final inventoryProvider =
    AsyncNotifierProvider<InventoryNotifier, List<InventoryItem>>(
  InventoryNotifier.new,
);

/// Manages the product stock ledger.
class InventoryNotifier extends AsyncNotifier<List<InventoryItem>> {
  late final InventoryRepository _repository;

  @override
  Future<List<InventoryItem>> build() {
    _repository = ref.read(inventoryRepositoryProvider);
    return _repository.listItems();
  }

  Future<void> addItem(InventoryItem item) async {
    await _repository.addItem(item);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.listItems);
  }

  Future<void> updateStock(String itemId, int newStock) async {
    await _repository.updateStock(itemId, newStock);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.listItems);
  }
}
