/// Immutable pesticide or fertilizer stock item.
class AgricultureStockItem {
  const AgricultureStockItem({
    required this.id,
    required this.name,
    required this.quantityLabel,
    required this.status,
  });

  final String id;
  final String name;
  final String quantityLabel;
  final String status;
}
