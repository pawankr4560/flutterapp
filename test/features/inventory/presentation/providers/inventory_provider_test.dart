import 'package:finhub/features/inventory/data/repositories/inventory_repository.dart';
import 'package:finhub/features/inventory/domain/entities/inventory_item.dart';
import 'package:finhub/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('in-memory repository adds items and updates stock', () {
    final repository = InMemoryInventoryRepository();
    const item = InventoryItem(
      id: 'item-test',
      name: 'Test item',
      category: 'Tools',
      currentStock: 3,
      lowStockThreshold: 1,
      costPrice: 10,
      sellingPrice: 12,
    );

    repository.addItem(item);
    repository.updateStock('item-test', 9);

    final saved = repository.listItems().singleWhere(
      (inventoryItem) => inventoryItem.id == 'item-test',
    );
    expect(saved.currentStock, 9);
    expect(saved.name, 'Test item');
  });

  test('notifier publishes repository-backed add and update changes', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(inventoryProvider.notifier);
    final initialCount = container.read(inventoryProvider).length;
    const item = InventoryItem(
      id: 'item-notifier-test',
      name: 'Notifier item',
      category: 'Electrical',
      currentStock: 4,
      lowStockThreshold: 2,
      costPrice: 20,
      sellingPrice: 25,
    );

    notifier.addItem(item);

    expect(container.read(inventoryProvider), hasLength(initialCount + 1));
    expect(container.read(inventoryProvider).last.id, 'item-notifier-test');

    notifier.updateStock('item-notifier-test', 11);

    final updated = container
        .read(inventoryProvider)
        .singleWhere(
          (inventoryItem) => inventoryItem.id == 'item-notifier-test',
        );
    expect(updated.currentStock, 11);
    expect(updated.lowStockThreshold, 2);
  });
}
