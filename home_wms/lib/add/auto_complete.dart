import 'package:hive/hive.dart';
import 'package:home_wms/model/products/products.dart';

class AutoCompleteProduct {
  static final List<Product> listProduct =
  Hive
      .box('products')
      .values
      .toList()
      .cast<Product>();

  static Future<List<Product>> getProductNameSuggestions(String query) async
  =>
      List.of(listProduct)
          .where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

}
