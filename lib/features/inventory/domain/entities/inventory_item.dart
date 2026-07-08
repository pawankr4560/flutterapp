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

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    final stock = _asInt(
      json['currentStock'] ?? json['stock'] ?? json['quantity'],
    );
    return InventoryItem(
      id: _asString(json['id']),
      name: _asString(json['name']),
      category: _asString(
        json['category'],
        fallback: _asString(json['categoryName']),
      ),
      currentStock: stock,
      lowStockThreshold: _asInt(json['lowStockThreshold']),
      costPrice: _asDouble(json['costPrice'] ?? json['purchasePrice']),
      sellingPrice: _asDouble(json['sellingPrice'] ?? json['rate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'currentStock': currentStock,
      'lowStockThreshold': lowStockThreshold,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
    };
  }

  bool get isLowStock => currentStock <= lowStockThreshold;

  bool get isOutOfStock => currentStock == 0;

  String get stockStatus {
    if (isOutOfStock) {
      return 'Out of stock';
    }
    if (isLowStock) {
      return 'Low stock';
    }
    return 'In stock';
  }
}

String _asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return fallback;
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _asDouble(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
