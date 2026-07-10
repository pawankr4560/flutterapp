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
      id: _asString(json['activityId'], fallback: _asString(json['id'])),
      type: _asString(json['type']),
      title: _asString(json['title']),
      subtitle: _asString(
        json['description'],
        fallback: _asString(
          json['subtitle'],
          fallback: _displayDate(_asString(json['createdAt'])),
        ),
      ),
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
      _asString(json['id'], fallback: _asString(json['categoryIndex'])),
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

class _ConstructionUnit {
  const _ConstructionUnit({
    required this.id,
    required this.code,
    required this.name,
  });

  factory _ConstructionUnit.fromJson(Map<String, dynamic> json) {
    return _ConstructionUnit(
      id: _asString(json['id'], fallback: _asString(json['unitId'])),
      code: _asString(json['code']),
      name: _asString(json['name'], fallback: _asString(json['unitName'])),
    );
  }

  final String id;
  final String code;
  final String name;

  bool matches(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized.isNotEmpty &&
        (name.toLowerCase() == normalized || code.toLowerCase() == normalized);
  }
}

class _MaterialProduct {
  const _MaterialProduct(
    this.id,
    this.name,
    this.categoryId,
    this.category,
    this.unitId,
    this.unit,
    this.stock,
    this.rate, {
    this.grade,
  });

  factory _MaterialProduct.fromJson(Map<String, dynamic> json) {
    final category = _asMap(json['category']);
    final unit = _asMap(json['unit']);
    return _MaterialProduct(
      _asString(json['id'], fallback: _asString(json['productId'])),
      _asString(json['name']),
      _asString(
        json['categoryId'],
        fallback: _asString(
          json['categoryIndex'],
          fallback: _asString(category['id']),
        ),
      ),
      _asString(
        json['categoryName'],
        fallback: _asString(
          json['category'],
          fallback: _asString(category['name']),
        ),
      ),
      _asString(
        json['unitId'],
        fallback: _asString(
          json['unitIndex'],
          fallback: _asString(
            json['unitID'],
            fallback: _asString(
              unit['id'],
              fallback: _asString(unit['unitIndex']),
            ),
          ),
        ),
      ),
      _asString(
        json['unit'],
        fallback: _asString(
          json['unitName'],
          fallback: _asString(unit['name']),
        ),
      ),
      _asString(json['stockStatus'], fallback: _asString(json['stock'])),
      _asDouble(
        json['rate'],
        fallback: _asDouble(
          json['price'],
          fallback: _asDouble(json['unitPrice']),
        ),
      ),
      grade: _asNullableString(json['grade']),
    );
  }

  _MaterialProduct withCategoryName(String categoryName) {
    if (categoryName.isEmpty || category == categoryName) {
      return this;
    }

    return _MaterialProduct(
      id,
      name,
      categoryId,
      categoryName,
      unitId,
      unit,
      stock,
      rate,
      grade: grade,
    );
  }

  final String id;
  final String name;
  final String categoryId;
  final String category;
  final String unitId;
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
    final unit = _asString(
      json['unitName'],
      fallback: _asString(json['unit']),
    );
    return _OrderEntry(
      _asString(json['orderId'], fallback: _asString(json['id'])),
      _asString(json['material'], fallback: _asString(json['productName'])),
      unit.isEmpty ? quantity : '$quantity $unit',
      _formatAmount(json['totalAmount'] ?? json['amount']),
      _asString(json['status'], fallback: 'Placed'),
      _displayDate(
        _asString(
          json['deliveryDate'],
          fallback: _asString(json['requiredDate']),
        ),
      ),
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
  const _QuoteRequest({
    required this.id,
    required this.product,
    required this.category,
    required this.quantity,
    required this.location,
    required this.date,
    required this.status,
    required this.estimatedAmount,
    required this.finalQuotedAmount,
  });

  factory _QuoteRequest.fromJson(Map<String, dynamic> json) {
    final quantity = _asString(json['quantity']);
    final unit = _asString(
      json['unitName'],
      fallback: _asString(json['unit']),
    );
    return _QuoteRequest(
      id: _asString(json['quoteId'], fallback: _asString(json['id'])),
      product: _asString(
        json['productName'],
        fallback: _asString(json['product']),
      ),
      category: _asString(
        json['categoryName'],
        fallback: _asString(json['category']),
      ),
      quantity: unit.isEmpty ? quantity : '$quantity $unit',
      location: _asString(
        json['deliveryLocation'],
        fallback: _asString(json['location']),
      ),
      date: _parseDate(_asString(json['requiredDate'])) ?? DateTime.now(),
      status: _asString(json['status'], fallback: 'Pending'),
      estimatedAmount: _asDouble(json['estimatedAmount']) ?? 0,
      finalQuotedAmount: _asDouble(json['finalQuotedAmount']) ?? 0,
    );
  }

  final String id;
  final String product;
  final String category;
  final String quantity;
  final String location;
  final DateTime date;
  final String status;
  final double estimatedAmount;
  final double finalQuotedAmount;
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

double? _asDouble(Object? value, {double? fallback}) {
  if (value == null) return fallback;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

List<dynamic> _asList(Object? value) {
  return value is List<dynamic> ? value : const [];
}

Map<String, dynamic> _asMap(Object? value) {
  return value is Map<String, dynamic> ? value : const {};
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
