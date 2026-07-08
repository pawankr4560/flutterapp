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

  factory AgricultureStockItem.fromJson(Map<String, dynamic> json) {
    final quantity = _asDouble(json['quantity']);
    final unit = _asString(json['unit']);
    return AgricultureStockItem(
      id: _asString(json['id']),
      name: _asString(json['name']),
      quantityLabel: _asString(
        json['quantityLabel'],
        fallback: quantity == null || unit.isEmpty
            ? ''
            : '${_trim(quantity)} $unit in stock',
      ),
      status: _asString(json['status'], fallback: 'Sufficient'),
    );
  }
}

String _asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return fallback;
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

String _trim(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}
