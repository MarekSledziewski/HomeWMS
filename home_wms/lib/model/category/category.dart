import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class ProductCategory {
  @HiveField(0)
  String name;

  ProductCategory(this.name);
}
