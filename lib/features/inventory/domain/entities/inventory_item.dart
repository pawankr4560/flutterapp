/// Immutable inventory product tracked by the Inventory Management module.
class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.currentStock,
    required this.lowStockThreshold,
    required this.costPrice,
    required this.sellingPrice,
  });

  final String id;
  final String name;
  final String category;
  final int currentStock;
  final int lowStockThreshold;
  final double costPrice;
  final double sellingPrice;

  bool get isLowStock => currentStock <= lowStockThreshold;
}
