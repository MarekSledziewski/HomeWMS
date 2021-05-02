import 'package:hive/hive.dart';

part 'products.g.dart';

@HiveType(typeId: 2)
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
  String producer;
  @HiveField(5)
  double price;

  Product(this.name, this.quantity, this.barcode, this.category, this.producer,
      this.price,);
}
