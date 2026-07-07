part of '../pages/milk_directory_page.dart';

class _CollectionEntry {
  const _CollectionEntry(
    this.farmer,
    this.milkType,
    this.quantity,
    this.fat,
    this.rate,
    this.date,
  );

  final String farmer;
  final String milkType;
  final double quantity;
  final double fat;
  final double rate;
  final DateTime date;

  double get amount => quantity * rate;
  String get quantityText => '${_trim(quantity)} L';
  String get rateText => _money(rate);
  String get amountText => _money(amount);
}

class _SaleEntry {
  const _SaleEntry(
    this.customer,
    this.product,
    this.quantity,
    this.rate,
    this.status,
    this.date,
  );

  final String customer;
  final String product;
  final double quantity;
  final double rate;
  final String status;
  final DateTime date;

  double get amount => quantity * rate;
  String get quantityText =>
      '${_trim(quantity)} ${product == 'Milk' ? 'L' : 'kg'}';
  String get amountText => _money(amount);
}

class _CustomerEntry {
  const _CustomerEntry(
    this.name,
    this.phone,
    this.type,
    this.balance,
    this.address,
  );

  final String name;
  final String phone;
  final String type;
  final double balance;
  final String address;
}

class _ProductEntry {
  const _ProductEntry(
    this.name,
    this.unit,
    this.stock,
    this.purchasePrice,
    this.sellingPrice,
  );

  final String name;
  final String unit;
  final double stock;
  final double purchasePrice;
  final double sellingPrice;

  String get stockText => '${_trim(stock)} $unit';
}

class _PaymentEntry {
  const _PaymentEntry(
    this.party,
    this.amount,
    this.mode,
    this.status,
    this.date,
  );

  final String party;
  final double amount;
  final String mode;
  final String status;
  final DateTime date;
}

