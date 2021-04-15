import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'products.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  String name;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  String barcode;
  @HiveField(3)
  String category;
  @HiveField(4)
  String producent;
  @HiveField(5)
  int price;

  Product(this.name, this.quantity, this.barcode, this.category, this.producent,
      this.price);
}
