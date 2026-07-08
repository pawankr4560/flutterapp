part of '../pages/inventory_directory_page.dart';

class _ConstructionDashboardData {
  const _ConstructionDashboardData({
    this.totalProducts = 0,
    this.pendingQuotes = 0,
    this.activeOrders = 0,
    this.deliveriesToday = 0,
    this.recentActivities = const [],
  });

  factory _ConstructionDashboardData.fromJson(Map<String, dynamic> json) {
    return _ConstructionDashboardData(
      totalProducts: _asInt(json['totalProducts']),
      pendingQuotes: _asInt(json['pendingQuotes']),
      activeOrders: _asInt(json['activeOrders']),
      deliveriesToday: _asInt(json['deliveriesToday']),
      recentActivities: _asList(json['recentActivities'])
          .whereType<Map<String, dynamic>>()
          .map(_ActivityEntry.fromJson)
          .where((activity) => activity.title.isNotEmpty)
          .toList(),
    );
  }

  final int totalProducts;
  final int pendingQuotes;
  final int activeOrders;
  final int deliveriesToday;
  final List<_ActivityEntry> recentActivities;
}

class _ActivityEntry {
  const _ActivityEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
  });

  factory _ActivityEntry.fromJson(Map<String, dynamic> json) {
    return _ActivityEntry(
      id: _asString(json['id']),
      type: _asString(json['type']),
      title: _asString(json['title']),
      subtitle: _asString(json['subtitle']),
    );
  }

  final String id;
  final String type;
  final String title;
  final String subtitle;
}

class _MaterialCategory {
  const _MaterialCategory(this.id, this.name, this.subtitle, this.icon);

  factory _MaterialCategory.fromJson(Map<String, dynamic> json) {
    final name = _asString(json['name']);
    return _MaterialCategory(
      _asString(json['id']),
      name,
      _asString(json['subtitle']),
      _categoryIcon(name),
    );
  }

  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
}

class _MaterialProduct {
  const _MaterialProduct(
    this.id,
    this.name,
    this.categoryId,
    this.category,
    this.unit,
    this.stock,
    this.rate, {
    this.grade,
  });

  factory _MaterialProduct.fromJson(Map<String, dynamic> json) {
    return _MaterialProduct(
      _asString(json['id']),
      _asString(json['name']),
      _asString(json['categoryId']),
      _asString(json['categoryName'], fallback: _asString(json['category'])),
      _asString(json['unit']),
      _asString(json['stockStatus'], fallback: _asString(json['stock'])),
      _asDouble(json['rate']),
      grade: _asNullableString(json['grade']),
    );
  }

  final String id;
  final String name;
  final String categoryId;
  final String category;
  final String unit;
  final String stock;
  final double? rate;
  final String? grade;

  String get priceText =>
      rate == null ? 'Request Quote' : '${_money(rate!)} / $unit';
}

class _OrderEntry {
  const _OrderEntry(
    this.id,
    this.material,
    this.quantity,
    this.amount,
    this.status,
    this.deliveryDate,
    this.location,
  );

  factory _OrderEntry.fromJson(Map<String, dynamic> json) {
    final quantity = _asString(json['quantity']);
    final unit = _asString(json['unit']);
    return _OrderEntry(
      _asString(json['id']),
      _asString(json['material'], fallback: _asString(json['productName'])),
      unit.isEmpty ? quantity : '$quantity $unit',
      _formatAmount(json['amount']),
      _asString(json['status']),
      _displayDate(_asString(json['deliveryDate'])),
      _asString(
        json['deliveryLocation'],
        fallback: _asString(json['location']),
      ),
    );
  }

  final String id;
  final String material;
  final String quantity;
  final String amount;
  final String status;
  final String deliveryDate;
  final String location;
}

class _DeliveryEntry {
  const _DeliveryEntry(
    this.id,
    this.material,
    this.vehicle,
    this.driver,
    this.status,
    this.eta,
    this.progress,
  );

  factory _DeliveryEntry.fromJson(Map<String, dynamic> json) {
    return _DeliveryEntry(
      _asString(json['id']),
      _asString(json['material'], fallback: _asString(json['productName'])),
      _asString(
        json['vehicleNumber'],
        fallback: _asString(json['vehicle']),
      ),
      _asString(json['driverName'], fallback: _asString(json['driver'])),
      _asString(json['status']),
      _asString(json['eta']),
      _asDouble(json['progress'])?.clamp(0, 1).toDouble() ?? 0,
    );
  }

  final String id;
  final String material;
  final String vehicle;
  final String driver;
  final String status;
  final String eta;
  final double progress;
}

class _QuoteRequest {
  const _QuoteRequest(
    this.product,
    this.category,
    this.quantity,
    this.location,
    this.date,
  );

  factory _QuoteRequest.fromJson(Map<String, dynamic> json) {
    final quantity = _asString(json['quantity']);
    final unit = _asString(json['unit']);
    return _QuoteRequest(
      _asString(json['productName'], fallback: _asString(json['product'])),
      _asString(json['categoryName'], fallback: _asString(json['category'])),
      unit.isEmpty ? quantity : '$quantity $unit',
      _asString(
        json['deliveryLocation'],
        fallback: _asString(json['location']),
      ),
      _parseDate(_asString(json['requiredDate'])) ?? DateTime.now(),
    );
  }

  final String product;
  final String category;
  final String quantity;
  final String location;
  final DateTime date;
}

String _asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return fallback;
}

String? _asNullableString(Object? value) {
  final string = _asString(value);
  return string.isEmpty ? null : string;
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

List<dynamic> _asList(Object? value) {
  return value is List<dynamic> ? value : const [];
}

String _formatAmount(Object? value) {
  final amount = _asDouble(value);
  if (amount != null) return _money(amount);
  return _asString(value);
}

DateTime? _parseDate(String value) {
  if (value.isEmpty) return null;
  return DateTime.tryParse(value);
}

String _displayDate(String value) {
  final date = _parseDate(value);
  return date == null ? value : _date(date);
}

