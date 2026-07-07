part of '../pages/inventory_directory_page.dart';

class _MaterialCategory {
  const _MaterialCategory(this.name, this.subtitle, this.icon);

  final String name;
  final String subtitle;
  final IconData icon;
}

class _MaterialProduct {
  const _MaterialProduct(
    this.name,
    this.category,
    this.unit,
    this.stock,
    this.rate, {
    this.grade,
  });

  final String name;
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
    this.material,
    this.vehicle,
    this.driver,
    this.status,
    this.eta,
    this.progress,
  );

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

  final String product;
  final String category;
  final String quantity;
  final String location;
  final DateTime date;
}

